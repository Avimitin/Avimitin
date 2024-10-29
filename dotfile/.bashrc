#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ $DISPLAY ]] && shopt -s checkwinsize

#PS1='[\u@\h \W]\$ '
liBlack="\[\033[0;30m\]"
boBlack="\[\033[1;30m\]"
liRed="\[\033[0;31m\]"
boRed="\[\033[1;31m\]"
liGreen="\[\033[0;32m\]"
boGreen="\[\033[1;32m\]"
liYellow="\[\033[0;33m\]"
boYellow="\[\033[1;33m\]"
liBlue="\[\033[0;34m\]"
boBlue="\[\033[1;34m\]"
liMagenta="\[\033[0;35m\]"
boMagenta="\[\033[1;35m\]"
liCyan="\[\033[0;36m\]"
boCyan="\[\033[1;36m\]"
liWhite="\[\033[0;37m\]"
boWhite="\[\033[1;37m\]"

PS1="$boGreen\u$liWhite@$boBlue\h$liWhite $boYellow\w$boMagenta\`git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/ (\1)/'\` $boRed{\`let exitstatus=\$_EXIT_CODE ; if [[ \${exitstatus} != 0 ]] ; then echo \"\${exitstatus}\" ; else echo "0" ; fi\`}$liWhite\$ "
PROMPT_COMMAND="_EXIT_CODE=\$?; ${PROMPT_COMMAND:-:}"

case ${TERM} in
  Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|tmux*|xterm*)
    PROMPT_COMMAND+=('printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"')
    ;;
  screen*)
    PROMPT_COMMAND+=('printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"')
    ;;
esac

if [[ -r /usr/share/bash-completion/bash_completion ]]; then
  . /usr/share/bash-completion/bash_completion
fi

export PATH="$HOME/.nix-profile/bin:$PATH"
export GPG_TTY=$(tty)
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export CLICOLOR=1

if [[ -r /usr/lib/locale/locale-archive ]]; then
  export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
fi

if command -v nvim >/dev/null; then
  alias vi="nvim"
  export EDITOR="nvim"
elif command -v vim >/dev/null; then
  alias vi="vim"
  export EDITOR="vim"
fi

export VISUAL="$EDITOR "
export SYSTEMD_EDITOR=$EDITOR
export PAGER='less -R'
export MANPAGER='nvim +Man!'
export FZF_DEFAULT_OPTS='--height 35% --layout=reverse'

alias rm="rm -i"
alias ll="lsd --long"
alias la="ls -al"
alias lt="lsd --tree --depth=2"
alias g="command git"

# Transfer file in [a]rchive (-a == -rlptgoD: recursive, copy symlihnk as
# symlink, preserve permission, mod time, group, owner, copy device) compressed
# ([z]ipped) mode with [v]erbose and [h]uman-readable [P]rogress, if file is a
# [L]ink, copy its referent file. Skip based-on [c]hecksum instead of mod-time
# & size.
alias rsyncz="command rsync -aczvhPL"
alias rsynca="command rsync -avhP"

alias ssh="env TERM=xterm-256color ssh"

alias tl="command tmux ls"
alias ta="command tmux attach-session -t"

alias userctl="command systemctl --user"
alias ip="command ip -c"

function search() {
  rg --json -C 2 $@ | delta --line-numbers
}

eval "$(zoxide init bash)"
