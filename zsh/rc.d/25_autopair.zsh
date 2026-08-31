# Autopairs plugin

# Use cache of resolved widgets
local _autopair_cache=$XDG_CACHE_HOME/zsh/autopair-widgets.zsh
if [[ -n $_autopair_cache(#qN.mh-20) ]]; then
    source $_autopair_cache
fi

source $ZDOTDIR/plugins/autopair/autopair.zsh

# Cache missing or older than 20 hours, refresh it
if [[ -z $_autopair_cache(#qN.mh-20) ]]; then
    typeset -p AUTOPAIR_SPC_WIDGET AUTOPAIR_BKSPC_WIDGET AUTOPAIR_DELWORD_WIDGET > $_autopair_cache
fi
unset _autopair_cache
