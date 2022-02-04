function _set_proxy_help {
  echo "Available options:"
  echo "help                       get help information "
  echo "host_clash                 set server ip to host ip and port to 7890, suitable for wsl and VM user"
  echo "local_clash                set server ip to local and port to 7890"
  echo "host {{PORT (integer)}}    set server ip to host ip and a custom port. Eg.set_proxy host 11451"
  echo "local {{PORT (integer)}}   set server ip to local ip and a custom port. Eg.set_proxy local 11451"
  echo "{{CUSTOM_IP}} {{PORT}}     custom ip and port, no http prefix needed"
  echo "reset                      reset proxy"
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
