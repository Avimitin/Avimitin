DOTS := $(notdir $(wildcard dotfile/*))
S_LN := ln -svf
RM := rm -vi
GIT := git

SUBTREE_PRJ := nvim notes

HOME_DIR ?= $(HOME)
XDG_CONFIG_HOME ?= $(HOME_DIR)/.config

all: prepare $(DOTS)

prepare:
	@mkdir -p $(XDG_CONFIG_HOME)
	@$(GIT) submodule update --init

# ---------------------------------------------

NVIM_SOURCE ?= $(realpath ./dotfile/nvim)
NVIM_TARGET ?= $(XDG_CONFIG_HOME)/nvim
nvim:
	@$(GIT) submodule update --init
	@$(S_LN) $(NVIM_SOURCE) $(NVIM_TARGET)
rm-nvim:
	@$(RM) $(NVIM_TARGET)
upd-nvim:
	@$(GIT) add $(NVIM_SOURCE)
	@$(GIT) commit -m "nvim: bump rev binding"

BASH_SOURCE ?= $(realpath ./dotfile/bash/.bashrc)
BASH_TARGET ?= $(HOME_DIR)/.bashrc
bash:
	@$(S_LN) $(BASH_SOURCE) $(BASH_TARGET)
rm-bash:
	@$(RM) $(BASH_TARGET)

FISH_SOURCE ?= $(realpath ./dotfile/fish)
FISH_TARGET ?= $(XDG_CONFIG_HOME)/fish
fish:
ifneq (,$(wildcard $(FISH_TARGET)))
	@rm -r $(FISH_TARGET)
endif
	@$(S_LN) $(FISH_SOURCE) $(FISH_TARGET)
	@fish $(FISH_TARGET)/setup_plugin.fish
rm-fish:
	@$(RM) $(FISH_TARGET)

GIT_CFG_SOURCE ?= $(realpath ./dotfile/git/.gitconfig)
GIT_TPL_SOURCE ?= $(realpath ./dotfile/git/commit-template.txt)
GIT_CFG_TARGET ?= $(HOME_DIR)/.gitconfig
GIT_TPL_TARGET ?= $(XDG_CONFIG_HOME)/.gittemplate
git:
	@$(S_LN) $(GIT_CFG_SOURCE) $(GIT_CFG_TARGET)
	@$(S_LN) $(GIT_TPL_SOURCE) $(GIT_TPL_TARGET)
	@$(GIT) config --global commit.template $(GIT_TPL_TARGET)
rm-git:
	@$(RM) $(GIT_CFG_TARGET)
	@$(RM) $(GIT_TPL_TARGET)

ZSH_SOURCE ?= $(realpath ./dotfile/zsh)
ZSH_TARGET ?= $(XDG_CONFIG_HOME)/zsh
ZSH_ENV_TARGET ?= $(HOME_DIR)/.zshenv
zsh:
	@$(PKGER) zsh
	@$(S_LN) $(ZSH_SOURCE) $(ZSH_TARGET)
	@$(S_LN) $(ZSH_TARGET)/.zshenv $(ZSH_ENV_TARGET)
rm-zsh:
	@$(RM) $(ZSH_ENV_TARGET)
	@$(RM) $(ZSH_TARGET)

LAZYGIT_SOURCE ?= $(realpath ./dotfile/lazygit/config.yml)
LAZYGIT_HOME ?= $(XDG_CONFIG_HOME)/lazygit
lazygit:
	@mkdir -p $(LAZYGIT_HOME)
	@$(S_LN) $(LAZYGIT_SOURCE) $(LAZYGIT_HOME)/config.yml
rm-lazygit:
	@$(RM) -r $(LAZYGIT_HOME)

NIX_SOURCE ?= $(realpath ./dotfile/nix/nix.conf)
NIX_HOME ?= $(XDG_CONFIG_HOME)/nix
nix:
	@mkdir -p $(NIX_HOME)
	@$(S_LN) $(NIX_SOURCE) $(NIX_HOME)/nix.conf
rm-nix:
	@$(RM) -r $(NIX_HOME)

PARU_SOURCE ?= $(realpath ./dotfile/paru)
PARU_TARGET ?= $(XDG_CONFIG_HOME)/paru
paru:
ifneq (,$(wildcard $PARU_TARGET))
	@$(RM) -r $(PARU_TARGET)
endif
	@$(S_LN) $(PARU_SOURCE) $(PARU_TARGET)
rm-paru:
	@$(RM) $(PARU_TARGET)

push-notes:
	@$(GIT) subtree \
		--prefix notes \
		push \
		git@github.com:Avimitin/notes.git master

clean: $(addprefix rm-,$(DOTS))

.PHONY: all prepare clean $(DOTS) $(addprefix rm-,$(DOTS)) $(addprefix push-,$(SUBTREE_PRJ))
