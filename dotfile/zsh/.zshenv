export LANG=en_US.UTF-8

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# Turn everything to XDG based dir
ZDOTDIR=$XDG_CONFIG_HOME/zsh
ZSH_CACHE_DIR=$XDG_CACHE_HOME/zsh

export GOPATH=$XDG_DATA_HOME/go

export EDITOR='nvim'
export VISUAL="$EDITOR "
export SYSTEMD_EDITOR=$EDITOR
export PAGER='less'
export BROWSER=/usr/bin/xdg-open

export BAT_THEME="OneHalfDark"

# wayland settings
export QT_QPA_PLATFORM="wayland;xcb"
export CLUTTER_BACKEND=wayland
export SDL_VIDEODRIVER=wayland
export MOZ_ENABLE_WAYLAND=1

# Path
path+=(
  $HOME/.local/bin(N-/)
  $HOME/w/avimitin/infra/scripts/archrv(N-/)
)

# History
HISTFILE=$XDG_CACHE_HOME/zsh/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
