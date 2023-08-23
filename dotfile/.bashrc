#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -alh --color=auto --group-directories-first'
alias tml="tmux ls"
alias tma="tmux attach-sesstion -t"

if [[ -d "/usr/share/fzf" ]]; then
  source "/usr/share/fzf/completion.bash"
  source "/usr/share/fzf/key-bindings.bash"
fi

eval "$(direnv hook bash)"
