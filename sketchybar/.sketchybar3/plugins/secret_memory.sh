#!/usr/bin/env bash
# Super Secret Folder: Disk Used / Total (e.g. 245G/512G)

# Get Used and Total for the root filesystem in human-readable format
DISK_INFO=$(df -h / | awk 'NR==2 {print $3 "/" $2}')

sketchybar --set "$NAME" label="ph: ${DISK_INFO}"
