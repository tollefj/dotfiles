#!/bin/bash
# Usage: focus-or-new.sh <bundle-id> [new-window-command]
# Focuses the app, or runs new-window-command if the app is already focused.
# New windows are kept on the current workspace, overriding on-window-detected rules.

bundle_id=$1
new_window_command=$2

lock_dir=/tmp/aerospace-focus-or-new.lock
mkdir "$lock_dir" 2>/dev/null || exit
trap 'rmdir "$lock_dir"' EXIT

focused_bundle_id=$(aerospace list-windows --focused --format '%{app-bundle-id}' 2>/dev/null)

if [ "$focused_bundle_id" != "$bundle_id" ] || [ -z "$new_window_command" ]; then
  open -b "$bundle_id"
  exit
fi

list_app_windows() {
  aerospace list-windows --monitor all --app-bundle-id "$bundle_id" --format '%{window-id}' | sort
}

wait_for_modifier_release() {
  osascript -l JavaScript -e '
    ObjC.import("AppKit");
    for (let i = 0; i < 40 && ($.NSEvent.modifierFlags & 0xFF0000); i++) delay(0.025);'
}

workspace=$(aerospace list-workspaces --focused)
existing_windows=$(list_app_windows)

wait_for_modifier_release
eval "$new_window_command"

for _ in $(seq 40); do
  new_window=$(comm -13 <(echo "$existing_windows") <(list_app_windows) | head -1)
  if [ -n "$new_window" ]; then
    aerospace move-node-to-workspace --window-id "$new_window" "$workspace"
    aerospace focus --window-id "$new_window"
    exit
  fi
  sleep 0.05
done
