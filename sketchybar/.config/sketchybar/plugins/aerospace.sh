#!/bin/bash
POPUP_SECONDS=1.2
TOKEN_FILE="${TMPDIR:-/tmp}/sketchybar_ws_popup"
COLOR_TEXT=0xffcdd6f4
COLOR_ON_ACCENT=0xff1e1e2e
COLOR_EMPTY=0xff6c7086
COLOR_ATTENTION=0xffff1744

workspace_name() {
  case $1 in
    1) echo Terminal ;;
    2) echo Web ;;
    3) echo Chat ;;
    4) echo Mail ;;
    5) echo Notes ;;
    *) echo "Workspace $1" ;;
  esac
}

workspace_apps() {
  case $1 in
    3) printf '%s\n' "Slack" "Microsoft Teams" "Signal" ;;
    4) printf '%s\n' "Mail" "Microsoft Outlook" ;;
  esac
}

app_badge() {
  lsappinfo info -only StatusLabel "$1" 2>/dev/null | sed -n 's/.*"label"="\([^"]*\)".*/\1/p'
}

needs_attention() {
  local app
  while IFS= read -r app; do
    [ -n "$(app_badge "$app")" ] && return 0
  done < <(workspace_apps "$1")
  return 1
}

sid=$1
focused=${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}
windows=$(aerospace list-windows --workspace "$sid" --count 2>/dev/null || echo 0)

if [ "$sid" = "$focused" ]; then
  sketchybar --set "$NAME" background.drawing=on label.color=$COLOR_ON_ACCENT
elif needs_attention "$sid"; then
  sketchybar --set "$NAME" background.drawing=off label.color=$COLOR_ATTENTION popup.drawing=off
elif [ "$windows" -gt 0 ]; then
  sketchybar --set "$NAME" background.drawing=off label.color=$COLOR_TEXT popup.drawing=off
else
  sketchybar --set "$NAME" background.drawing=off label.color=$COLOR_EMPTY popup.drawing=off
fi

[ "$SENDER" = "aerospace_workspace_change" ] && [ "$sid" = "$focused" ] || exit 0

sketchybar --set "$NAME" popup.drawing=on --set "$NAME.name" label="$(workspace_name "$sid")"
token=$$
echo "$token" > "$TOKEN_FILE"
sleep "$POPUP_SECONDS"
[ "$(cat "$TOKEN_FILE")" = "$token" ] && sketchybar --set "$NAME" popup.drawing=off
