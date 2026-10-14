#!/bin/bash
# Usage: focus-or-new.sh <bundle-id> [new-window-command] [pid-command]
# Focuses the app, or runs new-window-command if the app is already focused.
# With pid-command (prints a PID), only windows of that process count.
# New windows are kept on the current workspace, overriding on-window-detected rules.

bundle_id=$1
new_window_command=$2
pid_command=$3

lock_dir=/tmp/aerospace-focus-or-new.lock
mkdir "$lock_dir" 2>/dev/null || exit
trap 'rmdir "$lock_dir"' EXIT

app_pid=
resolve_pid() {
  [ -n "$pid_command" ] && [ -z "$app_pid" ] && app_pid=$(eval "$pid_command")
}

list_app_windows() {
  [ -n "$pid_command" ] && [ -z "$app_pid" ] && return
  aerospace list-windows --monitor all --app-bundle-id "$bundle_id" --format '%{window-id} %{app-pid}' \
    | awk -v pid="$app_pid" 'pid == "" || $2 == pid { print $1 }' | sort
}

resolve_pid

is_focused() {
  local focused_window
  focused_window=$(aerospace list-windows --focused --format '%{window-id}' 2>/dev/null)
  [ -n "$focused_window" ] && list_app_windows | grep -qx "$focused_window"
}

if ! is_focused || [ -z "$new_window_command" ]; then
  if [ -z "$pid_command" ]; then
    open -b "$bundle_id"
    exit
  fi
  existing_window=$(list_app_windows | head -1)
  if [ -n "$existing_window" ]; then
    aerospace focus --window-id "$existing_window"
    exit
  fi
fi

wait_for_modifier_release() {
  osascript -l JavaScript -e '
    ObjC.import("AppKit");
    for (let i = 0; i < 40 && ($.NSEvent.modifierFlags & 0xFF0000); i++) delay(0.025);'
}

workspace=$(aerospace list-workspaces --focused)
existing_windows=$(list_app_windows)

wait_for_modifier_release
eval "$new_window_command"

for _ in $(seq 100); do
  resolve_pid
  new_window=$(comm -13 <(echo "$existing_windows") <(list_app_windows) | head -1)
  if [ -n "$new_window" ]; then
    aerospace move-node-to-workspace --window-id "$new_window" "$workspace"
    aerospace focus --window-id "$new_window"
    exit
  fi
  sleep 0.02
done
