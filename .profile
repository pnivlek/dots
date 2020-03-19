export PATH="$PATH:/home/yack/.local/bin:/home/yack/pub/bin/"
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
export PATH="$PATH:/opt/dotnet/"


mpd >/dev/null 2>&1 &

[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x Xorg >/dev/null && exec startx
