#!/bin/bash

export PATH="/opt/homebrew/bin:/usr/bin:/bin:$PATH"

status=$(pmset -g batt)
percentage=$(printf '%s\n' "$status" | grep -Eo '[0-9]+%' | head -1)

sketchybar --set "$NAME" label="${percentage:---}"
