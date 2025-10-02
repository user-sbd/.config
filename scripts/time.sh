#!/bin/bash

CATEGORIES=(
    "CODING"
    "MUSIC"
    "WORKFLOW"
    "LEARNING"
    "VIDEO"
    "STOP"
)

selected=$(printf "%s\n" "${CATEGORIES[@]}" | sk --margin 10% --color="bw" --bind 'q:abort')
sk_status=$?

if [[ $sk_status -ne 0 || -z "$selected" ]]; then
    tmux set -g status-right ""
    exit 0
fi

tmux set -g status-interval 1

if [[ "$selected" == "STOP" ]]; then
    timew stop
    tmux set -g status-right ""
else
    timew start "$selected"
    tmux set -g status-right "#(timew | awk '/^ *Tracking/ {print \$NF \" \"}')#(timew | awk '/^ *Total/ {print \$NF}')"
fi
