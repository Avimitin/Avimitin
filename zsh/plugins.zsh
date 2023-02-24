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

setopt auto_menu
setopt auto_list
setopt auto_param_slash
setopt always_to_end
setopt complete_in_word
setopt path_dirs
setopt listpacked
setopt magic_equal_subst
setopt extended_glob
unsetopt menu_complete
unsetopt flowcontrol
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
zstyle ':completion:*' original true
zstyle ':completion:*:descriptions' format '%F{blue}> %d: %f'
zstyle ':completion:*:messages' format '%F{purple}> %d: %f'
# Warnings are displayed in red
zstyle ':completion:*:warnings' format '%F{red}%B -- No Matches Found --%b%f'
zstyle ':completion:*:corrections' format '%F{yellow}%B -- %d (errors: %e) --%b%f'
# Description for options that are not described by the completion functions, but that have exactly one argument
zstyle ':completion:*' auto-description 'Specify: %d'
# Do not go back to current directory after ..
zstyle ':completion:*:cd:*' ignore-parents parent pwd
# Error correction
zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
# disable named-directories autocompletion
zstyle ':completion:*:(cd|z):*' tag-order local-directories directory-stack path-directories

# ssh/scp/rsync
zstyle -e ':completion:*:hosts' hosts 'reply=(
    ${=${=${=${${(f)"$(cat {/etc/ssh/ssh_,~/.ssh/}known_hosts(|2)(#qN) 2> /dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
    ${=${(f)"$(cat /etc/hosts(|)(#qN) <<(ypcat hosts 2> /dev/null))"}%%(\#${_etc_host_ignores:+|${(j:|:)~_etc_host_ignores}})*}
    ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2> /dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
    ${=${${${${(@M)${(f)"$(cat ~/.ssh/config.d/* 2> /dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
    ${=${${${${(@M)${(f)"$(cat ~/.ssh/config.d/**/* 2> /dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'
zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-host hosts-domain hosts-ipaddr
zstyle ':completion:*:ssh:*' group-order users hosts-host hosts-domain users hosts-ipaddr
# remove IP address, loopback, localhost and hostname from hosts list
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns \
    '*(.|:)*' \
    loopback ip6-loopback localhost ip6-localhost broadcasthost \
    $HOST \
    aur
# remove IP address, localdomain and useless doamin from domain list
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns \
    '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*' \
    '*.localdomain' \
    '*.github*' 'github.com' 'aur.archlinux.org'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.<->.<->' '255.255.255.255' '::1' 'fe80::*'
zstyle ':completion:*:(ssh|scp|rsync):*:users' ignored-patterns \
    adm amule amanda apache avahi bin brltty chrony colord courier cups clamav \
    daemon dbus deluge distcache dnsmasq dovecot fax fetchmail flatpak ftp \
    games gdm geoclue gluster gopher grafana http knot lidarr ldap lp \
    mail mailman mailnull mongodb mpd mysql named netdump news nfsnobody \
    nobody nscd ntp node_exporter nvidia-persistenced openvpn \
    papermc pcap pcp polkitd postfix postgres prometheus privoxy pulse pvm \
    quagga radvd redis rpc rpcuser rpm rtkit shutdown squid sshd sync saned \
    sddm shadowsocks-rust sonarr systemd-coredump systemd-journal-remote \
    systemd-network systemd-oom systemd-resolve systemd-timesync \
    transmission tss usbmux uuidd uucp vcsa v2ray xfs


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
# No new line
#prompt_newline='%666v'
#PROMPT=" $PROMPT"

# ========================================================================================================
# History Search
# ========================================================================================================
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
# zsh-history-substring-search
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
# <Shift-Tab> to backward completion menu
bindkey ${terminfo[kcbt]} reverse-menu-complete
export HISTORY_SUBSTRING_SEARCH_PREFIXED=true
# Treat 'ab c' as '*ab*c*'
export HISTORY_SUBSTRING_SEARCH_FUZZY=true

if (( ${+commands[fzf]} )); then
  source $ZDOTDIR/fzf.zsh
fi
