#!/usr/bin/bash

if [ $(pgrep -f gnome-terminal-server | wc -l) -eq 0 ]; then
	# if gnome terminal is not running
	gnome-terminal -- tmux new-session -s main -n "/vi" vim $1
else
	# if gnome terminal is already running
	tmux new-window -n "/vi" vim $1
fi

# move terminal to most front
xdotool windowactivate $(xdotool search --class "Gnome-terminal" | tail -1)
#wmctrl -r :ACTIVE: -b add,above
