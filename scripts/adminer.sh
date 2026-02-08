#!/usr/bin/env bash
# ~/Documents/adminer-temp.sh

set -euo pipefail

ADMINER_URL="https://www.adminer.org/latest.php"
TMP_FILE="adminer.php"

# Cleanup function
cleanup() {
    if [ -f "$TMP_FILE" ]; then
        printf '\033[31m→ Cleaning up %s\033[0m\n' "$TMP_FILE"
        rm -f "$TMP_FILE"
    fi
}

trap cleanup EXIT INT TERM

printf '\033[36mDownloading latest Adminer...\033[0m\n'

if ! curl -L -o "$TMP_FILE" -f --progress-bar "$ADMINER_URL"; then
    printf '\033[31m✗ Download failed\033[0m\n' >&2
    exit 1
fi

if [ ! -s "$TMP_FILE" ]; then
    printf '\033[31m✗ Downloaded file is empty\033[0m\n' >&2
    exit 2
fi

printf '\n'
printf '\033[32mStarting PHP server → http://127.0.0.1:8042\033[0m\n'
printf '   (close browser tab + press Ctrl+C here when finished)\n\n'

# Run server (blocks until Ctrl+C)
php -S 127.0.0.1:8042 "$TMP_FILE" 2>&1 | grep --line-buffered -v "Development Server.*started"

# After Ctrl+C the trap runs cleanup automatically
