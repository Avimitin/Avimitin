#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias v='bat'
alias vi="nvim"
alias ll='lsd --long'
alias lg='lazygit'

eval "$(zoxide init bash)"
eval "$(starship init bash)"
