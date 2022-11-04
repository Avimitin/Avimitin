# prepare the dir
[[ -d $ZSH_CACHE_DIR ]] || mkdir -p $ZSH_CACHE_DIR

# no vi mode
bindkey -e

# Functions
replace_ssh_agent() {
  local is_in_ssh=0

  if [[ -n "$SSH_CLIENT" ]] || [ -n "$SSH_TTY" ]; then
    is_in_ssh=1
  fi

  if command -v gpgconf > /dev/null && (( $is_in_ssh == 0 )); then
    export GPG_TTY=$(tty)
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent
  fi
}

# close completion bell
unsetopt LIST_BEEP

# Source separate scripts
source "$XDG_CONFIG_HOME/zsh/plugins.zsh"
source "$XDG_CONFIG_HOME/zsh/alias.zsh"
source "$XDG_CONFIG_HOME/zsh/fn.zsh"

# close vi mode
bindkey -e
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

replace_ssh_agent
