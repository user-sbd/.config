#!/usr/bin/env bash
# Rectangular active workspace with border + filled background

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    # Active: White filled box with border + black text
    sketchybar --set "$NAME" \
        background.drawing=on \
        background.color=0xffffffff \        # White fill
        background.border_color=0xff1a1a1a \ # Dark border
        background.border_width=2 \
        background.corner_radius=6 \
        background.height=26 \
        label.color=0xff1a1a1a               # Black number
else
    # Inactive: Just white number, no box
    sketchybar --set "$NAME" \
        background.drawing=off \
        label.color=0xffffffff
fi
