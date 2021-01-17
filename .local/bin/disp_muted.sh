#!/usr/bin/env bash

muted="true"

if [ "$(pamixer --get-mute)" == "$muted" ]; then
    notify-send -u low -a disp_vol_mute " Muted"
else
    exec ~/.local/bin/disp_vol.sh
fi
