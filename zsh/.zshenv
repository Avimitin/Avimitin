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

path+=(
  $HOME/.cargo/bin(N-/)
  $HOME/go/bin(N-/)
  $HOME/.local/bin(N-/)
)
