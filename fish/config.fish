# ===================================================================
# env
# ===================================================================
set -gx LANG en_US.UTF-8

set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share

set -gx EDITOR 'nvim'
set -gx VISUAL "$EDITOR "
set -gx SYSTEMD_EDITOR $EDITOR
set -gx PAGER 'less'

set -gx BROWSER /usr/bin/xdg-open

set -gx BAT_THEME "OneHalfDark"


# ===================================================================
# alias
# ===================================================================
if command -q exa
    alias ll "exa -l -@ -h --icons --group-directories-first"
    alias lt "exa -l -T -L2 --icons"
end

if command -q neovide
    alias edt "neovide --multigrid"
end

if command -q zoxide
    zoxide init fish | source
end

# G
if command -q git
    alias gp "git push"
    alias ga "git add"
end

if command -q lazygit
    alias lg "lazygit"
end

if command -q rsync
    # Transfer file in [a]rchive (to preserve attributes) and
    # compressed ([z]ipped) mode with [v]erbose and [h]uman-readable
    # [P]rogress
    alias rsync "command rsync -azvhP"

    # Transfer a directory [r]ecursively and ignoring already transferred
    # files [u]nless newer
    alias rsyncd "command rsync -azruhP"
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

    set _selection (xsel -b)
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

# systemd
alias "systart" "sudo systemctl start"
alias "systop" "sudo systemctl stop"
alias "systat" "sudo systemctl status"

# zellij

function zj
    if test -n "$argv"
        zellij -s $argv
    else
        # default session name
        zellij -s "zellij"
    end
end

if command -q zellij
    alias za "zellij attach"
    alias zl "zellij list-sessions"
    alias zk "zellij kill-session"
end

# ===================================================================
# keybinding
# ===================================================================

# enable vi keybind
set -g fish_key_bindings fish_vi_key_bindings

# set my keybind
bind -M default 'H' beginning-of-line
bind -M visual 'H' beginning-of-line
bind -M default 'L' end-of-line
bind -M visual 'L' end-of-line
bind -M insert '\e;' escape

# ===================================================================
# fish settings
# ===================================================================
set -x fish_greeting ""


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
