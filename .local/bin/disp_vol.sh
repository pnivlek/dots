#!/usr/bin/env bash

vol="$(pamixer --get-volume)"

if [[ "${vol}" -le 10 ]]; then
    notify-send -u low -a disp_vol " ${vol}%"
else
    notify-send -u low -a disp_vol " ${vol}%"
fi
