export PATH="$PATH:/home/yack/.local/bin:/home/yack/pub/bin/:/home/yack/.emacs.d/bin/"
export EDITOR="emacs -nw"
export TERMINAL="xst"
export READER="zathura"

# ~/ Clean-up:
export ZDOTDIR="$HOME/.config/zsh"

# Program settings.
export SDKMAN_DIR="/home/yack/.sdkman"
export GPODDER_HOME="/home/yack/usr/pod"
export GOPATH="/home/yack/doc/code/go"
export DOTNET_ROOT="/opt/dotnet/"


! pgrep -x mpd >/dev/null && mpd >/dev/null 2>&1 &

##-> DreymaR's SetXKB.sh: Activate layout
setxkbmap -model 'pc104curl-z' -layout 'us(cmk_ed_us)' -option 'misc:extend,lv5:caps_switch_lock,grp:shifts_toggle,compose:menu,misc:cmk_curl_dh'
##<- DreymaR's SetXKB.sh

[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x Xorg >/dev/null && exec startx

# Created by `userpath` on 2020-08-18 07:46:50
export PATH="$PATH:/home/yack/.local/bin"
