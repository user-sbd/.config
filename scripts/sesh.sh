#!/bin/bash

DIRS=(
    "$HOME/documents/projects"
    "$HOME/documents"
    "$HOME/documents/notes"
)

# Function to create directory if it doesn't exist
create_directory() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        echo "Directory '$dir' does not exist."
        read -p "Would you like to create it? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mkdir -p "$dir"
            echo "Directory created: $dir"
            return 0
        else
            echo "Directory not created. Exiting."
            return 1
        fi
    fi
    return 0
}

# Function to check if directory is under documents/notes
is_notes_dir() {
    local dir="$1"
    local notes_path="$HOME/documents/notes"
    if [[ "$dir" == "$notes_path"* ]]; then
        return 0  # true, it's a notes directory
    else
        return 1  # false, not a notes directory
    fi
}

if [[ $# -eq 1 ]]; then
    selected=$1
    # Check if the entered path exists as directory, if not prompt to create
    if [[ ! -d "$selected" ]]; then
        if ! create_directory "$selected"; then
            exit 0
        fi
    fi
else
    # Search with different depths for different directories
    selected=$(
        {
            # documents/projects: max-depth 3
            fd . "$HOME/documents/projects" --type=dir --max-depth=1 --full-path
            # documents (but not projects subdir to avoid duplicates): max-depth 2
            fd . "$HOME/documents" --type=dir --max-depth=1 --full-path --exclude projects
        } | sort -u | sed "s|^$HOME/||" \
        | sk --color=bw \
          --height=70% \
          --margin=10%,20%,20%,20% \
          --layout reverse \
          --print-query \
          --expect=enter
    )
    
    # Extract query and selection
    query=$(echo "$selected" | head -1)
    selection=$(echo "$selected" | tail -n +2)
    
    # If nothing selected but query exists, use query as path
    if [[ -z "$selection" && -n "$query" ]]; then
        selected="$HOME/$query"
    elif [[ -n "$selection" ]]; then
        selected="$HOME/$selection"
    else
        selected=""
    fi
fi

[[ ! $selected ]] && exit 0

# Check if selected directory exists, if not prompt to create
if [[ ! -d "$selected" ]]; then
    if ! create_directory "$selected"; then
        exit 0
    fi
fi

selected_name=$(basename "$selected" | tr . _)

if ! tmux has-session -t "$selected_name"; then
    # Check if this is a notes directory or subdirectory
    if is_notes_dir "$selected"; then
        # Simple session with just one window for notes
        tmux new-session -ds "$selected_name" -c "$selected"
        tmux send-keys -t "${selected_name}:1" "clear" C-m
    else
        # Full session with multiple windows for projects
        tmux new-session -ds "$selected_name" -c "$selected" -n TODO
        
        # Window 1: nvim todo
        tmux send-keys -t "${selected_name}:TODO" "nvim todo" C-m
        
        # Window 2: nvim . (main edit window)
        tmux new-window -t "$selected_name" -n EDIT -c "$selected"
        tmux send-keys -t "${selected_name}:EDIT" "nvim ." C-m
        
        # Window 3: terminal
        tmux new-window -t "$selected_name" -n TERM -c "$selected"
        
        # Start on window 1 (TODO)
        tmux select-window -t "${selected_name}:TODO"
    fi
fi

tmux switch-client -t "$selected_name"
