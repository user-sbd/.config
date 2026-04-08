#!/bin/bash

calendar=(
	icon=$CLOCK
	icon.color=$RED
	update_freq=30
	script="$PLUGIN_DIR/clock.sh"
)

status_bracket2=(
	background.color=$BACKGROUND_1
	background.border_color=$BACKGROUND_2
	background.border_width=2
)

sketchybar --add item calendar right \
	--set calendar "${calendar[@]}"

sketchybar --add bracket clocks calendar \
	--set clocks "${status_bracket2[@]}"
