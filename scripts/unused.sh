#!/bin/bash

CURRENT_SESSION=$(tmux display-message -p '#S')


SESSIONS=$(tmux list-sessions -F '#{session_name}' | grep -v "^$CURRENT_SESSION$")

if [ -z "$SESSIONS" ]; then
  sleep 2
  exit 0
fi


while read -r session; do
  if [[ -n $session && $session != "$CURRENT_SESSION" ]]; then
    tmux kill-session -t "$session"
  fi
done <<< "$SESSIONS"

