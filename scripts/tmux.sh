#!/bin/bash

# Use find to get full paths of directories in ~/Documents (excluding ~/Documents itself)
# Exclude specific folders: Image-Line, Mighty, "REAPER Media"
doc_dirs=$(find ~/Documents -maxdepth 2 -type d \
    -not -path ~/Documents \
    -not -path "*/Image-Line*" \
    -not -path "*/Mighty*" \
    -not -path "*/REAPER Media*")

# Include '.config' as a separate option, but display it as just '.config'
picker_dirs=$( {
    printf '%s\n' "$doc_dirs"
    echo ".config"
} | sort -u | sed "s|^$HOME/Documents/||")

# Display the list of directories to sk for selection
selected=$(echo "$picker_dirs" | sk --color="bw" --margin 10%)

# Check if selection is empty
if [ -z "$selected" ]; then
    echo "No selection made"
    exit 0
fi

# Handle the selected path:
if [ "$selected" == ".config" ]; then
    selected_path="$HOME/.config"
else
    selected_path="$HOME/Documents/$selected"
fi

# Get the basename and replace dots with underscores for the tmux session name
session=$(basename "$selected_path" | tr '.' '_')

# Create the session if it doesn't exist, detached, with working directory
if ! tmux has-session -t "$session" 2>/dev/null; then
    tmux new-session -d -s "$session" -c "$selected_path"
fi

# Attach or switch depending on whether inside tmux
if [ -n "$TMUX" ]; then
    tmux switch-client -t "$session"
else
    tmux attach-session -t "$session"
fi
