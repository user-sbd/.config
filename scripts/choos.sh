#!/usr/bin/env bash

pdf_dir="$HOME/Documents/pdfs"

selected=$(find "$pdf_dir" -type f -maxdepth 1 -iname '*.pdf' 2>/dev/null \
    | sort \
    | xargs -n 1 basename -s .pdf \
    | choose )

[ -z "$selected" ] && exit 0

pdf_path="$pdf_dir/$selected.pdf"

open -g -a Sioyek --args "$pdf_path" &

