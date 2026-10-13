#!/bin/bash
BATT=$(pmset -g batt)
PCT=$(echo "$BATT" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
[ -z "$PCT" ] && { sketchybar --set "$NAME" drawing=off; exit 0; }
if echo "$BATT" | grep -q 'AC Power'; then ICON=󰂄
elif [ "$PCT" -gt 80 ]; then ICON=󰁹
elif [ "$PCT" -gt 50 ]; then ICON=󰂀
elif [ "$PCT" -gt 20 ]; then ICON=󰁽
else ICON=󰁺; fi
sketchybar --set "$NAME" icon="$ICON" label="${PCT}%"
