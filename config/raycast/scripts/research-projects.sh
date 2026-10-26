#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Research Projects
# @raycast.mode silent
# @raycast.packageName Midnight Research
# @raycast.description Open the tmux project picker in Ghostty

set -euo pipefail

export PATH="/opt/homebrew/bin:/usr/bin:/bin:$PATH"

# Find the most recently active attached tmux client.
client=$(
    tmux list-clients \
        -F '#{client_tty} #{client_activity}' \
        2>/dev/null |
    sort -k2,2nr |
    head -n 1 |
    awk '{print $1}'
) || true

if [ -z "$client" ]; then
    echo "No attached tmux client. Open Ghostty and attach tmux first."
    exit 1
fi

# Bring Ghostty to the foreground.
osascript -e 'tell application "Ghostty" to activate'

# Open the existing Project Picker.
tmux display-popup \
    -c "$client" \
    -E \
    -w 85% \
    -h 70% \
    -T " Research Projects " \
    "$HOME/.local/bin/research-projects"
