#!/usr/bin/env bash
PERCENTAGE=$(pmset -g batt | grep -Eo '[0-9]+%' | tr -d '%')
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ -z "$PERCENTAGE" ]; then
    sketchybar --set "$NAME" icon="󱉝" label="?" 
    exit 0
fi

if [ -n "$CHARGING" ]; then
    ICON="󰂄"
    COLOR=0xffffffff      # white for charging
elif [ "$PERCENTAGE" -ge 80 ]; then
    ICON="󰁹"
    COLOR=0xffffffff
elif [ "$PERCENTAGE" -ge 40 ]; then
    ICON="󰁾"
    COLOR=0xfff8f8f8
else
    ICON="󰁺"
    COLOR=0xfff8f8f8      # still white, but slightly softer on low battery
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
