#!/bin/sh

git submodule update --init --recursive

cd ~

mkdir -p ~/.config/git

ln -s .dotfiles/zsh/zshenv ~/.zshenv
ln -s .dotfiles/tmux.conf ~/.tmux.conf
ln -s ../../.dotfiles/gitconfig ~/.config/git/config

