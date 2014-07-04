#!/bin/sh

git submodule update --init --recursive

cd ..

mkdir -p .config/git
mkdir -p .local/share/zsh

ln -s .dotfiles/zshrc .zshrc
ln -s .dotfiles/vimrc .vimrc
ln -s .dotfiles/vim .vim
ln -s .dotfiles/tmux.conf .tmux.conf
ln -s .dotfilse/gitconfig .config/git/config

