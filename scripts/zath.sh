#!/bin/bash

pdf_dir="$HOME/Documents/pdfs"

selected=$(find "$pdf_dir" -type f -name '*.pdf' -exec basename {} .pdf \; |
	sk --margin 10% --color="bw"
)

if [ -n "$selected" ]; then
    tmux new-window -d "Sioyek '$pdf_dir/$selected.pdf'"
		sleep 0.7
		aerospace focus --dfs-index 1 
fi

