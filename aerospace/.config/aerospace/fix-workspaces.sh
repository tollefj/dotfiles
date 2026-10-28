#!/bin/bash
# Sends every window to the workspace it would get if opened new, then rebuilds master-stack.
# Keep app rules in sync with [[on-window-detected]] in .aerospace.toml.

app_workspace() {
  case $1 in
    com.googlecode.iterm2|com.anthropic.claudefordesktop) echo 1 ;;
    com.microsoft.teams2|org.whispersystems.signal-desktop|com.tinyspeck.slackmacgap) echo 3 ;;
    com.microsoft.Outlook|com.apple.mail) echo 4 ;;
    md.obsidian|com.apple.Preview) echo 5 ;;
    com.microsoft.Word|com.microsoft.Powerpoint|com.microsoft.Excel) echo 6 ;;
    *) echo 2 ;;
  esac
}

floating_apps=" com.apple.systempreferences com.apple.finder "

waterfox_profile_workspaces=(
  "q9V5tM8C.Profile 2:6"
  "26886r2e.default-release:2"
)

waterfox_workspace() {
  for entry in "${waterfox_profile_workspaces[@]}"; do
    if [ "$(~/.config/aerospace/waterfox-profile-pid.sh "${entry%:*}")" = "$1" ]; then
      echo "${entry##*:}"
      return
    fi
  done
  echo 2
}

while IFS='|' read -r id app pid; do
  [[ "$floating_apps" == *" $app "* ]] && continue
  if [ "$app" = net.waterfox.waterfox ]; then
    target=$(waterfox_workspace "$pid")
  else
    target=$(app_workspace "$app")
  fi
  aerospace move-node-to-workspace --window-id "$id" "$target"
done < <(aerospace list-windows --all --format '%{window-id}|%{app-bundle-id}|%{app-pid}')

~/.config/aerospace/master-stack.sh
