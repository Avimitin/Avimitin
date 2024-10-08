#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Allow using ncurse as askpass
export GPG_TTY=$(tty)

# Set fzf default theme
export FZF_DEFAULT_OPTS='--height 35% --layout=reverse'

# manually setting locale archive to fix programs from nixpkgs doesn't correctly use locale
# archive in glibc issues.
if [[ -r /usr/lib/locale/locale-archive ]]; then
    export LOCALE_ARCHIVE='/usr/lib/locale/locale-archive'
fi

# Set xdg dir
export XDG_CONFIG_HOME="$HOME/.config/"
export XDG_CACHE_HOME="$HOME/.cache/"
export XDG_DATA_HOME="$HOME/.local/share"

export EDITOR='nvim'
export VISUAL="$EDITOR "
export SYSTEMD_EDITOR="$EDITOR"
export PAGER='less -R'
export MANPAGER='nvim +Man!'

alias v='bat'
alias vi="nvim"
alias ll='lsd --long'
alias lg='lazygit'
alias rm='rm -i'

function gb() {
  local _green_ref="%(color:ul bold green)%(refname:short)%(color:reset)"
  local _normal_ref="%(refname:short)"
  git branch --color=always --format "%(align:33,left)%(HEAD) %(if)%(HEAD)%(then)$green_ref%(else)$normal_ref%(end)%(end)  %(color:bold yellow)%(upstream:track)%(color:reset)" \
      | sed 's/\[ahead/\[↑/; s/, behind /, ↓ /'
}

alias gl="git log --graph --abbrev-commit --decorate \
    --format=format:'%C(dim blue)%h%C(reset) %C(bold green)➜%C(reset) %C(bold white)%s%C(reset) - %C(yellow)[%an]%C(reset)%C(auto)%d%C(reset)%n''\
    %C(italic dim white)%ai (%ar) %C(reset)'"

alias gdc="git diff --cached"
alias gpf="git push --force-with-lease"
alias grc="git rebase --continue"
alias gra="git rebase --abort"

# Transfer file in [a]rchive (to preserve attributes) and
# compressed ([z]ipped) mode with [v]erbose and [h]uman-readable
# [P]rogress [r]ecursively, if file is a [L]ink, copy its referent file.
# Skip based-on [c]hecksum instead of mod-time & size.
alias rsynca="command rsync -aczrvhPL"

alias tl="command tmux ls"
alias ta="command tmux attach-session -t"

alias userctl="command systemctl --user"

alias ..="command cd .."
alias ...="command cd ../.."

alias ip="command ip --color=auto"

# --

if [[ -r "@BASH_COMPLETION@" ]]; then
    . @BASH_COMPLETION@/etc/profile.d/bash_completion.sh
fi

if [[ -r "@COMPLETE_ALIAS@" ]]; then
    . @COMPLETE_ALIAS@/complete_alias

    complete -F _complete_alias userctl
    complete -F _complete_alias ip
    complete -F _complete_alias rsynca
fi

eval "$(zoxide init bash)"
eval "$(fzf --bash)"
eval "$(starship init bash)"
