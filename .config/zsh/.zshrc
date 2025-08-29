# fasd first
eval "$(fasd --init auto)"

[[ -f $HOME/.config/aliasesrc ]] && source $HOME/.config/aliasesrc
[[ -f $HOME/.config/zsh/prompt_minimal.zsh ]] && source $HOME/.config/zsh/prompt_minimal.zsh
[[ -f /usr/share/doc/git-extras/git-extras-completion.zsh ]] && source /usr/share/doc/git-extras/git-extras-completion.zsh

# History
HISTFILE=~/.local/share/zsh/zsh_history
HISTSIZE=10000
SAVEHIST=1000
HISTCONTROL=ignorespace
setopt INC_APPEND_HISTORY_TIME

# Completion
autoload -Uz compinit && compinit

# Use fzf
source <(fzf --zsh)

# Redefine fasd to use fzf
j () {
  local dir
  dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
}

# Keychain
eval $(keychain --eval --quiet id_ed25519 --noask)
