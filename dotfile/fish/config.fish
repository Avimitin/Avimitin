if not status is-interactive
  return
end

fish_add_path "$HOME/.nix-profile/bin"

# ===================================================================
# hooks
# ===================================================================
if command -q direnv
    direnv hook fish | source
end

if command -q atuin
    atuin init fish | source
end

if command -q zoxide
    zoxide init fish | source
end

# ===================================================================
# alias
# ===================================================================
alias rm "rm -i"

if command -q rg
    function search
        rg --json -C 2 $argv | delta --line-numbers
    end

    function search_and_replace
        set -l _dir .
        if test -n "$argv[3]"
            set _dir "$argv[3]"
        end
        echo "Replacing $argv[1] to $argv[2] in dir $_dir"
        sed -i "s|$argv[1]|$argv[2]|" $(rg --no-ignore -l "$argv[1]" "$_dir")
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
end


if command -q lsd
    alias ll "command lsd --long"
    alias lt "command lsd --tree --depth=2"
else
    alias ll "command ls -al --color"
end
alias la="command ls -al --color"

if command -q rsync
    # Transfer file in [a]rchive (-a == -rlptgoD: recursive, copy symlihnk as symlink, preserve permission, mod time, group, owner, copy device)
    # compressed ([z]ipped) mode with [v]erbose and [h]uman-readable [P]rogress, if file is a [L]ink, copy its referent file.
    # Skip based-on [c]hecksum instead of mod-time & size.
    alias rsyncz "command rsync -aczvhPL"
    alias rsynca "command rsync -avhP"
end

if command -q ssh
    # this fix tmux color
    alias ssh "TERM=xterm-256color command ssh"
end

if command -q tmux
    alias tl "tmux ls"
    alias ta "tmux attach-session -t"
end

if command -q nvim
    alias vi "nvim"
    set -gx EDITOR 'nvim'
    set -gx MANPAGER 'nvim +Man!'
else if command -q vim
    alias vi "vim"
    set -gx EDITOR 'vim'
    set -gx MANPAGER 'vim +Man!'
end

alias userctl "command systemctl --user"
alias ip "ip -c"

# ===================================================================
# Variables
# ===================================================================

# Allow using ncurse as askpass
if command -q gpg
    set -gx GPG_TTY (tty)
end

# manually setting locale archive to fix programs from nixpkgs doesn't correctly use locale
# archive in glibc issues.
if test -r "@nix_locale_archive@"
    set -gx LOCALE_ARCHIVE "@nix_locale_archive@"
else if test -r /usr/lib/locale/locale-archive
    set -gx LOCALE_ARCHIVE /usr/lib/locale/locale-archive
end

set -x fish_greeting ""
# --global --export
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx CLICOLOR 1
if test -n "$EDITOR"
    set -gx VISUAL "$EDITOR "
end
set -gx SYSTEMD_EDITOR $EDITOR
set -gx PAGER 'less -R'
set -gx FZF_DEFAULT_OPTS '--height 35% --layout=reverse'

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
