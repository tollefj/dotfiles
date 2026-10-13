#!/bin/bash
source "$CONFIG_DIR/colors.sh"

case "$SENDER" in
  mouse.clicked) exec "$CONFIG_DIR/plugins/top_procs.sh" cpu cpu ;;
  mouse.exited.global) exec "$CONFIG_DIR/plugins/popup.sh" ;;
esac

CPU=$(top -l 2 -n 0 -s 1 | grep "CPU usage" | tail -1 | awk '{printf "%d", $3 + $5}')
if [ "$CPU" -ge 80 ]; then COLOR=$RED
elif [ "$CPU" -ge 50 ]; then COLOR=$YELLOW
else COLOR=$ACCENT; fi

sketchybar --set "$NAME" label="${CPU}%" \
  --set cpu.graph graph.color=$COLOR \
  --push cpu.graph "$(awk -v c="$CPU" 'BEGIN { print c / 100 }')"
