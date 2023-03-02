# Don't rebind widgets by autosuggestion, it's already sourced pretty late
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
# Enable experimental completion suggestions, if `history` returns nothing
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Autosuggestions plugin
source "${ZDOTDIR}/plugins/autosuggestions/zsh-autosuggestions.zsh"

# Clear suggestions after paste
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste)
