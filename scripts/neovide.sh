#!/bin/zsh
# @raycast.schemaVersion 1
# @raycast.title Neovide
# @raycast.mode silent
# @raycast.icon ~/Downloads/neovide.png
# @raycast.description Open Neovide frameless with bob nightly

# Force the exact nvim binary (bypasses PATH/shell lookup crash)
exec /opt/homebrew/bin/neovide \
  --neovim-bin "/Users/nitin/.local/share/bob/nightly/bin/nvim" \
  --frame buttonless \
  --title-hidden \
  "$@"
