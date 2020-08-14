# Highlighting plugin
source "${ZDOTDIR}/plugins/syntax-highlighting/zsh-syntax-highlighting.zsh"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets regexp cursor)
# Highlight known abbrevations
typeset -A ZSH_HIGHLIGHT_REGEXP
ZSH_HIGHLIGHT_REGEXP+=('(^| )('${(j:|:)${(k)ABBR_REGULAR_USER_ABBREVIATIONS}}')($| )' 'fg=blue')
