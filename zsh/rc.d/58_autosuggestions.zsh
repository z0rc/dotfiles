# Enable experimental async autosuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=1
# Don't rebind widgets by autosuggestion, it's already sourced pretty late
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
# Enable experimental completion suggestions, if `history` returns nothing
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Autosuggestions plugin
source "${ZDOTDIR}/plugins/autosuggestions/zsh-autosuggestions.zsh"

ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(fzf-tab-complete)
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(z4h-fzf-history)
