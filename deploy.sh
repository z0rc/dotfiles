#!/bin/sh

git submodule update --init --recursive

cd ~

mkdir -p ~/.config/git
mkdir -p ~/.config/zsh
mkdir -p ~/.local/share/zsh
mkdir -p ~/.cache/zsh

ln -s ../../.dotfiles/zshrc ~/.config/zsh/.zshrc
ln -s .dotfiles/zshenv ~/.zshenv
ln -s .dotfiles/vimrc ~/.vimrc
ln -s .dotfiles/vim ~/.vim
ln -s .dotfiles/tmux.conf ~/.tmux.conf
ln -s ../../.dotfiles/gitconfig ~/.config/git/config

