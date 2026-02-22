#!/bin/bash

# Check if a date argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 YYYY-MM-DD"
    exit 1
fi

TARGET_DATE="$1"

# Convert the target date to Unix epoch time (seconds)
# The -d flag allows parsing various date formats.
# The +%s flag formats the output as seconds since the epoch.
TARGET_SECONDS=$(date -d "$TARGET_DATE" "+%s")

# Get the current date in Unix epoch time (seconds)
NOW_SECONDS=$(date "+%s")

# Calculate the difference in seconds
DIFF_SECONDS=$((TARGET_SECONDS - NOW_SECONDS))

# The number of seconds in a day is 86400 (24 * 60 * 60)
SECONDS_PER_DAY=86400

# Calculate the difference in days using integer division
DAYS_LEFT=$((DIFF_SECONDS / SECONDS_PER_DAY))

# Output the result
echo "$DAYS_LEFT days left until $TARGET_DATE"

