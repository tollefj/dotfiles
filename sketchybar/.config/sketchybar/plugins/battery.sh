#!/bin/bash
case "$SENDER" in
  mouse.clicked)
    BATT=$(pmset -g batt)
    IO=$(ioreg -rn AppleSmartBattery)
    CYCLES=$(echo "$IO" | awk '/"CycleCount" =/ { print $3 }')
    HEALTH=$(echo "$IO" | awk '/"AppleRawMaxCapacity" =/ { m = $3 } /"DesignCapacity" =/ { d = $3 }
                               END { if (d) printf "%d%%", m / d * 100 }')
    REMAINING=$(echo "$BATT" | grep -Eo '[0-9]+:[0-9]+ remaining' || echo "calculating")
    SOURCE=$(echo "$BATT" | grep -Eo "'.*'" | tr -d "'")
    sketchybar --set battery.source label="$SOURCE" \
               --set battery.time label="$REMAINING" \
               --set battery.health label="$HEALTH, $CYCLES cycles" \
               --set "$NAME" popup.drawing=toggle
    exit 0 ;;
  mouse.exited.global) exec "$CONFIG_DIR/plugins/popup.sh" ;;
esac

BATT=$(pmset -g batt)
PCT=$(echo "$BATT" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
[ -z "$PCT" ] && { sketchybar --set "$NAME" drawing=off; exit 0; }
if echo "$BATT" | grep -q 'AC Power'; then ICON=󰂄
elif [ "$PCT" -gt 80 ]; then ICON=󰁹
elif [ "$PCT" -gt 50 ]; then ICON=󰂀
elif [ "$PCT" -gt 20 ]; then ICON=󰁽
else ICON=󰁺; fi
sketchybar --set "$NAME" icon="$ICON" label="${PCT}%"
