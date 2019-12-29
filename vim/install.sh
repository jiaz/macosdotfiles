#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

mkdir ~/.vim/colors

ln -s $DIR/vimrc ~/.vimrc
ln -s $DIR/colors/tomorrow-night-bright.vim ~/.vim/colors/tomorrow-night-bright.vim

vim +PluginInstall +qall
