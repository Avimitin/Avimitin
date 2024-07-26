if not status is-interactive
  return
end

fish_add_path "$HOME/.nix-profile/bin"

alias rm "rm -i"

# ===================================================================
# alias
# ===================================================================
if command -q bat
    alias v bat
end

if command -q rg
    function search
        rg --json -C 2 $argv | delta --line-numbers
    end
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
    alias g "git"

    alias ga "git add -p"

    alias gb "git branch -v"

    alias gd "git diff"
    alias gdc "git diff --cached"

    alias co "git checkout"

    alias gc "git commit --signoff --gpg-sign --verbose"
    alias gc! "git commit --amend --no-edit --allow-empty"

    alias gf! "git fetch -p -P --progress --force"

    alias gpa "git pull --all --rebase"
    alias gpl "git pull --rebase"

    alias gp! "git push --force-with-lease"

    alias gr "git rebase --interactive"
    alias grc "git rebase --continue"
    alias gra "git rebase --abort"

    alias gss "git status -s"

    alias glo "git log --graph --decorate --pretty=format:'%C(yellow)%h %C(italic dim white)%ad %Cblue%an%C(reset)%Cgreen%d %Creset%s' --date=short"
    alias glp "git log -p"
end

if command -q rsync
    # Transfer file in [a]rchive (-a == -rlptgoD: recursive, copy symlihnk as symlink, preserve permission, mod time, group, owner, copy device)
    # compressed ([z]ipped) mode with [v]erbose and [h]uman-readable [P]rogress, if file is a [L]ink, copy its referent file.
    # Skip based-on [c]hecksum instead of mod-time & size.
    alias rsyncz "command rsync -aczvhPL"
    alias rsynca "command rsync -avP"
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

if command -q tmux
    alias tl "tmux ls"
    alias ta "tmux attach-session -t"
end

if command -q neovide
    alias nvi neovide
end

if command -q nvim
    alias vi "nvim"
else if command -q vim
    alias vi "vim"
end

alias ip "command ip --color=auto"
alias userctl "command systemctl --user"

# Allow using ncurse as askpass
if command -q gpg
    set -gx GPG_TTY (tty)
end

if command -q fzf
    set -gx FZF_DEFAULT_OPTS '--height 35% --layout=reverse'
end

if command -q ffmpeg
    alias img2mp4 'ffmpeg -r 1/2 -c:v libx264 -pix_fmt yuv420p'
end

if command -q kitty
    alias icat "kitty icat"
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
