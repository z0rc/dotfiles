# Enable experimental async autosuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=1
# Autosuggestions plugin
source "${ZDOTDIR}/plugins/autosuggestions/zsh-autosuggestions.zsh"

# Remove zsh-asug hook after 2 prompts
typeset -gi _UNHOOK_ZSH_AUTOSUGGEST_COUNTER=0

function _unhook_autosuggest() {
  emulate -L zsh
  if (( ++_UNHOOK_ZSH_AUTOSUGGEST_COUNTER == 2 )); then
    add-zsh-hook -D precmd _zsh_autosuggest_start
    add-zsh-hook -D precmd _unhook_autosuggest
    unset _UNHOOK_ZSH_AUTOSUGGEST_COUNTER
    unfunction _unhook_autosuggest
  fi
}

add-zsh-hook precmd _unhook_autosuggest
