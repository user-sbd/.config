#!/bin/bash

# Calculate the number of days until April 1, 2026
target_date="2026-04-01"

if [ "$(uname -s)" = "Darwin" ]; then
  target_seconds=$(date -j -f "%Y-%m-%d" "$target_date" +%s)
else
  target_seconds=$(date -d "$target_date" +%s)
fi

current_seconds=$(date +%s)
days_left=$(( (target_seconds - current_seconds) / 86400 ))

echo "Days: $days_left"
