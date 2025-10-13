#!/usr/bin/env bash

sel=$(apropos . | awk '{print $1}' | sort -u | sk --color='bw' --margin 10%)
sel=${sel%%(*} 
tmux new-window -n man "man ${sel}"
