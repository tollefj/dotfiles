#!/bin/bash
# Usage: waterfox-profile-pid.sh <profile-dir-name>
# Prints the main Waterfox PID for the profile, derived from its child processes.

profile_dir="$HOME/Library/Application Support/Waterfox/Profiles/$1"

ps -axo command \
  | grep -F -- "-profile $profile_dir org.mozilla" \
  | sed -n 's/.* -parentPid \([0-9]*\) .*/\1/p' \
  | head -1
