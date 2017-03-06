# Autosuggestions plugin
source "$ZSHDIR/plugins/autosuggestions/zsh-autosuggestions.zsh"
# Compatability with bracketed-paste-magic
function z-asug-d { zle autosuggest-disable; }
function z-asug-e { zle autosuggest-enable; }
zstyle :bracketed-paste-magic paste-init z-asug-d
zstyle :bracketed-paste-magic paste-finish z-asug-e
