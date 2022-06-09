# Lines configured by zsh-newuser-install
HISTFILE=$ZDOTDIR/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob nomatch
unsetopt beep notify
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/will/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
#
. $HOME/.config/zsh/antidote/antidote.zsh
source $ZDOTDIR/.zsh_plugins.zsh

eval "$(zoxide init zsh)"

export TERMINAL=/usr/bin/alacritty
export EDITOR=/usr/bin/nvim
export BROWSER=/usr/bin/brave

# ls
alias l='exa -hgl --group-directories-first'
alias ll='exa -hgalF --group-directories-first'
alias ls='exa -aF --group-directories-first'
alias la='exa -aF --group-directories-first'
alias tree='exa --tree'
alias cat='bat -upp'
alias v='nvim'
alias vim='nvim'

function config () {
  z $HOME/.config/ && clear && exa -aD
  printf "which? : " && read choice && clear
  fixedchoice=$HOME/.config/$choice
  z $fixedchoice && exa -halF
  printf "which? : " && read choice2
  nvim $choice2
}

function note () {
    nvim $HOME/Documents/notes/scratch
}


~/scripts/suckless
