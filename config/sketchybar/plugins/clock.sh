#!/bin/bash

export PATH="/opt/homebrew/bin:/usr/bin:/bin:$PATH"

sketchybar --set "$NAME" \
    label="$(date '+%a %d %b  %H:%M')"
