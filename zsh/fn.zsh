function colorize() {
  # prefer terminal safe colored and bold text when tput is supported
  if tput setaf 0 &>/dev/null; then
  	ALL_OFF="$(tput sgr0)"
  	BOLD="$(tput bold)"
  	BLUE="${BOLD}$(tput setaf 4)"
  	GREEN="${BOLD}$(tput setaf 2)"
  	RED="${BOLD}$(tput setaf 1)"
  	YELLOW="${BOLD}$(tput setaf 3)"
  else
  	ALL_OFF="\e[0m"
  	BOLD="\e[1m"
  	BLUE="${BOLD}\e[34m"
  	GREEN="${BOLD}\e[32m"
  	RED="${BOLD}\e[31m"
  	YELLOW="${BOLD}\e[33m"
  fi
  readonly ALL_OFF BOLD BLUE GREEN RED YELLOW
}

function checkdeps() {
  local depends=($@)
  for dep in ${depends[@]}; do
    if ! command -v $dep &> /dev/null; then
      echo "$dep is missing" >&2
      return 1
    fi
  done
}

function _set_proxy_help {
  cat << EOF
Available options:
    help                       get help information
    clash_host                 set server ip to host ip and port to 7890, suitable for wsl and VM user
    clash_local                set server ip to local and port to 7890
    host {{PORT (integer)}}    set server ip to host ip and a custom port. Eg.set_proxy host 11451
    local {{PORT (integer)}}   set server ip to local ip and a custom port. Eg.set_proxy local 11451
    {{CUSTOM_IP}} {{PORT}}     custom ip and port, no http prefix needed
    reset                      reset proxy
EOF
}

function _set_proxy {
  export http_proxy="http://$1:$2"
  echo "> http_proxy is set to: $http_proxy"

  export https_proxy=$http_proxy
  echo "> https_proxy is set to: $https_proxy"

  export all_proxy=$http_proxy
  echo "> all_proxy is set to: $all_proxy"
}

function set_proxy {
  case $1 in
    "")
      _set_proxy_help
      ;;
    "help")
      _set_proxy_help
      ;;
    "clash_host")
      _host_ip=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}')
      _set_proxy $_host_ip 7890
      ;;
    "clash_local")
      _set_proxy '127.0.0.1' 7890
      ;;
    "host")
      _host_ip=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}')
      if [[ -z "$2" ]]; then
        echo "No port is given"
        return 1
      fi
      _set_proxy $_host_ip $2
      ;;
    "local")
      if [[ -z "$2" ]]; then
        echo "No port is given"
        return 1
      fi
      _set_proxy "127.0.0.1" $2
      ;;
    "reset")
      unset http_proxy
      unset https_proxy
      unset all_proxy
      echo "unset done"
      ;;
    *)
      _set_proxy_help
      ;;
  esac
}

# imgscale will resize the photo to bilibili expect size
function imgscale {
  if [ ! $+commands[convert] ]; then
    echo "scaling images need imagemagick"
    return 1
  fi

  convert $1 -resize 1250x960 scale_output.jpg
}

# for broot
function br {
    local cmd cmd_file code
    cmd_file=$(mktemp)
    if broot --outcmd "$cmd_file" "$@"; then
        cmd=$(<"$cmd_file")
        rm -f "$cmd_file"
        eval "$cmd"
    else
        code=$?
        rm -f "$cmd_file"
        return "$code"
    fi
}

function load_nvm() {
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}

function ytd() {
  if ! checkdeps "yt-dlp" "find" "convert"; then
    return 1
  fi

  if [[ -n "$@" ]]; then
    yt-dlp "$@"
    return $?
  fi


  local content
  if [[ -n "$WAYLAND_DISPLAY" ]]; then
    content="$(wl-paste)"
  else
    content="$(xsel -b)"
  fi

  if [[ -z "$content" ]]; then
    echo "No URL in your clipboard" >&2
    return 1
  fi

  colorize

  printf "Current selection: ${BLUE}${content}${ALL_OFF}\n"
  if ! read -q "confirm?Are you sure to download this URL? ${GREEN}[y/Y]${ALL_OFF}"; then
    echo
    echo "Quit..."
    return 0
  fi

  echo
  local download_dir="$HOME/Downloads/YouTube_Video"
  mkdir -p $download_dir && cd $download_dir
  yt-dlp "$content" --write-thumbnail
  convert "$(find . -regex '.*\.webp')" -resize 1250x960 thumbnail-resize.png
  echo "Video downloaded, switch to $download_dir"
  return 0
}

function fetch_remote_patch() {
  if ! checkdeps "rsync"; then
    return 1
  fi

  local usage=$(cat << EOF
  Usage:
    fetch_remote_patch "remote_server" "package_name"
EOF
  )

  local remote="$1"; shift
  [[ -z "$remote" ]] && echo "$usage" >&2 && return 1

  local pkgname="$1"; shift
  [[ -z "$pkgname" ]] && echo "$usage" >&2 && return 1

  rsync -azvhP "${remote}:~/rvpkg/${pkgname}/repos/*/riscv64.patch" .
}

function prepare_patch_dir() {
  colorize

  local pkgname="$1"; shift
  [[ -z "$pkgname" ]] && echo "No PKGNAME" >&2 && return 1

  local current_branch="$(git rev-parse --abbrev-ref)"
  [[ "$current_branch" != "master" ]] && git switch master

  git pull upstream master

  local should_create_branch=1
  if git rev-parse --verify "$pkgname" &> /dev/null; then
    read -q "c?Branch $pkgname exist, can I delete it? ${GREEN}[Y/n]${ALL_OFF}"
    echo
    if (( $? == 1 )) ; then
      git switch "$pkgname"
      should_create_branch=0
    fi
    git branch -d "$pkgname"
    git push -d origin "$pkgname"
  fi

  if (( $should_create_branch )); then
    git switch -c "$pkgname"
  fi

  if [[ ! -d "$pkgname"  ]]; then
    mkdir "$pkgname"
  fi

  cd "$pkgname"
}
