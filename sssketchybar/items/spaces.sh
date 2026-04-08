#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Remove old space items
for item in $(sketchybar --query bar | jq -r '.items[] | select(startswith("space."))'); do
    sketchybar --remove "$item" 2>/dev/null || true
done

# Get current AeroSpace workspaces
WORKSPACES=$(aerospace list-workspaces --all)

for sid in $WORKSPACES; do
    sketchybar --add item "space.$sid" left \
        --set "space.$sid" \
            icon="$sid" \
            icon.font="$FONT:Bold:14.0" \
            icon.padding_left=9 \
            icon.padding_right=9 \
            padding_left=2 \
            padding_right=2 \
            icon.highlight_color=$RED \
            label.drawing=off \
            \
            background.drawing=off \           # Important: start with off
            background.color=$BACKGROUND_2 \
            background.height=24 \
            background.corner_radius=7 \
            --subscribe "space.$sid" aerospace_workspace_change \
            click_script="aerospace workspace $sid"
done

# Outer bracket (subtle container for all workspaces)
sketchybar --add bracket spaces '/space\..*/' \
    --set spaces \
        background.color=$BACKGROUND_1 \
        background.border_color=$BACKGROUND_2 \
        background.border_width=2 \
        background.height=28 \
        background.corner_radius=9 \
        background.drawing=on
