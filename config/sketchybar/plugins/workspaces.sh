#!/bin/bash

export PATH="/opt/homebrew/bin:/usr/bin:/bin:$PATH"

focused=$(aerospace list-workspaces --focused 2>/dev/null) || exit 0
occupied=" $(aerospace list-workspaces --monitor all --empty no | tr '\n' ' ') "

args=()

for ws in $(aerospace list-workspaces --all); do

    if [ "$ws" = "$focused" ]; then
        drawing=on
        colour=0xff7aa2f7
        foreground=0xff1a1b26

    elif [[ "$occupied" == *" $ws "* ]]; then
        drawing=on
        colour=0xff24283b
        foreground=0xff9aa5ce

    else
        drawing=off
        colour=0xff24283b
        foreground=0xff9aa5ce
    fi

    args+=(
        --set "space.$ws"
        "drawing=$drawing"
        "background.color=$colour"
        "icon.color=$foreground"
    )
done

sketchybar "${args[@]}"
