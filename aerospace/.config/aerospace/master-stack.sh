#!/bin/bash
# Keeps the left-most window full height and stacks every other tiled window on the right.

sleep 0.05

for workspace in $(aerospace list-workspaces --monitor all --empty no); do
  root_layout=$(aerospace list-windows --workspace "$workspace" --format '%{workspace-root-container-layout}' | head -1)
  [ "$root_layout" = "h_tiles" ] || continue

  root_windows=()
  stack_windows=()
  first_stack_index=-1
  index=0
  while IFS='|' read -r id layout; do
    case $layout in
      h_tiles) root_windows+=("$id:$index") ;;
      v_tiles)
        stack_windows+=("$id")
        [ "$first_stack_index" -lt 0 ] && first_stack_index=$index
        ;;
    esac
    index=$((index + 1))
  done < <(aerospace list-windows --workspace "$workspace" --format '%{window-id}|%{window-parent-container-layout}')

  extras=("${root_windows[@]:1}")
  [ ${#extras[@]} -eq 0 ] && continue

  if [ ${#stack_windows[@]} -eq 0 ]; then
    [ ${#extras[@]} -lt 2 ] && continue
    aerospace join-with --window-id "${extras[1]%%:*}" left
    extras=("${extras[@]:2}")
    first_stack_index=1
  fi

  for entry in "${extras[@]}"; do
    id=${entry%%:*}
    position=${entry##*:}
    if [ "$position" -lt "$first_stack_index" ]; then
      aerospace move --window-id "$id" right
    else
      aerospace move --window-id "$id" left
    fi
  done
done
