# AeroSpace config

Stow-style package: `.aerospace.toml` and `.config/aerospace/*.sh` are symlinked into `~`. Edit files here, not the symlinks.

Reload after changes: `aerospace reload-config`

## Keybindings

All bindings are in `[mode.main.binding]`. Holding Tab sends `alt-cmd-shift` (Karabiner). Tab + Caps Lock adds `ctrl`.

- Apps: t iTerm, y/g Waterfox profiles, p Safari, o Obsidian, c Claude, s Slack, e Finder, m Mail, i Teams, x Signal, u Outlook
- Focus: h/j/k/l, w back-and-forth. Move (with ctrl): h/j/k/l
- Windows: d close, f fullscreen, r rotate tiles, b balance, `,` grow +150, `.` shrink -150
- 1-6 switch workspace, ctrl+1-6 move window to workspace
- 8/0/9 float window left/center/right, a tile all, q pull previous window here, 7 fix workspaces, n next monitor

## Workspaces

Persistent workspaces 1-6. Assignment is done in `[[on-window-detected]]`:

1. iTerm, Claude desktop
2. Everything else, Waterfox default profile
3. Teams, Signal, Slack
4. Outlook, Mail
5. Obsidian, Preview
6. Word, PowerPoint, Excel, Waterfox profile 2

Finder and System Settings float.

## Scripts

- `master-stack.sh`: runs on every new window. Left-most window full height, the rest stacked on the right.
- `focus-or-new.sh`: focus app, or open a new window if it is already focused. Keeps the new window on the current workspace.
- `waterfox-workspace.sh`, `waterfox-profile-pid.sh`: route Waterfox windows to a workspace per profile.
- `position-single.sh`: float and place the focused window.
- `tile-all.sh`, `fix-workspaces.sh`, `pull-previous.sh`: bound to keys above.

## Keep in sync

- `fix-workspaces.sh` duplicates the app-to-workspace rules from `[[on-window-detected]]`.
- `waterfox-workspace.sh` holds the profile-to-workspace map.
- Top gap of 40 on external monitors is room for SketchyBar. `exec-on-workspace-change` triggers a SketchyBar event.
