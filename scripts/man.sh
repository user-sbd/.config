#!/usr/bin/env bash

sel=$(apropos . | awk '{print $1}' | sort -u | fzf)
sel=${sel%%(*} 
tmux new-window -n man "man ${sel}"
