#!/usr/bin/env bash
volume=$(wpctl get-volume @DEFAULT_SINK@ | awk '{print int($2 * 100)}')
muted=$(wpctl get-volume @DEFAULT_SINK@ | grep -o MUTED)

if [ "$muted" == "MUTED" ]; then
    echo "󰝟"
else
    if [ "$volume" -ge 50 ]; then
        echo "󰕾 $volume%"
    elif [ "$volume" -ge 1 ]; then
        echo "󰖀 $volume%"
    else
        echo "󰕿 $volume%"
    fi
fi
