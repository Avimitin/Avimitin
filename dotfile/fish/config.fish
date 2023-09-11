if not status is-interactive
  return
end

# ===================================================================
# alias
# ===================================================================
if command -q direnv
    direnv hook fish | source
end

if command -q broot
    function br --wraps=broot
        set -l cmd_file (mktemp)
        if broot --outcmd $cmd_file $argv
            read --local --null cmd < $cmd_file
            rm -f $cmd_file
            eval $cmd
        else
            set -l code $status
            rm -f $cmd_file
            return $code
        end
    end
end

if command -q nix
    alias nixr "nix run"
    alias nixl "nix develop"
    alias nixb "nix build"
end

if command -q exa
    alias ll "exa -l -@ -h --icons --group-directories-first"
    alias lt "exa -l -T -L2 --icons"
end

if command -q lsd
    alias ll "lsd --long"
    alias lt "lsd --tree --depth=2"
end

if command -q neovide
    alias nvi "neovide --multigrid"
end

if command -q zoxide
    zoxide init fish | source
end

# G
if command -q git
    alias pp "git pull"
    alias p "git push"
    alias r "git rebase"
    alias rc "git rebase --continue"
    alias ra "git rebase --abort"
    alias s "git status --short"
end

if command -q lazygit
    alias lg "lazygit"
end

if command -q rsync
    # Transfer file in [a]rchive (to preserve attributes) and
    # compressed ([z]ipped) mode with [v]erbose and [h]uman-readable
    # [P]rogress [r]ecursively.
    alias rsy "command rsync -azrvhP"
end

if command -q ssh
    # this fix tmux color
    alias ssh "TERM=xterm-256color command ssh"
end

if command -q tmux
    alias ta 'tmux attach -t'
    alias tad 'tmux attach -d -t'
    alias tl 'tmux list-sessions'
    alias tksv 'tmux kill-server'
    alias tkss 'tmux kill-session -t'
end

function ts
    if not command -q tmux
        echo "No tmux found"
        return
    end

    if test -n "$argv"
        tmux new-session -s $argv
        return
    end

    tmux new-session -s A
end

if command -q python3
    alias urldecode 'python3 -c "import sys, urllib.parse as up; print(up.unquote(sys.argv[1]))"'
    alias urlencode 'python3 -c "import sys, urllib.parse as up; print(up.quote(sys.argv[1]))"'
end

if command -q nvim
    alias vi "nvim"
else if command -q vim
    alias vi "vim"
end

# Y
function ytd
    if not command -q 'yt-dlp'
        echo "this function needs yt-dlp"
        return
    end

    if test -n "$argv"
        yt-dlp "$argv"
        return
    end

    if test -n "$WAYLAND_DISPLAY"
        set _selection (wl-paste)
    else
        set _selection (xsel -b)
    end

    printf "Current selection: %s%s%s\n" (set_color blue) $_selection (set_color normal)
    read -l -p "echo 'Are you sure to download this video? [y/n]'" _confirm
    switch $_confirm
        case Y y
            set _download_dir "$HOME/Downloads/YouTube_Video"
            mkdir -p $_download_dir && cd $_download_dir
            yt-dlp "$_selection" --write-thumbnail
            convert (fd -e 'webp' .) -resize 1250x960 thumbnail-resize.png
            echo "Done..."
        case '' N n
            echo "Quit.."
            return 0
    end
end

if command -q gpg
    alias gpg-uptty "gpg-connect-agent updatestartuptty /bye"
    alias gpg-swckey 'gpg-connect-agent "scd serialno" "learn --force" /bye'
end

# systemd
alias "systart" "sudo systemctl start"
alias "systop" "sudo systemctl stop"
alias "systat" "sudo systemctl status"
alias "sysres" "sudo systemctl restart"

# Use gpg-agent to replace ssh-agent
if command -q gpgconf
  set -gx GPG_TTY (tty)
  gpgconf --launch gpg-agent
  set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
end

set -x fish_greeting ""

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

# ===================================================================
# fish themes
# ===================================================================
# Kanagawa Fish shell theme
# A template was taken and modified from Tokyonight:
# https://github.com/folke/tokyonight.nvim/blob/main/extras/fish_tokyonight_night.fish
set -l foreground DCD7BA
set -l selection 2D4F67
set -l comment 727169
set -l red C34043
set -l orange FF9E64
set -l yellow C0A36E
set -l green 76946A
set -l purple 957FB8
set -l cyan 7AA89F
set -l pink D27E99

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment

# Hydro
set -g hydro_color_git $orange
set -g hydro_color_prompt $green
set -g hydro_color_duration $comment
set -g hydro_color_pwd $foreground

# Hydro prompt settings
set -g hydro_symbol_prompt ''
set -g hydro_symbol_git_dirty ' '
set -g hydro_symbol_git_ahead ' '
set -g hydro_symbol_git_behind ' '
set -g fish_prompt_pwd_dir_length 2
