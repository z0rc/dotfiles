# clear screen, move cursor to the bottom
autoload -Uz clear-screen-soft-bottom
clear-screen-soft-bottom

# powerlevel10k instant promt stanza
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
