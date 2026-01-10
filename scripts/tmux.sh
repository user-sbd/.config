#!/bin/bash


doc_dirs=$(find ~/Documents -maxdepth 2 -type d \
    -not -path ~/Documents \
    -not -path "*/Image-Line*" \
    -not -path "*/Mighty*" \
    -not -path "*/REAPER Media*" \
	)

picker_dirs=$( {
    printf '%s\n' "$doc_dirs"
    echo ".config"
} | sort -u | sed "s|^$HOME/||")

selected=$(echo "$picker_dirs" | sk --color="bw" --margin 10%)
# selected=$(echo "$picker_dirs" | fzf )

if [ -z "$selected" ]; then
    echo "No selection made"
    exit 0
fi

if [ "$selected" == ".config" ]; then
    selected_path="$HOME/.config"
else
    selected_path="$HOME/$selected"
fi

session=$(basename "$selected_path" | tr '.' '_')

if ! tmux has-session -t "$session" 2>/dev/null; then
    tmux new-session -d -s "$session" -c "$selected_path"
fi

if [ -n "$TMUX" ]; then
    tmux switch-client -t "$session"
else
    tmux attach-session -t "$session"
fi
