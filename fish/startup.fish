# =================================================================
# UTILITIES
# =================================================================
set COLOR_RED '\e[31m'
set COLOR_GREEN '\e[32m'
set COLOR_YELLOW '\e[33m'
set COLOR_NM '\e[0m'

if test -z (pgrep ssh-agent | string collect)
    eval (ssh-agent -c)
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

function WARNING
  echo -e "$COLOR_RED$argv[1]$COLOR_NM"
end

function SUCCESS
  echo -e "$COLOR_GREEN$argv[1]$COLOR_NM"
end

function HINT
  echo -e "$COLOR_YELLOW$argv[1]$COLOR_NM"
end

# function to test executable exist
function exec_exist
	set exec $argv[1]
	set -g has_$argv false

	if test -z (command -v $exec)
        WARNING "$exec not found"
		return 1
	end

    set has_$argv true
	return 0
end

# =================================================================
# MAIN STEP
# =================================================================

# ======== set up vi mode =========
fish_vi_key_bindings

# Test if I am using arch
set IS_ARCH_LINUX false
if uname -a | grep -q "arch"
  set IS_ARCH_LINUX true
end

# ======= starship =======
if not exec_exist starship
    if $IS_ARCH_LINUX
      HINT "RUN: paru -S starship"
    else
      HINT "RUN: sh -c '\$(curl -fsSL https://starship.rs/install.sh)'"
    end
end

if $has_starship
  starship init fish | source
  set --erase $has_starship
end

# ========= exa ===========
if not exec_exist exa
    if $IS_ARCH_LINUX
      HINT "RUN: paru -S exa"
    else
      HINT "FOLLOW: https://github.com/ogham/exa#installation"
    end
end

if $has_exa
    alias ll "exa -l -@ --icons --group-directories-first"
    alias lt "exa -l -T -L2 --icons"

    set --erase $has_exa
end

# =========== zoxide ===========
if not exec_exist zoxide
    if $IS_ARCH_LINUX
      HINT "RUN: paru -S zoxide"
    else
      HINT "FOLLOW: https://github.com/ajeetdsouza/zoxide#step-1-install-zoxide"
    end
end

if $has_zoxide
	zoxide init fish | source

    set --erase $has_zoxide
end

# ========= clean up ===========
functions -e exec_exist
functions -e WARNING
functions -e SUCCESS
functions -e HINT

set --erase COLOR_RED
set --erase COLOR_GREEN
set --erase COLOR_NM
set --erase COLOR_YELLOW
