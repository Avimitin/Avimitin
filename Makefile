DOTS := $(notdir $(wildcard dotfile/*))
S_LN := ln -svf
RM := rm -vi
GIT := git

HOME_DIR ?= $(HOME)
XDG_CONFIG_HOME ?= $(HOME_DIR)/.config

all: prepare $(DOTS)

prepare:
	@mkdir -p $(XDG_CONFIG_HOME)

# ---------------------------------------------

NVIM_SOURCE ?= $(realpath ./dotfile/nvim)
NVIM_TARGET ?= $(XDG_CONFIG_HOME)/nvim
nvim:
	@$(S_LN) $(NVIM_SOURCE) $(NVIM_TARGET)
rm-nvim:
	@$(RM) $(NVIM_TARGET)
push-nvim:
	@$(GIT) subtree push \
		--prefix dotfile/nvim \
		git@github.com:Avimitin/nvim \
		master

BASH_SOURCE ?= $(realpath ./dotfile/bash/.bashrc)
BASH_TARGET ?= $(HOME_DIR)/.bashrc
bash:
	@$(S_LN) $(BASH_SOURCE) $(BASH_TARGET)
rm-bash:
	@$(RM) $(BASH_TARGET)

FISH_SOURCE ?= $(realpath ./dotfile/fish)
FISH_TARGET ?= $(XDG_CONFIG_HOME)/fish
fish:
	@$(S_LN) $(FISH_SOURCE) $(FISH_TARGET)
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

clean: $(addprefix rm-$(DOTS))

.PHONY: all prepare clean $(DOTS) $(addprefix rm-,$(DOTS))
