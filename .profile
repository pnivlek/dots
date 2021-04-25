export PATH="$PATH:/home/yack/.local/bin:/home/yack/pub/bin/:/home/yack/.emacs.d/bin/:/home/yack/.dotnet/tools"
export EDITOR="emacs -nw"
export TERMINAL="urxvtc"
export READER="zathura"

# ~/ Clean-up:
export ZDOTDIR="$HOME/.config/zsh"

# Program settings.
export SDKMAN_DIR="/home/yack/.sdkman"
export GPODDER_HOME="/home/yack/usr/pod"
export GOPATH="/hdd/code/go"
export DOTNET_ROOT="/opt/dotnet/"


! pgrep -x mpd >/dev/null && mpd >/dev/null 2>&1 &
! pgrep -x mpdscribble >/dev/null && mpdscribble --conf ~/.config/mpdscribble/mpdscribble.conf >/dev/null 2>&1 &

[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x bspwm > /dev/null && startx
