fcd() {
    local out key selected query real_path
    local cache_dir="$HOME/.cache/fcd"

    mkdir -p "$cache_dir"

    out=$(
        {
            echo "$HOME/.config"
            echo "$HOME/Documents"
            find "$HOME/Documents"          -mindepth 1 -maxdepth 1 -type d 2>/dev/null
            find "$HOME/Documents/SEE"      -mindepth 1 -maxdepth 1 -type d 2>/dev/null
            find "$HOME/Documents/projects" -mindepth 1 -maxdepth 1 -type d 2>/dev/null
            find "$HOME/Documents/notes"    -mindepth 1 -maxdepth 1 -type d 2>/dev/null
        } | sort -u |
        while IFS= read -r abs; do
            echo "$abs"$'\t'"${abs/#$HOME/~}"
        done |
        FCD_CACHE_DIR="$cache_dir" fzf \
            --height 60% --reverse --inline-info --no-multi \
            --with-nth=2.. \
            --delimiter=$'\t' \
            --expect=enter,ctrl-o,ctrl-t,ctrl-e,ctrl-x \
            --print-query \
            --preview '
                p={1}
                cache="$FCD_CACHE_DIR/$(print -rn -- "$p" | sha1sum | cut -d" " -f1).preview"

                dir_mtime=$(stat -c %Y "$p" 2>/dev/null)
                cache_mtime=$(stat -c %Y "$cache" 2>/dev/null)

                if [[ -f "$cache" && "$cache_mtime" -ge "$dir_mtime" ]]; then
                    cat "$cache"
                else
                    echo "⏳ Generating preview…"
                    (
                        {
                            du -sh "$p" 2>/dev/null
                            echo
                            echo "$p"
                            echo "───"
                            ls -laF --color=auto "$p" 2>/dev/null | head -100
                            echo
                            echo "Files:"
                            find "$p" -type f 2>/dev/null | wc -l
                        } >| "$cache".tmp && mv "$cache".tmp "$cache"
                    ) &!
                fi
            ' \
            --preview-window=right:50%
    )

    [[ -z "$out" ]] && return 0

    query=$(sed -n '1p' <<<"$out")
    key=$(sed -n '2p' <<<"$out")
    selected=$(sed -n '3p' <<<"$out")

    if [[ -z "$selected" && -n "$query" ]]; then
        real_path="${~query}"
        if [[ ! -d "$real_path" ]]; then
            read -q "?Create directory '$real_path'? [y/N] " || return 0
            echo
            mkdir -p "$real_path" || return 1
        fi
    else
        real_path="${selected%%$'\t'*}"
    fi

    [[ -z "$real_path" ]] && return 0

    case "$key" in
        enter)
            cd -P "$real_path" || return 1
            ;;
        ctrl-o)
            "$EDITOR" "$real_path"
            ;;
        ctrl-t)
            if [[ -n "$TMUX" ]]; then
                tmux new-window -c "$real_path"
            else
                echo "Not in tmux"
            fi
            ;;
        ctrl-e)
            cd -P "$real_path" || return 1
            fzf
            ;;
        ctrl-x)
            if command -v wl-copy >/dev/null; then
                print -rn "$real_path" | wl-copy
            elif command -v pbcopy >/dev/null; then
                print -rn "$real_path" | pbcopy
            else
                print -rn "$real_path" | xclip -selection clipboard
            fi
            ;;
    esac

    zle reset-prompt
    return 0
}

zle -N fcd_widget fcd
bindkey '^O' fcd_widget
