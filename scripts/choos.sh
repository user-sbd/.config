#!/usr/bin/env bash

pdf_dir="$HOME/Documents/pdfs"

# ────────────────────────────────────────────────
#  Find PDFs → show macOS native choose-gui picker
# ────────────────────────────────────────────────

selected=$(find "$pdf_dir" -type f -maxdepth 1 -iname '*.pdf' 2>/dev/null \
    | sort \
    | xargs -n 1 basename -s .pdf \
    | choose "> ")

# If nothing was selected (user cancelled) → exit silently
[ -z "$selected" ] && exit 0

# Full path
pdf_path="$pdf_dir/$selected.pdf"

# Open in background, bring Sioyek window to front
open -g -a Sioyek --args "$pdf_path" &

# Small delay + try to focus the new window (macOS + AeroSpace)
sleep 0.6
aerospace focus --app "Sioyek" 2>/dev/null || true

# Alternative focus methods you can try (uncomment one if needed):
# osascript -e 'tell application "Sioyek" to activate' 2>/dev/null
# aerospace focus --window --app "Sioyek"  # sometimes more reliable
