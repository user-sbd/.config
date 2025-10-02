#!/bin/bash
PWD=$(tmux display-message -p -t "${TMUX_PANE:-.}" '#{pane_current_path}')
cd "$PWD" && open $(git remote get-url origin)
