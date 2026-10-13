#!/bin/bash
# Sketchybar plugin: keeps a popup of menu bar extras prebuilt so clicks only toggle it.
BIN="${MENU_ITEMS_BIN:-$HOME/.local/bin/menu-items}"
IGNORE_FILE="${MENU_ITEMS_IGNORE:-$CONFIG_DIR/menu_items.ignore}"
CACHE="${TMPDIR:-/tmp}/sketchybar_$NAME.tsv"
LOG="${TMPDIR:-/tmp}/sketchybar_$NAME.log"

rebuild() {
  local ignore=() pattern
  if [ -f "$IGNORE_FILE" ]; then
    while IFS= read -r pattern; do
      [[ -z "$pattern" || "$pattern" == \#* ]] || ignore+=(--ignore "$pattern")
    done < "$IGNORE_FILE"
  fi

  local json rows
  json=$("$BIN" list "${ignore[@]}" 2>>"$LOG") || return
  rows=$(jq -r '.[] | [(if .identifier then (.id | split(":")[0]) + "/" + .identifier else .id end), .bundle_id, .title] | @tsv' <<< "$json")
  if [ "$rows" = "$(cat "$CACHE" 2>/dev/null)" ] && sketchybar --query "$NAME.entry.0" >/dev/null 2>&1; then
    return
  fi
  printf '%s' "$rows" > "$CACHE"

  local args=(--remove "/$NAME\.entry\..*/") i=0 target bundle title
  while IFS=$'\t' read -r target bundle title; do
    args+=(--add item "$NAME.entry.$i" "popup.$NAME"
           --set "$NAME.entry.$i" label="$title"
                 icon.background.image="app.$bundle" icon.background.image.scale=0.5
                 icon.background.drawing=on icon.width=20
                 click_script="sketchybar --set $NAME popup.drawing=off; '$BIN' press '$target'")
    i=$((i + 1))
  done <<< "$rows"
  sketchybar "${args[@]}"
}

case "$SENDER" in
  mouse.clicked) sketchybar --set "$NAME" popup.drawing=toggle ;;
  mouse.exited.global) sketchybar --set "$NAME" popup.drawing=off ;;
  *) rebuild ;;
esac
