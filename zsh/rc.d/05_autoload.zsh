# Initialize colors
autoload -Uz colors
colors

# Fullscreen command line edit
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Ctrl+W stops on path delimiters
autoload -Uz select-word-style
select-word-style bash

# zrecompile to compile some plugins
autoload -Uz zrecompile

# Enable run-help module
(( $+aliases[run-help] )) && unalias run-help
autoload -Uz run-help
alias help=run-help

# enable url-quote-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# enable bracketed paste
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# compatability with zsh-asug
pasteinit() {
    OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
    zle -N self-insert url-quote-magic
}

pastefinish() {
    zle -N self-insert $OLD_SELF_INSERT
}

zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
