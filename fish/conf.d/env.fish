set -gx LANG en_US.UTF-8

set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share

set -gx EDITOR 'nvim'
set -gx VISUAL "$EDITOR "
set -gx SYSTEMD_EDITOR $EDITOR
set -gx PAGER 'less'

#set -gx BROWSER /usr/bin/xdg-open

# fcitx5 settings
set -gx GTK_IM_MODULE fcitx
set -gx QT_IM_MODULE fcitx
set -gx XMODIFIERS "@im=fcitx"
set -gx SDL_IM_MODULE fcitx
set -gx GLFW_IM_MODULE fcitx

# wayland settings
set -gx QT_QPA_PLATFORM "wayland;xcb"
set -gx CLUTTER_BACKEND wayland
set -gx SDL_VIDEODRIVER wayland
set -gx MOZ_ENABLE_WAYLAND 1
