# Enable experimental async autosuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=1
# Don't rebind widgets by autosuggestion, it's already sourced pretty late
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
# Enable experimental completion suggestions, if `history` returns nothing
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# Ignore suggestions for abbreviations
ZSH_AUTOSUGGEST_HISTORY_IGNORE=${(j:|:)${(Qk)ABBR_REGULAR_USER_ABBREVIATIONS}}
ZSH_AUTOSUGGEST_COMPLETION_IGNORE=${ZSH_AUTOSUGGEST_HISTORY_IGNORE}

# Autosuggestions plugin
source "${ZDOTDIR}/plugins/autosuggestions/zsh-autosuggestions.zsh"

# Clear suggestions after paste
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(
    bracketed-paste
)
