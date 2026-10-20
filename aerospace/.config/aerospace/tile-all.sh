#!/bin/bash
# Tiles every window on the focused workspace and rebuilds the master-stack layout.

for id in $(aerospace list-windows --workspace focused --format '%{window-id}'); do
  aerospace fullscreen off --window-id "$id" 2>/dev/null
  aerospace layout tiling --window-id "$id"
done

aerospace flatten-workspace-tree
aerospace layout h_tiles
~/.config/aerospace/master-stack.sh
