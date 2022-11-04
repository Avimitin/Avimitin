export LANG=en_US.UTF-8

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export EDITOR='nvim'
export VISUAL="$EDITOR "
export SYSTEMD_EDITOR=$EDITOR
export PAGER='less'
export BROWSER=/usr/bin/xdg-open

export BAT_THEME="OneHalfDark"

# wayland settings
export QT_QPA_PLATFORM="wayland"
export CLUTTER_BACKEND=wayland
export SDL_VIDEODRIVER=wayland
export MOZ_ENABLE_WAYLAND=1

# Path
path+=(
  $HOME/.local/bin(N-/)
)

# GPG Agent
IS_IN_SSH=0

is_in_ssh () {
  if [[ -n "$SSH_CLIENT" ]] || [ -n "$SSH_TTY" ]; then
    IS_IN_SSH=1
  fi
}

if command -v gpgconf > /dev/null && [ "x$IS_IN_SSH" != "x1" ]; then
  export GPG_TTY=$(tty)
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  gpgconf --launch gpg-agent
fi

unset -f is_in_ssh
unset IS_IN_SSH

# For Pure prompts
PURE_GIT_PULL=0
PURE_PROMPT_SYMBOL=""
