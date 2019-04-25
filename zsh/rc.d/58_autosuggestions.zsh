# Enable experimental async autosuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=1
# Don't rebind widgets by autosuggestion, it's already sourced pretty late
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
# Enable experimental completion suggestions, if `history` returns nothing
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Compatability with bracketed paste magic
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
}
pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste)

# Autosuggestions plugin
source "${ZDOTDIR}/plugins/autosuggestions/zsh-autosuggestions.zsh"
