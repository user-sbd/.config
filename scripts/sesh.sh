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
    [[ "$dir" == "$notes_path"* ]]
}

# If a directory was passed as argument
if [[ $# -eq 1 ]]; then
    selected="$1"
    if [[ ! -d "$selected" ]]; then
        if ! create_directory "$selected"; then
            exit 0
        fi
    fi
else
    # Fuzzy finder selection
    selected=$(
        {
            # projects: max-depth 1
            fd . "$HOME/documents/projects" --type=dir --max-depth=1 --full-path
            # documents (excluding projects to avoid duplicates)
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

    if [[ -z "$selection" && -n "$query" ]]; then
        selected="$HOME/$query"
    elif [[ -n "$selection" ]]; then
        selected="$HOME/$selection"
    else
        selected=""
    fi
fi

[[ -z "$selected" ]] && exit 0

# Create directory if it doesn't exist
if [[ ! -d "$selected" ]]; then
    if ! create_directory "$selected"; then
        exit 0
    fi
fi

selected_name=$(basename "$selected" | tr . _)

# Create or attach to tmux session (single window only)
if ! tmux has-session -t "$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
    
    # Optional: clear the screen on start
    tmux send-keys -t "$selected_name" "clear" C-m
fi

tmux switch-client -t "$selected_name"
