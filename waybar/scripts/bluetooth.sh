#!/usr/bin/env bash

# Check if bluetooth is powered on
powered=$(bluetoothctl show | grep "Powered: yes")

if [ -z "$powered" ]; then
    echo ""
    exit 0
fi

# Count connected devices
connected=$(bluetoothctl devices Connected | wc -l)

if [ "$connected" -gt 0 ]; then
    echo " $connected"
else
    echo ""
fi
