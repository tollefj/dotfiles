#!/bin/bash
# Sketchybar plugin: keeps a popup of menu bar extras prebuilt so clicks only toggle it.
BIN="${MENU_ITEMS_BIN:-$HOME/.local/bin/menu-items}"
IGNORE_FILE="${MENU_ITEMS_IGNORE:-$CONFIG_DIR/menu_items.ignore}"
CACHE="${TMPDIR:-/tmp}/sketchybar_$NAME.tsv"
LOG="${TMPDIR:-/tmp}/sketchybar_$NAME.log"
DEFAULT_IGNORE=(com.apple.menuextra.controlcenter)
HIGHLIGHT="${MENU_ITEMS_HIGHLIGHT:-0xff313244}"
CHAR_WIDTH="${MENU_ITEMS_CHAR_WIDTH:-8}"
SELF="${BASH_SOURCE[0]}"
PARENT="${NAME%%.entry.*}"

close_popup() {
  echo "sketchybar --set $PARENT popup.drawing=off background.drawing=off"
}

toggle_popup() {
  if [ "$(sketchybar --query "$NAME" | jq -r .popup.drawing)" = on ]; then
    eval "$(close_popup)"
  else
    sketchybar --set "$NAME" popup.drawing=on \
      background.drawing=on background.color=$HIGHLIGHT background.corner_radius=6 background.height=24
  fi
}

rebuild() {
  local ignore=() pattern
  for pattern in "${DEFAULT_IGNORE[@]}"; do ignore+=(--ignore "$pattern"); done
  if [ -f "$IGNORE_FILE" ]; then
    while IFS= read -r pattern; do
      [[ -z "$pattern" || "$pattern" == \#* ]] || ignore+=(--ignore "$pattern")
    done < "$IGNORE_FILE"
  fi

  if [ ! -x "$BIN" ]; then
    echo "menu-items not found at $BIN, set MENU_ITEMS_BIN" >> "$LOG"
    return
  fi

  local json rows
  json=$("$BIN" list "${ignore[@]}" 2>>"$LOG") || return
  rows=$(jq -r '.[] | [(if .identifier then (.id | split(":")[0]) + "/" + .identifier else .id end), .bundle_id, (if .title == .app or (.bundle_id | startswith("com.apple.")) then .title else "\(.app): \(.title)" end)] | @tsv' <<< "$json")
  if [ "$rows" = "$(cat "$CACHE" 2>/dev/null)" ] && sketchybar --query "$NAME.entry.0" >/dev/null 2>&1; then
    return
  fi
  printf '%s' "$rows" > "$CACHE"

  local longest=0 target bundle title LC_ALL=en_US.UTF-8
  while IFS=$'\t' read -r target bundle title; do
    (( ${#title} > longest )) && longest=${#title}
  done <<< "$rows"

  local args=(--remove "/$NAME\.entry\..*/") i=0 entry
  while IFS=$'\t' read -r target bundle title; do
    entry="$NAME.entry.$i"
    args+=(--add item "$entry" "popup.$NAME"
           --set "$entry" label="$title" label.width=$((longest * CHAR_WIDTH + 8))
                 icon.background.image="app.$bundle" icon.background.image.scale=0.5
                 icon.background.drawing=on icon.width=20
                 background.color=$HIGHLIGHT background.corner_radius=6
                 background.height=26 background.drawing=off
                 script="$SELF"
                 click_script="$(close_popup); '$BIN' press '$target'"
           --subscribe "$entry" mouse.entered mouse.exited)
    i=$((i + 1))
  done <<< "$rows"
  sketchybar "${args[@]}"
}

case "$SENDER" in
  mouse.entered) sketchybar --set "$NAME" background.drawing=on ;;
  mouse.exited) sketchybar --set "$NAME" background.drawing=off ;;
  mouse.clicked) toggle_popup ;;
  mouse.exited.global) eval "$(close_popup)" ;;
  *) rebuild ;;
esac
