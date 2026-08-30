# Autopairs plugin

# If cache is newer that 20 hours, then use it
if [[ -n $XDG_CACHE_HOME/zsh/autopair-widgets.zsh(#qN.mh-20) ]]; then
    source $XDG_CACHE_HOME/zsh/autopair-widgets.zsh 
fi

source $ZDOTDIR/plugins/autopair/autopair.zsh

# If cache is older that 20 hours, then update it
{
    if [[ -n $XDG_CACHE_HOME/zsh/autopair-widgets.zsh(#qN.mh+20) ]]; then
        print -r -- "AUTOPAIR_SPC_WIDGET=$AUTOPAIR_SPC_WIDGET
AUTOPAIR_BKSPC_WIDGET=$AUTOPAIR_BKSPC_WIDGET
AUTOPAIR_DELWORD_WIDGET=$AUTOPAIR_DELWORD_WIDGET" > $XDG_CACHE_HOME/zsh/autopair-widgets.zsh
    fi
} &!
