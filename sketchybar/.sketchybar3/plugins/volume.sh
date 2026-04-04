#!/usr/bin/env bash
VOLUME=$(osascript -e 'output volume of (get volume settings)')
MUTED=$(osascript -e 'output muted of (get volume settings)')

if [ "$MUTED" = "true" ] || [ "$VOLUME" = "0" ]; then
    ICON="󰝟"
    COLOR=0xffa8a8a8      # gray when muted
elif [ "$VOLUME" -lt 34 ]; then
    ICON="󰕿"
    COLOR=0xffffffff
elif [ "$VOLUME" -lt 67 ]; then
    ICON="󰖀"
    COLOR=0xffffffff
else
    ICON="󰕾"
    COLOR=0xffffffff
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${VOLUME}%"
