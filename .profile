export PATH="$PATH:/home/yack/bin"
export EDITOR="nvim"
export TERMINAL="xst"
export READER="zathura"

# ~/ Clean-up:
export ZDOTDIR="$HOME/.config/zsh"

# Program settings.

# Fzf colorscheme
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=bg+:#1e2132,bg:#161821,spinner:#84a0c6,hl:#6b7089,fg:#c6c8d1,header:#6b7089,info:#b4be82,pointer:#84a0c6,marker:#84a0c6,fg+:#c6c8d1,prompt:#84a0c6,hl+:#84a0c6"
# Qutebrowser with wal dynamic loading - https://gitlab.com/jjzmajic/qutewal
export QUTEWAL_DYNAMIC_LOADING=True
# used for javafx 8 and java
export SDKMAN_DIR="/home/yack/.sdkman"

mpd >/dev/null 2>&1 &

[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x Xorg >/dev/null && exec startx
