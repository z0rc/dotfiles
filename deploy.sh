#!/bin/zsh

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

cd $SCRIPT_DIR

git submodule update --init --recursive

ln -s ../../deploy.sh .git/hooks/post-merge

cd mongo-hacker
make mongo_hacker.js

cd $SCRIPT_DIR/..

mkdir -p .config/{git,mc}
mkdir -p .cache
mkdir -p .local/share

ln -sf .dotfiles/zsh/.zshenv .zshenv
touch .dotfiles/zsh/.zshenv.local
ln -sf ../../.dotfiles/gitconfig .config/git/config
ln -sf ../../.dotfiles/mc.ini .config/mc/ini

