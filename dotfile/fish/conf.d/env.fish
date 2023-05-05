set --export LANG en_US.UTF-8

set --export XDG_CONFIG_HOME $HOME/.config
set --export XDG_CACHE_HOME $HOME/.cache
set --export XDG_DATA_HOME $HOME/.local/share

set --export EDITOR 'nvim'
set --export VISUAL "$EDITOR "
set --export SYSTEMD_EDITOR $EDITOR
set --export PAGER 'less'

#set -gx BROWSER /usr/bin/xdg-open

# fcitx5 settings
# set -gx GTK_IM_MODULE fcitx
# set -gx QT_IM_MODULE fcitx
# set -gx XMODIFIERS "@im=fcitx"
# set -gx SDL_IM_MODULE fcitx
# set -gx GLFW_IM_MODULE fcitx

# wayland settings
set --export QT_QPA_PLATFORM "wayland"
set --export CLUTTER_BACKEND wayland
set --export SDL_VIDEODRIVER wayland
set --export MOZ_ENABLE_WAYLAND 1

# Path
fish_add_path $HOME/.local/bin
