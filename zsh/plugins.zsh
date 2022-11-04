ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
LOCK_FILE=${XDG_CONFIG_HOME}/zsh/.noplug.lck
HAS_PLUGIN=0

if [[ -f $LOCK_FILE ]]; then
  return
fi

if [[ ! -d $ZINIT_HOME ]]; then
  if ! read -q "repl?No plugin found, press y/Y to install, press other key to abort and create $LOCK_FILE to always no plugin"; then
    touch $LOCK_FILE
    return
  fi

  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# PLUGIN LIST

# Syntax Highlight
zinit light zdharma-continuum/fast-syntax-highlighting

# Auto suggestion
zinit light zsh-users/zsh-autosuggestions
autoload -U compinit
compinit

# History search
zinit light zsh-users/zsh-history-substring-search
zinit light zdharma-continuum/history-search-multi-word

# Prompt
zinit light sindresorhus/pure
autoload -U promptinit
promptinit

unset LOCK_FILE
unset HAS_PLUGIN
