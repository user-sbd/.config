#!/usr/bin/env bash

# This script listens to Aerospace events and triggers Sketchybar updates
# Add this to your aerospace.toml config

EVENT=$1
WORKSPACE=$2

case "$EVENT" in
    "workspace_change")
        sketchybar --trigger aerospace_workspace_change FOCUSED="$WORKSPACE"
        ;;
    "window_created" | "window_destroyed")
        sketchybar --trigger aerospace_window_change
        ;;
    *)
        ;;
esac
