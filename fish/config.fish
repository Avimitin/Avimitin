set COLOR_RED '\e[31m'
set COLOR_GREEN '\e[32m'
set COLOR_NM '\e[0m'

# function to test executable exist
function exec_exist
	if test -z (command -v $argv)
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
	echo -e $COLOR_RED"starship not found"$COLOR_NM
	echo "install it: https://starship.rs/guide/#%F0%9F%9A%80-installation"
	echo "or run command:"
	echo "sh -c '\$(curl -fsSL https://starship.rs/install.sh)'"
end

if $has_starship
	starship init fish | source
end

#----test nnn-----
if not exec_exist nnn
	echo $COLOR_RED"nnn not found"$COLOR_NM
	echo "Install nnn https://github.com/jarun/nnn/wiki/Usage"
	set has_nnn false
end

if $has_nnn
	export NNN_PLUG_GIT='g:lazygit;d:diffs'
	export NNN_PLUG_EXPLORE='j:autojump;f:finder;o:fzopen'
	export NNN_PLUG_FILE='t:nmount'
	export NNN_PLUG_VIEW='p:mocplay;v:imgview;p:preview-tui-ext'
	export NNN_PLUG="$NNN_PLUG_GIT;$NNN_PLUG_EXPLORE;$NNN_PLUG_FILE;$NNN_PLUG_VIEW"
	export NNN_FCOLORS="0B0B04060006060009060B06"
	set --export NNN_FIFO "/tmp/nnn.fifo"
end

#---test lsd----
if not exec_exist lsd
	echo $COLOR_RED"lsd not found"$COLOR_NM
	echo "Install nnn https://github.com/Peltoche/lsd#installation"
end
if $has_lsd
	alias ls lsd
end

#----test jump----
#if not exec_exist jump
#	echo -e $COLOR_RED"jump not found"$COLOR_NM
#	echo "install it from https://github.com/gsamokovarov/jump"
#	echo "or using go:"
#	echo "go get github.com/gsamokovarov/jump"
#end
#
#if $has_jump
#	status --is-interactive; and source (jump shell fish | psub)
#end

if test -x ~/scripts/fetch-host-ip.sh
	set host_ip (~/scripts/fetch-host-ip.sh)
	set -gx http_proxy "http://$host_ip:7890"
	set -gx https_proxy "http://$host_ip:7890"
end

# ---test zoxide---
if not exec_exist zoxide
	echo -e $COLOR_RED"zoxide not found"$COLOR_NM
	echo "install it from https://github.com/ajeetdsouza/zoxide"
end

if $has_zoxide
	zoxide init fish | source
end
