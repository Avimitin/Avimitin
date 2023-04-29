# ===================================================================
# alias
# ===================================================================
if command -q exa
    alias ll "exa -l -@ -h --icons --group-directories-first"
    alias lt "exa -l -T -L2 --icons"
end

if command -q neovide
    alias nvi "neovide --multigrid"
end

if command -q zoxide
    zoxide init fish | source
end

# G
if command -q git
    alias g "git pull"
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

# systemd
alias "systart" "sudo systemctl start"
alias "systop" "sudo systemctl stop"
alias "systat" "sudo systemctl status"
alias "sysres" "sudo systemctl restart"
