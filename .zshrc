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

cd_home() { cd "/home/yack" ; }
cd_home

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/yack/.sdkman"
[[ -s "/home/yack/.sdkman/bin/sdkman-init.sh" ]] && source "/home/yack/.sdkman/bin/sdkman-init.sh"

alias dots='git --git-dir=$HOME/.dots.git/ --work-tree=$HOME'
