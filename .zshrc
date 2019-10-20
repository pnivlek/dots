# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/yack/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Define zim location
export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Start zim
[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh

autoload -Uz promptinit
promptinit
prompt eriner

export EDITOR="nvim"
export PATH=$PATH:/home/yack/bin

alias ana="source /home/yack/doc/ana/bin/activate"
alias dana="conda deactivate"

# Music downloading
mp3 () {
	youtube-dl --ignore-errors -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o '~/usr/mus/yt/%(title)s.%(ext)s' "$1"
}
mp3p () {
	youtube-dl --ignore-errors -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o '~/usr/mus/yt/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' "$1"
}

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/yack/.sdkman"
[[ -s "/home/yack/.sdkman/bin/sdkman-init.sh" ]] && source "/home/yack/.sdkman/bin/sdkman-init.sh"

alias dots='git --git-dir=$HOME/.dots.git/ --work-tree=$HOME'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
