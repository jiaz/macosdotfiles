SHELL = /bin/bash
DOTFILES_DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
PATH := $(DOTFILES_DIR)/bin:$(PATH)
VUNDLE_PATH := $(HOME)/.vim/bundle/Vundle.vim
export XDG_CONFIG_HOME := $(HOME)/.config

.PHONY: test

all: sudo core-macos packages link config

sudo:
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

core-macos: brew fish git

stow-macos: brew
	is-executable stow || brew install stow

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install | ruby

fish: FISH=/usr/local/bin/fish
fish: SHELLS=/etc/shells
fish: brew
	if ! grep -q $(FISH) $(SHELLS); then brew install fish && echo $(FISH) | sudo tee -a $(SHELLS) && chsh -s $(FISH); fi

git: brew
	brew install git git-extras

packages: brew-packages

brew-packages: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Brewfile

link: stow-macos
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then mv -v $(HOME)/$$FILE{,.bak}; fi; done
	mkdir -p $(XDG_CONFIG_HOME)
	stow -t $(HOME) runcom
	stow -t $(XDG_CONFIG_HOME) config

unlink: stow-macos
	stow --delete -t $(HOME) runcom
	stow --delete -t $(XDG_CONFIG_HOME) config
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE.bak ]; then mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

config: vim

vim: link
	[ ! -d $(VUNDLE_PATH) ] && git clone https://github.com/VundleVim/Vundle.vim.git $(VUNDLE_PATH)
	pushd $(VUNDLE_PATH) && git pull && popd
	vim +PluginInstall +qall

