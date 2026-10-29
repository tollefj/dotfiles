#!/bin/bash
# Moves the previously focused window to the current workspace.

workspace=$(aerospace list-workspaces --focused)
current_window=$(aerospace list-windows --focused --format '%{window-id}')

aerospace focus-back-and-forth || exit
previous_window=$(aerospace list-windows --focused --format '%{window-id}')
[ "$previous_window" = "$current_window" ] && exit

aerospace move-node-to-workspace --window-id "$previous_window" "$workspace"
aerospace workspace "$workspace"
aerospace focus --window-id "$previous_window"
~/.config/aerospace/master-stack.sh
