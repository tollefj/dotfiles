#!/bin/bash
set_icon() {
  local v=$1
  if [ "$(osascript -e 'output muted of (get volume settings)')" = true ] || [ "$v" -eq 0 ]; then ICON=󰝟
  elif [ "$v" -lt 50 ]; then ICON=󰖀
  else ICON=󰕾; fi
  sketchybar --set "$NAME" icon="$ICON" label="${v}%"
}

case "$SENDER" in
  volume_change) set_icon "$INFO" ;;
  mouse.scrolled)
    [ "$SCROLL_DELTA" -gt 0 ] && STEP=5 || STEP=-5
    osascript -e "set volume output volume ((output volume of (get volume settings)) + $STEP)" ;;
  mouse.clicked)
    if [ "$BUTTON" = right ]; then
      open "x-apple.systempreferences:com.apple.Sound-Settings.extension"
    else
      osascript -e 'set volume output muted (not output muted of (get volume settings))'
      set_icon "$(osascript -e 'output volume of (get volume settings)')"
    fi ;;
esac
