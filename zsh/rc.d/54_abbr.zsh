ABBR_USER_ABBREVIATIONS_FILE="${ZDOTDIR}/plugins/abbreviations-store"
source "${ZDOTDIR}/plugins/abbr/zsh-abbr.zsh"
export MANPATH=${ZDOTDIR}/plugins/abbr/man:$MANPATH

# monkey patch abbr for better autosuggestion compatibility
_abbr_widget_expand_and_space() {
  emulate -LR zsh
  _abbr_widget_expand
  'builtin' 'command' -v _zsh_autosuggest_fetch &>/dev/null && _zsh_autosuggest_fetch
  zle self-insert
}
