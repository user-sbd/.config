fcd() {
    local out key selected query real_path display_path
    local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/fcd"
    mkdir -p "$cache_dir"

    local -a sources unique_sources
    sources+=("$HOME/.config")
    [[ -d "$HOME/Documents" ]] && sources+=("$HOME/Documents")

    local -a roots=(
        "$HOME/Documents"
        "$HOME/Documents/SEE"
        "$HOME/Documents/projects"
        "$HOME/Documents/notes"
    )

    local root sub
    for root in "${roots[@]}"; do
        [[ -d "$root" ]] || continue
        while IFS= read -r -d '' sub; do
            sources+=("$sub")
        done < <(find "$root" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null)
    done

    local -A seen
    for dir in "${sources[@]}"; do
        [[ -d "$dir" && -z "${seen[$dir]}" ]] || continue
        seen[$dir]=1
        unique_sources+=("$dir")
    done

    out=$(
        for abs in "${unique_sources[@]}"; do
            if [[ $abs == $PWD*(/) ]]; then
                display_path="${abs#$PWD/}"
                [[ -z $display_path ]] && display_path="."
            else
                display_path="${abs/#$HOME/~}"
            fi
            print -r -- "$abs"$'\t'"$display_path"
        done | sort -t $'\t' -k2 |

        fzf \
            --height 60% --reverse --inline-info --no-multi \
            --with-nth 2.. \
            --delimiter '\t' \
            --expect=enter,ctrl-o,ctrl-t,ctrl-y,ctrl-x \
            --print-query \
            --preview-window right:55%:wrap \
            --bind 'ctrl-c:abort,esc:abort'
    )

    zle reset-prompt
    [[ -z "$out" ]] && return 0

    query=$(sed -n 1p <<<"$out")
    key=$(sed -n 2p <<<"$out")
    selected=$(sed -n 3p <<<"$out")

    if [[ -z "$selected" && -n "$query" ]]; then
        real_path="${PWD}/${query}"
        real_path="${real_path:A}"
        [[ -d "$real_path" ]] && { cd -P "$real_path" && zle reset-prompt; return 0; }
        read -q "?Create '$real_path'? [y/N] " || return 0
        echo
        mkdir -p "$real_path" || return 1
    else
        real_path="${selected%%$'\t'*}"
    fi

    [[ ! -d "$real_path" ]] && return 1

    case "$key" in
        enter)
            cd -P "$real_path"
            ;;
        ctrl-o)
            ${EDITOR:-vi} "$real_path"
            ;;
        ctrl-t|ctrl-y)
            [[ -n "$TMUX" ]] && tmux new-window -c "$real_path"
            ;;
        ctrl-x)
            if (( $+commands[wl-copy] )); then
                print -rn -- "$real_path" | wl-copy
            elif (( $+commands[pbcopy] )); then
                print -rn -- "$real_path" | pbcopy
            elif (( $+commands[xclip] )); then
                print -rn -- "$real_path" | xclip -selection clipboard
            fi
            ;;
    esac

    zle reset-prompt
    return 0
}

zle -N fcd_widget fcd
bindkey '^o' fcd_widget
