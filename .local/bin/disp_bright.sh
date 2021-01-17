#!/usr/bin/env bash

notify-send -u low -a disp_vol "  $(light | rev | cut -c 4- | rev)%"
