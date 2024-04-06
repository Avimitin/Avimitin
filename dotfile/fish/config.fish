if not status is-interactive
  return
end

fish_add_path "$HOME/.nix-profile/bin"

function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    fish_vi_key_bindings --no-erase insert
end

alias rm "rm -i"

# ===================================================================
# alias
# ===================================================================
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

    alias nd "nix develop"
    alias nb "nix build -L"
    alias nr "nix run"
end

if test -r /usr/lib/locale/locale-archive
    # manually setting locale archive to fix programs from nixpkgs doesn't correctly use locale
    # archive in glibc issues.
    set -gx LOCALE_ARCHIVE /usr/lib/locale/locale-archive
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

    function s
        function print_header
            set_color --bold yellow
            echo "$argv:"
            set_color normal
        end

        echo
        print_header "Commits (10)"
        git --no-pager log -n 10 --graph --abbrev-commit --decorate \
            --format=format:'%C(dim blue)%h%C(reset) %C(bold white)%s%C(reset) - %C(yellow)[%an]%C(reset)%C(auto)%d%C(reset) %C(italic dim white)(%ar)%C(reset)'
        echo
        echo

        print_header "Branches"
        set --local green_ref "%(color:ul bold green)%(refname:short)%(color:reset)"
        set --local normal_ref "%(refname:short)"
        git branch --color=always --format "%(align:33,left)%(HEAD) %(if)%(HEAD)%(then)$green_ref%(else)$normal_ref%(end)%(end)  %(color:bold yellow)%(upstream:track)%(color:reset)" \
            | sed 's/\[ahead/\[↑/; s/, behind /, ↓ /'
        echo

        print_header "Files"
        git status --short
    end

    function gs
        if test -n "$argv"
            git show $argv
        else
            git show HEAD
        end
    end

    alias gb "git branch -v"

    alias gd "git diff"
    alias gdc "git diff --cached"

    alias co "git checkout"

    alias gc "git commit"
    alias gca "git commit --amend --no-edit --allow-empty"

    alias gf "git fetch -p -P --progress --force"

    alias gpp "git pull"
    alias gp "git push"
    alias gpf "git push --force-with-lease"

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
    # Skip based-on [c]hecksum instead of mod-time & size.
    alias rsy "command rsync -aczrvhPL"
end

if command -q ssh
    # this fix tmux color
    alias ssh "TERM=xterm-256color command ssh"

    # TODO: After ssh setup, run systemctl --user enable --now ssh-agent.service, it will setup the socket
    if test -e "$XDG_RUNTIME_DIR/ssh-agent.socket"
        set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
    end

    # TODO: After ssh-agent is up, run ssh-add <private-key> to store it into agent
end

if command -q neovide
    alias nvi neovide
end

if command -q nvim
    alias vi "nvim"
else if command -q vim
    alias vi "vim"
end

# Allow using ncurse as askpass
if command -q gpg
    set -gx GPG_TTY (tty)
end

if command -q fzf
    set -gx FZF_DEFAULT_OPTS '--height 35% --layout=reverse'
end

# systemd
alias "skt" "systemctl start"
alias "skp" "systemctl stop"
alias "sks" "systemctl status"
alias "skr" "systemctl restart"
alias "jkk" "journalctl -k"
alias "jku" "journalctl -eu"

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
