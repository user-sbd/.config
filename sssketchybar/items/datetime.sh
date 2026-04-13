#!/usr/bin/env bash

# Add the item (safe if already exists)
sketchybar --add item datetime right

# Force live updates and override aggressive defaults
sketchybar --set datetime \
  icon.drawing=off \
  label.padding_left=10 \
  label.padding_right=18 \
  label.font="SF Mono:Semibold:13.0" \
  background.padding_right=12 \
  update_freq=1 \
  updates=on \
  --subscribe datetime system_woke

# Your exact requested format + Kathmandu timezone
# Example: Sat Apr 11 08:35:27 PM
update_clock() {
  sketchybar --set datetime label="$(TZ=Asia/Kathmandu date '+%a %b %d %I:%M:%S %p')"
}

# Initial update
update_clock

# Persistent loop for live second-by-second updates (most reliable in practice)
# Sleep 0.9s to stay aligned without high CPU
while true; do
  update_clock
  sleep 0.9
done
