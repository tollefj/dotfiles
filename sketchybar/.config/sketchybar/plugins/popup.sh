#!/bin/bash
# Shared popup handling for items: closes popup when the mouse leaves the bar.
[ "$SENDER" = "mouse.exited.global" ] && sketchybar --set "$NAME" popup.drawing=off
