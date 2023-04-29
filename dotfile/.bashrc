#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='\w > '
PS1="\n$(tput setaf 4)\w$(tput sgr0)\n$(tput setaf 45)$(tput sgr0) "

alias ll='ls -alh --color=auto --group-directories-first'
alias aspc='asp checkout'
alias rvbuild="updpkgsums && mkdir -p $HOME/.cache/rvpkg && extra-riscv64-build -- -d $HOME/.cache/rvpkg:/var/cache/pacman/pkg"
alias gd="git diff --no-prefix"
alias torv64="setconf PKGBUILD arch \"('x86_64' 'riscv64')\""
alias tml="tmux ls"
alias tma="tmux attach-sesstion -t"

if [[ -d "/usr/share/fzf" ]]; then
  source "/usr/share/fzf/completion.bash"
  source "/usr/share/fzf/key-bindings.bash"
fi

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

function get_patch() {
  if [[ "$1" == "" ]]; then
    >&2 echo "No package argument was given, exit"
    return 1
  fi

  local gh_api="https://api.github.com/repos/felixonmars/archriscv-packages/contents"
  local response=$(curl \
    -H 'Accept: application/vnd.github+json' \
    -H 'X-GitHub-Api-Version: 2022-11-28' \
    -sSf "$gh_api/$1")

  local message="$(echo $response | jq -r '.message' &> /dev/null)"

  if [[ "$message" == "Not Found" ]]; then
    >&2 echo "$1 is not exist in repo, please check your input"
    return 1
  fi

  read -d ' ' -a url_list < <(echo $response | jq -r '.[].download_url')
  for url in ${url_list[@]}; do
    echo "Downloading $url"
    curl -sSfLO "$url"
  done
}
