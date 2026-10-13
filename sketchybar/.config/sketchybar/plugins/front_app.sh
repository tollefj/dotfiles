#!/bin/bash
[ "$SENDER" = "front_app_switched" ] && sketchybar --set "$NAME" label="$INFO"
