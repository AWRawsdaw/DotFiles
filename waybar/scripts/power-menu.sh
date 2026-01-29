#!/usr/bin/env bash

# Power menu script with custom theme

option=$(echo -e "⏻ Shutdown\n Reboot\n⏾ Logout" | rofi -dmenu -i -p "Power Menu" -theme ~/.config/rofi/power-menu.rasi)

case $option in
    "⏻ Shutdown")
        systemctl poweroff
        ;;
    " Reboot")
        systemctl reboot
        ;;
    "⏾ Logout")
        hyprctl dispatch exit
        ;;
esac
