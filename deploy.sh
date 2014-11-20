#!/bin/sh

git submodule update --init --recursive

cd mongo-hacker
make mongo_hacker.js

cd ~

mkdir -p ~/.config/git
mkdir -p ~/.cache
mkdir -p ~/.local/share

ln -s .dotfiles/zsh/.zshenv ~/.zshenv
touch .dotfiles/zsh/.zshenv.local
ln -s ../../.dotfiles/gitconfig ~/.config/git/config

