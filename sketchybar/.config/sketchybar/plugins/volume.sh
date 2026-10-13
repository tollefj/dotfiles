#!/bin/bash
if [ "$SENDER" = "volume_change" ]; then
  V=$INFO
  if [ "$V" -eq 0 ]; then ICON=󰝟
  elif [ "$V" -lt 50 ]; then ICON=󰖀
  else ICON=󰕾; fi
  sketchybar --set "$NAME" icon="$ICON" label="${V}%"
fi
