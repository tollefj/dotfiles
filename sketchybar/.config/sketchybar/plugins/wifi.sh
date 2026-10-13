#!/bin/bash
source "$CONFIG_DIR/colors.sh"

case "$SENDER" in
  mouse.clicked)
    if [ "$BUTTON" = right ]; then
      open "x-apple.systempreferences:com.apple.wifi-settings-extension"
    else
      sketchybar --set wifi.ip label="$(ipconfig getifaddr en0 || echo -)" \
                 --set wifi.router label="$(ipconfig getoption en0 router || echo -)" \
                 --set "$NAME" popup.drawing=toggle
    fi
    exit 0 ;;
  mouse.exited.global) exec "$CONFIG_DIR/plugins/popup.sh" ;;
esac

SSID=$(ipconfig getsummary en0 | awk -F ' SSID : ' '/ SSID : / { print $2 }')
if [ -n "$SSID" ]; then
  sketchybar --set "$NAME" icon=󰖩 icon.color=$TEXT label="$SSID"
else
  sketchybar --set "$NAME" icon=󰖪 icon.color=$RED label="off"
fi
