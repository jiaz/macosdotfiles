#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Homebrew
brew install vim
brew install fzf
brew install fzy
brew install rbenv
brew install pyenv
brew install wget
brew install fish
# python build dependencies
brew install openssl readline sqlite3 xz zlib

ln -s $DIR/fish/config.fish ~/.config/fish/config.fish
ln -s $DIR/fish/fishfile ~/.config/fish/fishfile
