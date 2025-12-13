#!/bin/sh

# vim or neovim
vim_type="nvim"
# (n)vim binary to use
vim_bin="/Users/nitin/Downloads/nvim/bin/nvim"

dir_name="gitlog-vim"
config_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/${dir_name}"
config_file="${config_dir}/configrc"

if [ -f "$config_file" ]; then
	. "$config_file"
else
	if [ ! -d "$config_dir" ]; then
		mkdir -p "$config_dir"
	fi
	cat <<__HEREDOC__ >>"$config_file"
# vim: ft=sh
# glo config file

# vim binary
# the vim binary to execute, if you usually run vim through
# a wrapper this is the place to specify it, so long as the
# wrapper is in your PATH the full path is not needed.
vim_bin="${vim_bin}"

# vim type
# accepted values are: vim, neovim
# the vim script for achieving the intended function is ever
# so different in vim and neovim so this is necessary for the
# script to work as intended.
vim_type="${vim_type}"
neovim
fi

myname="${0##*/}"

version="@VERSION@"

# usage: is_num "value"
is_num() {
	printf %d "$1" >/dev/null 2>&1
}

last_line=""
run_glo() {
	git rev-parse 2>/dev/null || return 1
	local_git_cmd="git --no-pager log --oneline --color=always ${*:--n 128}"
	case "$vim_type" in
	neovim)
		last_line="+term $local_git_cmd"
		;;
	vim)
		last_line="+call term_start('$local_git_cmd', {'hidden': 1, 'term_cols': 2048, 'term_finish': 'open', 'term_opencmd': 'buffer %d'})"
		;;
	esac
	$vim_bin \
		'+nnoremap <silent> q :q!<CR>' \
		'+nnoremap <silent> Q :qa!<CR>' \
		"+nnoremap <silent> K 0:tabnew \| setfiletype git \| exe 'read! git --no-pager show <C-r><C-w>' \| norm ggdd<CR>" \
		"$last_line"
}

get_unreleased_commits() {
	commits=""
	tag_name=$(LANG=C git describe --tags 2>/dev/null)
	case "$tag_name" in
	"fatal: "*)
		tag_name=""
		;;
	*)
		tag_name="${tag_name%%-*}"
		;;
	esac
	if [ -n "$tag_name" ]; then
		commits="${tag_name}...HEAD"
	fi
	printf '%s' "$commits"
}

# space width
sw=4
# option string width
ow=20

show_usage() {
	printf '%s\n' "Usage"
	printf '%*s' "$sw" " "
	printf '%s\n' "${myname}: -h | -v | -u | -n <N>"
}

show_help() {
	printf '%s\n' "$myname"
	printf '%*s' "$sw" " "
	printf '%s\n' "a small shell wrapper to view git logs in (neo)vim"
	show_usage
	printf '%s\n' "Options:"
	printf '%*s' "$sw" " "
	printf '%-*s ' "$ow" "-n <NUM>"
	printf ' %s\n' "view the last NUM number of commits"
	printf '%*s' "$sw" " "
	printf '%-*s ' "$ow" "-u"
	printf ' %s\n' "view the commits since last release tag"
	printf '%*s' "$sw" " "
	printf '%-*s ' "$ow" "-h, --help, help"
	printf ' %s\n' "show this help message"
	printf '%*s' "$sw" " "
	printf '%-*s ' "$ow" "-v, --version"
	printf ' %s\n' "show version number"
	printf '%s\n' "Version:"
	printf '%*s' "$sw" " "
	printf '%s\n' "$version"
	printf '%s\n' "Config:"
	printf '%*s' "$sw" " "
	printf '%s\n' "$config_file"
}

if [ "$#" -lt 1 ]; then
	run_glo "$@"
else
	case "$1" in
	'-n')
		if is_num "$2"; then
			if [ "$2" -gt 0 ]; then
				run_glo "$@"
			else
				printf '%s\n' \
					"${myname}: argument for -n '${2}' not in valid range!"
			fi
		else
			printf '%s\n' \
				"${myname}: argument for -n '${2}' is not a number!"
			exit 1
		fi
		;;
	'-u')
		run_glo "$(get_unreleased_commits)"
		;;
	'-h' | '--help' | 'help')
		show_help
		exit 0
		;;
	'-v' | '--version')
		printf '%s\n' "$version"
		;;
	*)
		printf '%s\n' "${myname}: invalid argument '$1'"
		show_usage
		exit 1
		;;
	esac
fi
