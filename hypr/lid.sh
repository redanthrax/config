#!/usr/bin/env bash
if [[ $1 == "open" ]]; then
    hyprctl keyword monitor "eDP-1,2560x1440,0x0,1"
else
    hyprctl keyword monitor "eDP-1,disable"
fi
