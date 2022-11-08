ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
LOCK_FILE=${XDG_CONFIG_HOME}/zsh/.noplug.lck

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

unset LOCK_FILE

source "${ZINIT_HOME}/zinit.zsh"

# PLUGIN LIST
depends=(
  # Syntax Highlight
  zdharma-continuum/fast-syntax-highlighting

  # Auto suggestion
  zsh-users/zsh-autosuggestions

  # History search
  zsh-users/zsh-history-substring-search
  zdharma-continuum/history-search-multi-word

  # Auto close delimiters
  hlissner/zsh-autopair
)

# Install them
for repo in ${depends[@]}; do
  zinit light $repo
done

# Setup auto complete
autoload -U compinit
compinit -d $ZSH_CACHE_DIR/zcompinit

# ================================================================================================
# Completion Config
#
# Credit: https://github.com/CoelacanthusHex/dotfiles/blob/master/zsh/.config/zsh.d/completion.zsh
# ================================================================================================
zmodload -i zsh/complist
autoload -U +X bashcompinit && bashcompinit

unsetopt menu_complete
unsetopt flowcontrol
setopt auto_menu
setopt complete_in_word
setopt listpacked
setopt magic_equal_subst
unsetopt complete_aliases

# Better performance for apt, dpkg...commands
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR

eval "$(dircolors -b $ZDOTDIR/LS_COLORS)"
export ZLSCOLORS="${LS_COLORS}"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
# Menu complete
zstyle ':completion:*' menu yes select
# Display by group
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*:matches' group yes
zstyle ':completion:*:options' description yes
# ignore duplicate entries
zstyle ':completion:*:history-words'   remove-all-dups yes
zstyle ':completion:*:history-words'   stop yes
# define files to ignore for zcompile
zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc|*.zwc.old)'
zstyle ':completion:correct:'          prompt 'correct to: %e'
# ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'
# Enable case-insensitive completion
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**'
# Enhanced filename completion
# 0 - Exact match               ( Abc -> Abc )
# 1 - Capitalization correction ( abc -> Abc )
# 2 - Word completion           ( f-b -> foo-bar )
# 3 - Suffix completion         ( .cxx -> foo.cxx )
zstyle ':completion:*:(argument-rest|files):*' matcher-list \
    '' \
    'm:{[:lower:]-}={[:upper:]_}' \
    'r:|[.,_-]=* r:|=*' \
    'r:|.=* r:|=*'
zstyle ':completion:*:descriptions' format '%F{blue}> %d: %f'
zstyle ':completion:*:messages' format '%F{purple}> %d: %f'
# Warnings are displayed in red
zstyle ':completion:*:warnings' format '%F{red}%B -- No Matches Found --%b%f'
zstyle ':completion:*:corrections' format '%F{yellow}%B -- %d (errors: %e) --%b%f'
# Description for options that are not described by the completion functions, but that have exactly one argument
zstyle ':completion:*' auto-description '%F{green}Specify: %d%f'
# Do not go back to current directory after ..
zstyle ':completion:*:cd:*' ignore-parents parent pwd
# Error correction
zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct


# ========================================================================================================
# Prompt Setup
# ========================================================================================================
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

autoload -U promptinit
promptinit

# Pure configuration
PURE_GIT_PULL=0
PURE_PROMPT_SYMBOL=""
prompt_newline='%666v'
PROMPT=" $PROMPT"

# ========================================================================================================
# History Search
# ========================================================================================================
# zsh-history-substring-search
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
export HISTORY_SUBSTRING_SEARCH_PREFIXED=true
# Treat 'ab c' as '*ab*c*'
export HISTORY_SUBSTRING_SEARCH_FUZZY=true


# ========================================================================================================
# FZF Setup
# ========================================================================================================
if (( ${+commands[fzf]} )); then
  if [[ -d "/usr/share/fzf" ]]; then
    local fzf_dir="/usr/share/fzf"
    source "${fzf_dir}/completion.zsh"
    source "${fzf_dir}/key-bindings.zsh"
  fi

  if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  elif (( $+commands[rg] )); then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
  fi
fi
