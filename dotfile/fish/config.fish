if not status is-interactive
  return
end

alias rm "rm -i"

# ===================================================================
# alias
# ===================================================================
if command -q bat
    alias v bat
end

if command -q fzf
    # Set directory search to Ctrl-S and remove other unused functionality
    fzf_configure_bindings --directory=\cs --variables= --git_log= --git_status= --processes=
end

if command -q starship
    # Enable starship
    function starship_transient_prompt_func
        starship module character
    end
    starship init fish | source
    enable_transience
end

if command -q direnv
    direnv hook fish | source
end

if command -q lsd
    alias ll "lsd --long"
    alias lt "lsd --tree --depth=2"
end

if command -q zoxide
    zoxide init fish | source
end

# G
if command -q git
    alias gc "git commit --interactive --signoff --verbose"
    alias gco "git checkout"
    alias ga "git add"
    alias gaa "git commit --amend --no-edit --allow-empty"
    alias gpp "git pull --recurse-submodules"
    alias gp "git push"
    alias gr "git rebase"
    alias grc "git rebase --continue"
    alias gra "git rebase --abort"
    alias gl "git log --graph --abbrev-commit --decorate \
        --format=format:'%C(bold blue)%h%C(reset) %C(ul bold white)%s%C(reset) - %C(green)[%an]%C(reset)%C(auto)%d%C(reset)%n''\
        %C(italic dim white)%ai (%ar) %C(reset)'"
    alias gd "git diff"

    function gs
        function print_header
            echo
            set_color --bold yellow
            echo "$argv:"
            set_color normal
        end

        print_header Files
        git status --short

        print_header Branches
        git branch -v

        print_header Stash
        git stash list
    end
end

if command -q rsync
    # Transfer file in [a]rchive (to preserve attributes) and
    # compressed ([z]ipped) mode with [v]erbose and [h]uman-readable
    # [P]rogress [r]ecursively, if file is a [L]ink, copy its referent file.
    alias rsy "command rsync -azrvhPL"
end

if command -q rg
    function rgl
        rg -C5 --pretty $argv | less -R
    end
end

if command -q ssh
    # this fix tmux color
    alias ssh "TERM=xterm-256color command ssh"
end

if command -q nvim
    alias vi "nvim"
else if command -q vim
    alias vi "vim"
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
# TODO: rewrite it in systemd user service
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
set_env MANPAGER 'nvim +Man!'

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
