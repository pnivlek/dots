# .cargo/bin for rustup on gentoo
export PATH="/home/yack/.cargo/bin:/home/yack/.local/bin:/home/yack/pub/bin/:/home/yack/.emacs.d/bin/:/home/yack/.dotnet/tools:/home/yack/usr/go/bin:/opt/devkitpro/devkitPPC/bin:$PATH"
export EDITOR="nvim"
export TERMINAL="urxvtc"
export READER="zathura"
export MANPATH="$(manpath):/home/yack/.local/share/man"

# ~/ Clean-up:
export ZDOTDIR="$HOME/.config/zsh"

# Program settings.
export SDKMAN_DIR="/home/yack/.sdkman"
export GPODDER_HOME="/home/yack/usr/pod"
export GOPATH="/home/yack/usr/go"

# ! pgrep -x mpd >/dev/null && mpd >/dev/null 2>&1 &
# ! pgrep -x mpdscribble >/dev/null && mpdscribble --conf ~/.config/mpdscribble/mpdscribble.conf >/dev/null 2>&1 &

[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x xmonad > /dev/null && startx
