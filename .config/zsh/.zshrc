[[ -f $HOME/.config/aliasesrc ]] && source $HOME/.config/aliasesrc
[[ -f $HOME/.config/zsh/prompt_minimal.zsh ]] && source $HOME/.config/zsh/prompt_minimal.zsh

# z the directory jumper
[[ -f /usr/share/z/z.sh ]] && . /usr/share/z/z.sh # install Z
# install Z but on a different computer
[[ -f /bedrock/strata/arch/usr/share/z/z.sh ]] && . /bedrock/strata/arch/usr/share/z/z.sh 

# Used for java stuff
[[ -s "/home/yack/.sdkman/bin/sdkman-init.sh" ]] && source "/home/yack/.sdkman/bin/sdkman-init.sh"
