# Highlighting plugin
source "${ZDOTDIR}/plugins/syntax-highlighting/zsh-syntax-highlighting.zsh"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
# Highlight known abbrevations
typeset -A ZSH_HIGHLIGHT_PATTERNS
for a in $(abbr l); do
    ZSH_HIGHLIGHT_PATTERNS+=($a 'fg=blue')
done
unset a
