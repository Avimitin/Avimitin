set COLOR_RED '\e[31m'
set COLOR_GREEN '\e[32m'
set COLOR_NM '\e[0m'

# function to test executable exist
function exec_exist
	set exec $argv[1]

	if test -z (command -v $exec)
		echo -e "$COLOR_RED$exec not found$COLOR_NM"
		return 1
	end

	set -g has_$argv true
	return 0
end

if exec_exist go
	set PATH ~/go/bin $PATH
end

if not exec_exist node
	nvm use node || true
end

# ---test starship exist---
if not exec_exist starship
	echo "install it: https://starship.rs/guide/#%F0%9F%9A%80-installation"
	echo "or run command:"
	echo "sh -c '\$(curl -fsSL https://starship.rs/install.sh)'"
end

if $has_starship
	starship init fish | source
end

#----test nnn-----
if not exec_exist nnn
	echo "install it: https://github.com/jarun/nnn/wiki/Usage"
end

if $has_nnn
	export ICONLOOKUP=1
	export NNN_PLUG_GIT='g:lazygit;d:diffs'
	export NNN_BMS="d:$HOME/Documents;c:$HOME/.config;D:$HOME/Downloads/"
	export NNN_PLUG_EXPLORE='j:autojump;f:finder;o:fzopen'
	export NNN_PLUG_FILE='t:nmount'
	export NNN_PLUG_VIEW='v:imgview;p:preview-tui'
	export NNN_PLUG="$NNN_PLUG_GIT;$NNN_PLUG_EXPLORE;$NNN_PLUG_FILE;$NNN_PLUG_VIEW"
	export NNN_FCOLORS="0B0B04060006060009060B06"
	set --export NNN_FIFO "/tmp/nnn.fifo"
end

#---test lsd----
if not exec_exist exa
	echo $COLOR_RED"exa not found"$COLOR_NM
	echo "Install nnn https://github.com/Peltoche/lsd#installation"
end

if $has_exa
	alias ls "exa -l --icons"
end

# ---test zoxide---
if not exec_exist zoxide
	echo -e $COLOR_RED"zoxide not found"$COLOR_NM
	echo "install it from https://github.com/ajeetdsouza/zoxide"
end

if $has_zoxide
	zoxide init fish | source
end
