export HISTFILE=$XDG_DATA_HOME/zsh/.zsh_history

HISTSIZE=1000000
SAVEHIST=1000000

# close completion bell
unsetopt LIST_BEEP

function _debug {
  autoload -U colors && colors

  # set this variable to 1 to enable debug information
  if (( ${DEBUG_ZSH_RC:-0} == 1 )); then
    echo "$fg[green]INFO$reset_color: $1"
  fi
}

function _init_prompt {
  if (( $+commands[starship] )) then
    _debug "initialize starship prompt"
    eval "$(starship init zsh)"
  fi
}

function _init_plugin {
  _debug "installing zinit"

  ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

  if [[ ! -d $ZINIT_HOME ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
  fi

  _debug  "sourcing plugins"

  source "${ZINIT_HOME}/zinit.zsh"

  zinit light zdharma-continuum/fast-syntax-highlighting

  zinit light zsh-users/zsh-autosuggestions
  autoload -U compinit
  compinit

  zinit light zsh-users/zsh-history-substring-search

  zinit light zdharma-continuum/history-search-multi-word

}

function _init_local {
  source $XDG_CONFIG_HOME/zsh/zoxide.zsh
  source $XDG_CONFIG_HOME/zsh/fn.zsh
}

function _init_alias {
  # G
  alias gp="git push"

  # L
  alias ll="exa -l -@ -h --icons --group-directories-first"
  alias lt="exa -l -T -L2 --icons"
  alias lg="lazygit"

  # M
  alias mk="mkdir"

  # R
  alias zsh_reload="source $HOME/.zshrc;rehash"
  alias rsync="rsync -azvhP"

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

  # Y
  alias ytd="yt-dlp"
}

function _init_keys {
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
}

_init_prompt
_init_plugin
_init_alias
_init_keys
_init_local
