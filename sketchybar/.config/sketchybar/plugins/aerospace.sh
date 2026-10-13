#!/bin/bash
if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" background.drawing=on label.color=0xff1e1e2e
else
  sketchybar --set "$NAME" background.drawing=off label.color=0xffcdd6f4
fi
