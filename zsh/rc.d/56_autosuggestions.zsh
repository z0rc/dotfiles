# Autosuggestions plugin
source "${ZDOTDIR}/plugins/autosuggestions/zsh-autosuggestions.zsh"
# Compatability with bracketed-paste-magic
function z-asug-d { zle autosuggest-disable; }
function z-asug-e { zle autosuggest-enable; }
zstyle :bracketed-paste-magic paste-init z-asug-d
zstyle :bracketed-paste-magic paste-finish z-asug-e
# Enable experimental async autosuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=1
# Temporary fix for missing directory suggestions
# https://github.com/zsh-users/zsh-autosuggestions/issues/379
ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(expand-or-complete)
