# Initialize colors
autoload -U colors && colors

# Fullscreen command line edit
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Ctrl+W stops on path delimiters
autoload -U select-word-style
select-word-style bash

# zrecompile to compile some plugins
autoload -U zrecompile

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
