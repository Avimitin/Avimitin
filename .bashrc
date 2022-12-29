#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='\w > '

alias ll='ls -al --color=auto'
alias ap='asp checkout'
alias eb="updpkgsums && mkdir -p $HOME/.cache/rvpkg && extra-riscv64-build -- -d $HOME/.cache/rvpkg:/var/cache/pacman/pkg"
alias gd="git diff --no-prefix"
alias cdw="cd ~/rvpkg"
alias torv64="setconf PKGBUILD arch \"('x86_64' 'riscv64')\""
