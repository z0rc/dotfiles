ZSH_CDR_DIR="${XDG_CACHE_HOME}/zsh/cdr"
source "${ZDOTDIR}/plugins/cdr/cdr.plugin.zsh"

# plugin sets this to 1000, which is too high
zstyle ':chpwd:*' recent-dirs-max 100
