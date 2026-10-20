#!/bin/bash
# Usage: position-single.sh <center|left|right>
# Floats the focused window and positions it on the visible screen area.

placement=$1

aerospace layout floating

osascript -l JavaScript - "$placement" <<'JS'
ObjC.import("AppKit");
function run([placement]) {
  const primaryHeight = $.NSScreen.screens.objectAtIndex(0).frame.size.height;
  const visible = $.NSScreen.mainScreen.visibleFrame;
  const top = primaryHeight - (visible.origin.y + visible.size.height);
  const ratio = placement === "center" ? 0.6 : 0.5;
  const width = Math.round(visible.size.width * ratio);
  const offsets = {
    left: 0,
    center: (visible.size.width - width) / 2,
    right: visible.size.width - width,
  };
  const window = Application("System Events").processes.whose({ frontmost: true })[0].windows[0];
  window.position = [Math.round(visible.origin.x + offsets[placement]), Math.round(top)];
  window.size = [width, Math.round(visible.size.height)];
}
JS
