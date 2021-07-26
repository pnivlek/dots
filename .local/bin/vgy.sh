#!/bin/bash

# VGY.ME user key
USER_KEY_PATH="$HOME/.private/vgyme_userkey"

# Default file name
FILE_NAME="vgy_$RANDOM.png"

# Default temporary path of the screenshot file
LOCAL_DIR="/tmp"

# Default capture area
AREA="region"

help() {
	echo "Usage: `basename $0` [OPTION]..."
	echo ""
	echo "Valid options:"
	echo "  -c, --cursor                 show cursor in screenshots, hidden by default"
	echo "  -h, --help                   print this help"
	echo "  -k, --keep                   keep screenshots locally"
    echo "  -o, --open                   open the resulting url with xdg-open, print url to stdout by default"
	echo "  --area=[region,active]       desired area of the screenshot, 'region' by default"
	echo "  --dir=DIR                    directory where the screenshots will be stored locally"
	echo "  --opt=OPTIONS                additional options to pass to maim"
}

while [ $# -gt 0 ]; do
	key="$1"
	case $key in
		-h|--help)
		help
		exit 1
		;;
		--dir=*) # Local directory where the screenshots will be saved
		KEEP_FILES=true
		LOCAL_DIR="${1#*=}"
		;;
		--opt=*) # Additional options to pass to maim
		MAIM_OPT="${1#*=}"
		;;
		-k|--keep) # Don't delete local file after uploading
		KEEP_FILES=true
		;;
		-c|--cursor) # Show cursor in the screenshoft, off by default
		SHOW_CURSOR=true
		;;
		--area) # Desired area of the screenshot, can be 'region' or 'active'
		AREA="$2"
		shift
		;;
        -o|--open)
        OPEN=true
        ;;
		*)
		echo "Unknown option '${key}' entered"
		exit 1
	esac
	shift
done

case $AREA in
	"region")
	AREA_OPT="-s"
	;;
	"active")
	AREA_OPT="-i $(xdotool getactivewindow)"
	;;
esac

if [[ $SHOW_CURSOR -ne "true" ]]; then
	MAIM_OPT="${MAIM_OPT} --hidecursor"
fi

FILE_PATH="${LOCAL_DIR}/${FILE_NAME}"

maim -b 1 ${AREA_OPT} ${MAIM_OPT} ${FILE_PATH}

if [ -e $FILE_PATH ]; then
	RET=`curl -s -F "userkey=<$USER_KEY_PATH" -F "file=@$FILE_PATH" https://vgy.me/upload`
	URL="$(echo $RET | grep -Po '(?<="image":")[^"]*' | sed 's/\\//g')"
	DELETE_URL="$(echo $RET | grep -Po '(?<="delete":")[^"]*' | sed 's/\\//g')"
    if [ ! -z $URL ]; then
        if [[ $OPEN -eq "true" ]]; then
		    xdg-open $URL
        else
            echo "URL: ${URL}"
        fi
		echo "Delete url: ${DELETE_URL}"
	else
		notify-send "Screenshot failed"
	fi
else
	notify-send "Screenshot failed"
fi

if [[ $KEEP_FILES -eq "true" ]]; then
	rm -rf ${FILE_PATH}
fi
