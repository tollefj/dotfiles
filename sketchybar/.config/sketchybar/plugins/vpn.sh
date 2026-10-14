#!/bin/bash
source "$CONFIG_DIR/colors.sh"

case "$SENDER" in
  mouse.clicked)
    open "x-apple.systempreferences:com.apple.NetworkExtensionSettingsUI.NESettingsUIExtension"
    exit 0 ;;
esac

SERVICES=$(scutil --nc list | awk -F'"' '/\(Connected\)/ { split($2, w, " "); print w[1] }' | paste -sd, - | sed 's/,/, /g')
TUNNEL=$(ifconfig | awk '/^utun/ { i = 1 } /^[a-z]/ && !/^utun/ { i = 0 } i && /inet / { print "up"; exit }')

if [ -n "$SERVICES" ]; then
  sketchybar --set "$NAME" icon=󰦝 icon.color=$GREEN label="$SERVICES"
elif [ -n "$TUNNEL" ]; then
  sketchybar --set "$NAME" icon=󰦝 icon.color=$GREEN label="VPN"
else
  sketchybar --set "$NAME" icon=󰦞 icon.color=$SUBTEXT label="off"
fi
