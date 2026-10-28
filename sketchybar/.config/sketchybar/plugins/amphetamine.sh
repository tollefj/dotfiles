#!/bin/bash
source "$CONFIG_DIR/colors.sh"

amph() { osascript -e "tell application \"Amphetamine\" to $1" 2>/dev/null; }

if ! pgrep -xq Amphetamine; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

if [ "$SENDER" = mouse.clicked ]; then
  if [ "$BUTTON" = right ]; then
    osascript -e 'tell application "System Events" to tell process "Amphetamine" to click menu bar item 1 of menu bar 2'
    exit 0
  elif [ "$(amph 'session is active')" = true ]; then
    amph 'end session'
  else
    amph 'start new session with options {duration:0, interval:0, displaySleepAllowed:false}'
  fi
fi

if [ "$(amph 'session is active')" = true ]; then
  REMAINING=$(amph 'session time remaining')
  if [ "${REMAINING:-0}" -gt 0 ]; then
    LABEL=$(printf '%d:%02d' $((REMAINING / 3600)) $((REMAINING % 3600 / 60)))
    sketchybar --set "$NAME" drawing=on icon=󰅶 icon.color=$YELLOW label="$LABEL" label.drawing=on
  else
    sketchybar --set "$NAME" drawing=on icon=󰅶 icon.color=$YELLOW label.drawing=off
  fi
else
  sketchybar --set "$NAME" drawing=on icon=󰛊 icon.color=$SUBTEXT label.drawing=off
fi
