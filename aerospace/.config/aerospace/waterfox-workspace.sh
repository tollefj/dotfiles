#!/bin/bash
# Moves the newest Waterfox window to the workspace assigned to its profile.
# Skipped while focus-or-new.sh is placing the window on the current workspace.

[ -d /tmp/aerospace-focus-or-new.lock ] && exit

profile_workspaces=(
  "q9V5tM8C.Profile 2:2"
  "26886r2e.default-release:6"
)

read -r window_id window_pid < <(
  aerospace list-windows --monitor all --app-bundle-id net.waterfox.waterfox --format '%{window-id} %{app-pid}' \
    | sort -n | tail -1
)
[ -z "$window_id" ] && exit

for _ in $(seq 50); do
  for entry in "${profile_workspaces[@]}"; do
    if [ "$(~/.config/aerospace/waterfox-profile-pid.sh "${entry%:*}")" = "$window_pid" ]; then
      aerospace move-node-to-workspace --window-id "$window_id" "${entry##*:}"
      exit
    fi
  done
  sleep 0.1
done

aerospace move-node-to-workspace --window-id "$window_id" 2
