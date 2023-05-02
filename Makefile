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

.PHONY: all prepare $(DOTS) $(addprefix rm-,$(DOTS))
