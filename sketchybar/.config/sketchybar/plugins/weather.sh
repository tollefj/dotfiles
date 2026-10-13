#!/bin/bash
LOCATION="Trondheim"

case "$SENDER" in
  mouse.clicked)
    open "https://wttr.in/$LOCATION"
    exit 0 ;;
esac

DATA=$(curl -sf -m 10 "wttr.in/$LOCATION?format=%c|%t")
[ -z "$DATA" ] && exit 0

sketchybar --set "$NAME" icon="${DATA%%|*}" label="${DATA##*|}"
