# Taken from prezto, thanks for this
{
    # Compile the completion dump to increase startup speed
    zcompdump="${XDG_CACHE_HOME}/zsh/compdump"
    if [[ -s "${zcompdump}" && (! -s "${zcompdump}.zwc" || "${zcompdump}" -nt "${zcompdump}.zwc") ]]; then
        zcompile "${zcompdump}"
    fi
} &!
