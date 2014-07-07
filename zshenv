ZDOTDIR="$HOME/.config/zsh"

skip_global_compinit=1

# Exports
EDITOR=vim
VISUAL=$EDITOR
export VISUAL EDITOR
export PAGER=less
export GREP_OPTIONS="--color=auto --binary-files=without-match --devices=skip"
# Trick to force other applications to use vim with custom .vimrc path
export PATH=~/.dotfiles/bin:$PATH

source "$ZDOTDIR"/.zshenv

