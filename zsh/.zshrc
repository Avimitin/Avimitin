export HISTFILE=$XDG_DATA_HOME/zsh/.zsh_history

HISTSIZE=1000000
SAVEHIST=1000000

# close completion bell
unsetopt LIST_BEEP

function _init_keys {
  # close vi mode
  bindkey -e
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
}

_init_plugin
_init_keys

# Source separate scripts
source "$XDG_CONFIG_HOME/zsh/plugins.zsh"
source "$XDG_CONFIG_HOME/zsh/alias.zsh"
source "$XDG_CONFIG_HOME/zsh/fn.zsh"
