export XKB_DEFAULT_OPTIONS="caps:ctrl_modifier"
export PATH="$PATH:/home/yack/.local/bin/:/home/yack/pub/bin/:/home/yack/.emacs.d/bin/:/home/yack/.dotnet/tools:/home/yack/code/go/bin:/opt/devkitpro/devkitPPC/bin/:/home/yack/.cargo/bin/"
export EDITOR="nvim"
export TERMINAL="urxvtc"
export READER="zathura"
export MANPATH="$(manpath):/home/yack/.local/share/man"

# GPG, you're drunk
export GPG_TTY=$(tty)

# ~/ Clean-up:
export ZDOTDIR="$HOME/.config/zsh"

# Program settings.
export SDKMAN_DIR="/home/yack/.sdkman"
export GPODDER_HOME="/home/yack/usr/pod"
export GOPATH="/home/yack/code/go"

! pgrep -x mpd >/dev/null && mpd >/dev/null 2>&1 &
! pgrep -x mpdscribble >/dev/null && mpdscribble --conf ~/.config/mpdscribble/mpdscribble.conf >/dev/null 2>&1 &

! pgrep -x ssh-agent >/dev/null && eval "$(ssh-agent -s)" >/dev/null 2>&1 &

[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x river > /dev/null && river
