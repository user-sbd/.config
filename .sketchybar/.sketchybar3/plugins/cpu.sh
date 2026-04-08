#!/usr/bin/env bash
CPU=$(top -l 1 -n 0 | awk '/CPU usage/ {gsub(/%/,""); print int($3 + $5)}')

if [ "$CPU" -ge 80 ]; then
    COLOR=0xffffffff      # white = high load (stands out)
elif [ "$CPU" -ge 50 ]; then
    COLOR=0xfff8f8f8
else
    COLOR=0xffa8a8a8      # gray for low usage
fi

sketchybar --set "$NAME" icon.color="$COLOR" label="${CPU}%"
