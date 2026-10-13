#!/bin/bash
if [ "$BUTTON" = right ]; then
  open -a Calendar
else
  "$HOME/.local/bin/menu-items" press "$(pgrep -x ControlCenter)/com.apple.menuextra.clock"
fi
