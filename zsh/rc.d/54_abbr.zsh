ABBR_USER_ABBREVIATIONS_FILE="${ZDOTDIR}/plugins/abbreviations-store"
source "${ZDOTDIR}/plugins/abbr/zsh-abbr.zsh"
export MANPATH=${ZDOTDIR}/plugins/abbr/man:$MANPATH

# Ignore suggestions for abbreviations
ZSH_AUTOSUGGEST_HISTORY_IGNORE=${(j:|:)${(Qk)ABBR_REGULAR_USER_ABBREVIATIONS}}
ZSH_AUTOSUGGEST_COMPLETION_IGNORE=${ZSH_AUTOSUGGEST_HISTORY_IGNORE}
