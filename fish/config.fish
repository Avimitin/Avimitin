set -x fish_greeting ""

# ===================================================================
# alias
# ===================================================================
if command -q starship
  starship init fish | source
end

if command -q exa
    alias ll "exa -l -@ -h --icons --group-directories-first"
    alias lt "exa -l -T -L2 --icons"
end

if command -q zoxide
    zoxide init fish | source
end

# G
if command -q git
    alias gp "git push"
end

if command -q lazygit
    alias lg "lazygit"
end

if command -q rsync
    alias rsync "command rsync -azvhP"
end

if command -q ssh
    # this fix tmux color
    alias ssh "TERM=xterm-256color command ssh"
end

if command -q tmux
    alias ta 'tmux attach -t'
    alias tad 'tmux attach -d -t'
    alias ts 'tmux new-session -s'
    alias tl 'tmux list-sessions'
    alias tksv 'tmux kill-server'
    alias tkss 'tmux kill-session -t'
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
    echo "Current selection: $_selection"
    read -l -p "echo 'Are you sure to download this video? [y/n]'" _confirm
    switch $_confirm
        case Y y
            yt-dlp "$_selection"
        case '' N n
            echo "Quit.."
            return 0
    end
end

# systemd
alias "systart" "sudo systemctl start"
alias "systop" "sudo systemctl stop"
alias "systat" "sudo systemctl status"

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
# keybinding
# ===================================================================

# enable vi keybind
fish_vi_key_bindings

# set my keybind
function fish_user_key_binding
    bind --preset -M default 'H' beginning-of-line
    bind --preset -M visual 'H' beginning-of-line
    bind --preset -M default 'L' end-of-line
    bind --preset -M visual 'L' end-of-line
end
