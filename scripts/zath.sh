#!/bin/bash

pdf_dir="$HOME/Documents/pdfs"

selected=$(find "$pdf_dir" -type f -name '*.pdf' -exec basename {} .pdf \; |
				sk --color="bw" --margin 10% --bind 'q:abort'
)

if [ -n "$selected" ]; then
    tmux new-window -d "Sioyek '$pdf_dir/$selected.pdf'"
		sleep 0.7
		aerospace focus --dfs-index 1 
fi

