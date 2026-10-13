#!/bin/bash
source "$CONFIG_DIR/colors.sh"

case "$SENDER" in
  mouse.clicked) exec "$CONFIG_DIR/plugins/top_procs.sh" ram mem ;;
  mouse.exited.global) exec "$CONFIG_DIR/plugins/popup.sh" ;;
esac

PAGE=$(sysctl -n hw.pagesize)
USED=$(vm_stat | awk -v p="$PAGE" '
  /^Anonymous pages/            { anon = $3 }
  /^Pages purgeable/            { purg = $3 }
  /^Pages wired down/           { wired = $4 }
  /^Pages occupied by compressor/ { comp = $5 }
  END { printf "%.1f", (anon - purg + wired + comp) * p / 1073741824 }')

case "$(sysctl -n kern.memorystatus_vm_pressure_level)" in
  4) COLOR=$RED ;;
  2) COLOR=$YELLOW ;;
  *) COLOR=$TEXT ;;
esac

sketchybar --set "$NAME" label="${USED}G" icon.color=$COLOR
