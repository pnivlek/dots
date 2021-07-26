#!/bin/bash

# Get screenshot and upload to vgy.me
VGY_URL=$(~/.local/bin/vgy.sh | head -n 1 | cut -c 6-)

TITLE=$(rofi -dmenu)

echo ".link $VGY_URL - $TITLE" >> $(find $1 -type f | rofi -dmenu)
