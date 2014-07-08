ZDOTDIR="$HOME/.dotfiles/zsh"

skip_global_compinit=1


# Exports
export VIMINIT='let $MYVIMRC="~/.dotfiles/vim/vimrc" | source $MYVIMRC'
EDITOR=vim
VISUAL=$EDITOR
export VISUAL EDITOR
export PAGER=less
export LESSHISTFILE=~/.local/share/lesshst
export MYSQL_HISTFILE=~/.local/share/mysql_history
export GREP_OPTIONS="--color=auto --binary-files=without-match --devices=skip"

alias tmux="tmux -f ~/.dotfiles/tmux.conf"

source "$ZDOTDIR"/.zshenv.local

