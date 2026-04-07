#!/bin/bash

DIRS=(
    "$HOME"
    "$HOME/documents/projects"
    "$HOME/documents"
    "$HOME/documents/notes"
)


if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(fd . "${DIRS[@]}" --type=dir --max-depth=1 --full-path --base-directory $HOME \
        | sed "s|^$HOME/||" \
        | sk --color=bw \
          --height=70% \
          --margin=10%,20%,20%,20% --layout reverse \
      )
    [[ $selected ]] && selected="$HOME/$selected"
fi

[[ ! $selected ]] && exit 0

selected_name=$(basename "$selected" | tr . _)

if ! tmux has-session -t "$selected_name"; then
    tmux new-session -ds "$selected_name" -c "$selected"
    tmux select-window -t "$selected_name:1"
fi

tmux switch-client -t "$selected_name"
