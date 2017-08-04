# Initialize colors
autoload -U colors && colors

# URL magic
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# Bracketed paste magic
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
