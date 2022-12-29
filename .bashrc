#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='\w > '

alias ll='ls -al --color=auto'
alias aspc='asp checkout'
alias rvbuild="updpkgsums && mkdir -p $HOME/.cache/rvpkg && extra-riscv64-build -- -d $HOME/.cache/rvpkg:/var/cache/pacman/pkg"
alias gd="git diff --no-prefix"
alias torv64="setconf PKGBUILD arch \"('x86_64' 'riscv64')\""

function cdw() {
  if [[ "$1" == "" ]]; then
    cd ~/rvpkg
    return 0
  fi

  cd ~/rvpkg/$1/repos/*/
}
