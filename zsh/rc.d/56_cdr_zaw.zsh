# cdr plugin
ZSH_CDR_DIR="$XDG_CACHE_HOME/zsh"
source "$ZSHDIR/plugins/cdr/cdr.plugin.zsh"

# zaw plugin
source "$ZSHDIR/plugins/zaw/zaw.zsh"
bindkey '^R' zaw-history
