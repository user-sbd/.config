# cd into subdirectories of only selected roots
pjd() {  # "projects deep"
    local roots=(
        ~/Documents/projects
				~/.config/
				~/Documents/notes
				~/Documents
    )

    local selected
    selected=$(
        fd --type d --hidden --max-depth 4 . "${roots[@]}" 2>/dev/null |
        sed "s|^$HOME/||" |  # nicer display (optional)
        fzf --height 70% --reverse --preview 'eza -T --level=2 --color=always ~/"{}"' --preview-window=right:50%
    )

    [[ -n "$selected" ]] && cd ~/"$selected"
}
