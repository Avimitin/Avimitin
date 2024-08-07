# prepare the dir
[[ -d $ZSH_CACHE_DIR ]] || mkdir -p $ZSH_CACHE_DIR

# no vi mode
bindkey -e

autoload -U select-word-style
select-word-style bash

bindkey '^W' backward-kill-word

# close completion bell
unsetopt LIST_BEEP

# Source separate scripts
source "$ZDOTDIR/plugins.zsh"
source "$ZDOTDIR/alias.zsh"
source "$ZDOTDIR/fn.zsh"

# GPG Agent
replace_ssh_agent() {
  local is_in_ssh=0

  if [[ -n "$SSH_CLIENT" ]] || [ -n "$SSH_TTY" ]; then
    is_in_ssh=1
  fi

  if command -v gpgconf > /dev/null && (( $is_in_ssh == 0 )); then
    export GPG_TTY=$TTY
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent
  fi
}

# Execute and remove it
replace_ssh_agent
unset replace_ssh_agent

# opam configuration
[[ ! -r $HOME/.opam/opam-init/init.zsh ]] \
  || source $HOME/.opam/opam-init/init.zsh &> /dev/null
