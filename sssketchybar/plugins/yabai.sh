#!/bin/bash

window_state() {
	source "$HOME/.config/sketchybar/colors.sh"
	source "$HOME/.config/sketchybar/icons.sh"

	WINDOW=$(yabai -m query --windows --window)
	CURRENT=$(echo "$WINDOW" | jq '.["stack-index"]')

	args=()
	if [[ $CURRENT -gt 0 ]]; then
		LAST=$(yabai -m query --windows --window stack.last | jq '.["stack-index"]')
		args+=(--set $NAME icon=$YABAI_STACK icon.color=$RED label.drawing=on label=$(printf "[%s/%s]" "$CURRENT" "$LAST"))
		yabai -m config active_window_border_color $RED >/dev/null 2>&1 &

	else
		args+=(--set $NAME label.drawing=off)
		case "$(echo "$WINDOW" | jq '.["is-floating"]')" in
		"false")
			if [ "$(echo "$WINDOW" | jq '.["has-fullscreen-zoom"]')" = "true" ]; then
				args+=(--set $NAME icon=$YABAI_FULLSCREEN_ZOOM icon.color=$GREEN)
				yabai -m config active_window_border_color $GREEN >/dev/null 2>&1 &
			elif [ "$(echo "$WINDOW" | jq '.["has-parent-zoom"]')" = "true" ]; then
				args+=(--set $NAME icon=$YABAI_PARENT_ZOOM icon.color=$BLUE)
				yabai -m config active_window_border_color $BLUE >/dev/null 2>&1 &
			else
				args+=(--set $NAME icon=$YABAI_GRID icon.color=$ORANGE)
				yabai -m config active_window_border_color $WHITE >/dev/null 2>&1 &
			fi
			;;
		"true")
			args+=(--set $NAME icon=$YABAI_FLOAT icon.color=$MAGENTA)
			yabai -m config active_window_border_color $MAGENTA >/dev/null 2>&1 &
			;;
		esac
	fi

	sketchybar -m "${args[@]}"
}

windows_on_spaces() {
	CURRENT_SPACES="$(yabai -m query --displays | jq -r '.[].spaces | @sh')"

	args=()
	while read -r line; do
		# The 'line' variable from CURRENT_SPACES (jq -r '.[].spaces | @sh')
		# is expected to be a series of shell-quoted space numbers, e.g., '1' '2' '3'
		# The `for space in $line` construct relies on word splitting to iterate through these.
		# This is a common pattern with yabai and jq @sh.
		for space in $line; do # SC2086: $line is intentionally unquoted here for word splitting.
			icon_strip=" "
			# Query apps for the current space, get unique app names, and process them.
			# The process substitution < <(...) feeds the output of the pipeline to the while loop.
			# `sort -u` ensures unique app names.
			# `jq -r '.[].app'` extracts app names.
			# "$space" is quoted to handle potential special characters if space names were not simple numbers.
			while IFS= read -r app; do
				if [ -n "$app" ]; then # Process only non-empty app names
					# "$app" is quoted for icon_map.sh
					# "$(...)" command substitution is quoted to prevent word splitting & globbing of its output.
					icon_strip+=" "$($HOME/.config/sketchybar/plugins/icon_map.sh "$app")""
				fi
			done < <(yabai -m query --windows --space "$space" | jq -r '.[].app' | sort -u)

			# "$space" is quoted here for robustness, forming e.g. space."1".
			args+=(--set space."$space" label="$icon_strip" label.drawing=on)
		done
	done <<<"$CURRENT_SPACES"

	sketchybar -m "${args[@]}"
}

mouse_clicked() {
	yabai -m window --toggle float
	window_state
}

case "$SENDER" in
"mouse.clicked")
	mouse_clicked
	;;
"forced")
	exit 0
	;;
"window_focus")
	window_state
	;;
"windows_on_spaces")
	windows_on_spaces
	;;
esac
