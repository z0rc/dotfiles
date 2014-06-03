#!/bin/sh

git config --global color.ui true
git submodule update --init --recursive
cd ..
ln -s .dotfiles/zshrc .zshrc
ln -s .dotfiles/vimrc .vimrc
ln -s .dotfiles/vim .vim
ln -s .dotfiles/tmux.conf .tmux.conf
