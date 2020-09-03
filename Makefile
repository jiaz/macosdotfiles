SHELL = /bin/bash
DOTFILES_DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
PATH := $(DOTFILES_DIR)/bin:$(PATH)
VUNDLE_PATH := $(HOME)/.vim/bundle/Vundle.vim
export XDG_CONFIG_HOME := $(HOME)/.config

.PHONY: test

all: sudo core-macos packages vim zshrc

sudo:
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

macosdefaults:
	sh $(DOTFILES_DIR)/macos/defaults.sh

core-macos: brew git macosdefaults

stow-macos: brew
	is-executable stow || brew install stow

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install | ruby

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

vimrc:
	if [ -f $(HOME)/.vimrc ]; then mv -v $(HOME)/.vimrc $(HOME)/.vimrc.bak; fi
	ln -s $(DOTFILES_DIR)runcom/.vimrc $(HOME)/.vimrc

vimplug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim: vimrc vimplug
	vim +PlugInstall +qall

zshrc:
	if [ -f $(HOME)/.zshrc ]; then mv -v $(HOME)/.zshrc $(HOME)/.zshrc.bak; fi
	ln -s $(DOTFILES_DIR)runcom/.zshrc $(HOME)/.zshrc

zshconfig:
	curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $(HOME)/.oh-my-zsh/custom/themes/powerlevel10k

