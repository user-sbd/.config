#!/usr/bin/env bash

# aerospace.sh <workspace_name>

WORKSPACE=$1
FOCUSED=$(aerospace list-workspaces --focused)

if [ "$WORKSPACE" = "$FOCUSED" ]; then
    # Only the current workspace gets the background (hover/pill)
    sketchybar --set "space.$WORKSPACE" \
        background.drawing=on \
        icon.highlight=on
else
    # All other workspaces have no background
    sketchybar --set "space.$WORKSPACE" \
        background.drawing=off \
        icon.highlight=off
fi
