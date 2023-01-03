#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='\w > '

alias ll='ls -alh --color=auto --group-directories-first'
alias aspc='asp checkout'
alias rvbuild="updpkgsums && mkdir -p $HOME/.cache/rvpkg && extra-riscv64-build -- -d $HOME/.cache/rvpkg:/var/cache/pacman/pkg"
alias gd="git diff --no-prefix"
alias torv64="setconf PKGBUILD arch \"('x86_64' 'riscv64')\""
alias tml="tmux ls"
alias tma="tmux attach-sesstion -t"

function cdw() {
  if [[ "$1" == "" ]]; then
    cd ~/rvpkg
    return 0
  fi

  cd ~/rvpkg/$1/repos/*/
}

function cds() {
  local prefix='/var/lib/archbuild/extra-riscv64/avimitin/build'
  if [[ "$1" == "" ]]; then
    cd $prefix
    return 0
  fi

  cd "${prefix}/${1}"
}
