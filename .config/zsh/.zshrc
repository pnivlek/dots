# fasd first
eval "$(fasd --init auto)"

[[ -f $HOME/.config/aliasesrc ]] && source $HOME/.config/aliasesrc
[[ -f $HOME/.config/zsh/prompt_minimal.zsh ]] && source $HOME/.config/zsh/prompt_minimal.zsh

# History
HISTFILE=~/.local/share/zsh/zsh_history
HISTSIZE=10000
SAVEHIST=1000
setopt INC_APPEND_HISTORY_TIME

# Completion
autoload -Uz compinit && compinit

# Redefine fasd to use fzf
j () {
  local dir
  dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
}

# Used for java stuff
[[ -s "/home/yack/.sdkman/bin/sdkman-init.sh" ]] && source "/home/yack/.sdkman/bin/sdkman-init.sh"
