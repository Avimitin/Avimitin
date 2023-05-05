alias set_env "set --global --export"

set_env LANG en_US.UTF-8

set_env XDG_CONFIG_HOME $HOME/.config
set_env XDG_CACHE_HOME $HOME/.cache
set_env XDG_DATA_HOME $HOME/.local/share

set_env EDITOR 'nvim'
set_env VISUAL "$EDITOR "
set_env SYSTEMD_EDITOR $EDITOR
set_env PAGER 'less'

#set -gx BROWSER /usr/bin/xdg-open

# fcitx5 settings
# set -gx GTK_IM_MODULE fcitx
# set -gx QT_IM_MODULE fcitx
# set -gx XMODIFIERS "@im=fcitx"
# set -gx SDL_IM_MODULE fcitx
# set -gx GLFW_IM_MODULE fcitx

# wayland settings
set_env QT_QPA_PLATFORM "wayland"
set_env CLUTTER_BACKEND wayland
set_env SDL_VIDEODRIVER wayland
set_env MOZ_ENABLE_WAYLAND 1

# Path
fish_add_path $HOME/.local/bin
