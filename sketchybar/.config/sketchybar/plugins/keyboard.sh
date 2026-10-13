#!/bin/bash
LAYOUT=$(defaults read com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID | sed 's/.*\.//')
sketchybar --set "$NAME" label="${LAYOUT:0:3}"
