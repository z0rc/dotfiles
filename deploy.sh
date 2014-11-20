#!/bin/sh

git submodule update --init --recursive

cd mongo-hacker
make mongo_hacker.js

cd ~

mkdir -p ~/.config/{git,mc}
mkdir -p ~/.cache
mkdir -p ~/.local/share

ln -sf .dotfiles/zsh/.zshenv ~/.zshenv
touch .dotfiles/zsh/.zshenv.local
ln -sf ../../.dotfiles/gitconfig ~/.config/git/config
ln -sf ../../.dotfiles/mc.ini ~/.config/mc/ini

