# G
alias ga="git add"
alias gc="git commit"
alias gcm="git commit -m"
alias gd="git diff"
alias gp="git pull"
alias gP="git push"
alias gsw="git switch"

# L
alias ll="exa -l -@ -h --icons --git --group-directories-first"
alias lt="exa -l -T -L2 --icons"
alias lg="lazygit"

# R
alias rsy="rsync -azvhP"

# S
alias ssh="TERM=xterm-256color ssh"

# T
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'

# U
alias urldecode='python3 -c "import sys, urllib.parse as up; print(up.unquote(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as up; print(up.quote(sys.argv[1]))"'

# V
alias vi="nvim"

# Z
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

alias reload="sync && exec zsh"
