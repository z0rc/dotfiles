# clear screen, move cursor to the bottom
# but don't do this under ssh or sudo sessions, as prompt already at the bottom
if ! [[ -v SSH_TTY || -v SUDO_USER ]]; then
    autoload -Uz clear-screen-soft-bottom
    clear-screen-soft-bottom
fi

# powerlevel10k instant prompt stanza
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
