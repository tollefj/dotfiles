#!/bin/bash
# usage: top_procs.sh <parent_item> <cpu|mem>
PARENT=$1
MODE=$2
source "$CONFIG_DIR/colors.sh"

[ "$MODE" = mem ] && SORT=-m || SORT=-r

args=(--remove "/$PARENT\.proc\..*/")
i=0
while read -r pcpu rss comm; do
  if [ "$MODE" = mem ]; then
    value=$(awk -v k="$rss" 'BEGIN { printf "%.1fG", k / 1048576 }')
  else
    value="${pcpu}%"
  fi
  args+=(--add item "$PARENT.proc.$i" "popup.$PARENT"
         --set "$PARENT.proc.$i" icon="$comm" icon.width=180 label="$value"
               label.color=$SUBTEXT click_script="open -a 'Activity Monitor'")
  i=$((i + 1))
done < <(ps -Aceo pcpu=,rss=,comm= $SORT | head -8)

sketchybar "${args[@]}" --set "$PARENT" popup.drawing=toggle
