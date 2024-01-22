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

if command -q nix
    function _nix_complete
      set -l nix_args (commandline --current-process --tokenize --cut-at-cursor)
      set -l current_token (commandline --current-token --cut-at-cursor)
      set -l nix_arg_to_complete (count $nix_args)

      env NIX_GET_COMPLETIONS=$nix_arg_to_complete $nix_args $current_token
    end

    function _nix_accepts_files
      set -l response (_nix_complete)
      test $response[1] = 'filenames'
    end

    function _nix
      set -l response (_nix_complete)
      string collect -- $response[2..-1]
    end

    # Disable file path completion if paths do not belong in the current context.
    complete --command nix --condition 'not _nix_accepts_files' --no-files

    complete --command nix --arguments '(_nix)'
end

if test -r /usr/lib/locale/locale-archive
    # manually setting locale archive to fix programs from nixpkgs doesn't correctly use locale
    # archive in glibc issues.
    set -gx LOCALE_ARCHIVE /usr/lib/locale/locale-archive
end

if command -q mcfly
    set -gx MCFLY_INTERFACE_VIEW BOTTOM
    set -gx MCFLY_DISABLE_MENU TRUE
    mcfly init fish | source
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
    if command -q lazygit
        alias g lazygit
    end

    function c
        if test -n "$argv"
            git commit --signoff -m "$argv"
        else
            git commit --signoff --verbose
        end
    end

    function s
        function print_header
            set_color --bold yellow
            echo "$argv:"
            set_color normal
        end

        print_header "Files"
        git status --short
        echo

        print_header "Branches"
        set --local green_ref "%(color:ul bold green)%(refname:short)%(color:reset)"
        set --local normal_ref "%(refname:short)"
        git branch --color=always --format "%(align:33,left)%(HEAD) %(if)%(HEAD)%(then)$green_ref%(else)$normal_ref%(end)%(end)  %(color:bold yellow)%(upstream:track)%(color:reset)" \
            | sed 's/\[ahead/\[↑/; s/, behind /, ↓ /'
        echo

        print_header "Commits (5)"
        git --no-pager log --abbrev-commit -n 5 --format=format:'%C(blue)%h%C(reset) %C(white)%s%C(reset) %C(yellow)[%an]%C(reset) %C(auto)%d%C(reset)'
        echo
        echo

        print_header "Stash"
        git stash list
    end

    alias co "git checkout"
    alias gaa "git commit --amend --no-edit --allow-empty"
    alias gf "git fetch -p -P --progress --force"
    alias gpp "git pull"
    alias gp "git push"
    alias grb "git rebase"
    alias grc "git rebase --continue"
    alias gra "git rebase --abort"
    alias gl "git log --graph --abbrev-commit --decorate \
        --format=format:'%C(dim blue)%h%C(reset) %C(bold green)➜%C(reset) %C(bold white)%s%C(reset) - %C(yellow)[%an]%C(reset)%C(auto)%d%C(reset)%n''\
        %C(italic dim white)%ai (%ar) %C(reset)'"
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

set_env XDG_CONFIG_HOME $HOME/.config
set_env XDG_CACHE_HOME $HOME/.cache
set_env XDG_DATA_HOME $HOME/.local/share

set_env EDITOR 'nvim'
set_env VISUAL "$EDITOR "
set_env SYSTEMD_EDITOR $EDITOR
set_env PAGER 'less -R'
set_env MANPAGER 'nvim +Man!'

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

function goforeground
    fg
    commandline --function repaint
end

bind \cz goforeground
