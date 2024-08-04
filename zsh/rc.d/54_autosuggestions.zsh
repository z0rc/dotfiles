# Autosuggestions plugin
source "${ZDOTDIR}/plugins/autosuggestions/zsh-autosuggestions.zsh"

source "${ZDOTDIR}/plugins/autosuggestions-abbreviations-strategy/zsh-autosuggestions-abbreviations-strategy.zsh"

# Don't rebind widgets by autosuggestion, it's already sourced pretty late
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Clear suggestions after paste
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste)

# Enable additional suggestion strategies
ZSH_AUTOSUGGEST_STRATEGY=(abbreviations history completion)
