#!/usr/bin/env bash

# Get list of bluetooth devices
devices=$(bluetoothctl devices | awk '{print $3}')

if [ -z "$devices" ]; then
    notify-send "Bluetooth" "No devices found"
    exit 0
fi

# Show in rofi
selected=$(echo "$devices" | rofi -dmenu -p "Bluetooth" -theme ~/.config/rofi/launcher.rasi)

if [ -n "$selected" ]; then
    # Get device MAC
    mac=$(bluetoothctl devices | grep "$selected" | awk '{print $2}')
    
    # Toggle connection
    bluetoothctl connect "$mac"
fi
