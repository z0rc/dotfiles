# Asynchonously compile compdump
_compile_compdump () {
    zcompdump="${XDG_CACHE_HOME}/zsh/compdump"
    if [[ -s "${zcompdump}" && (! -s "${zcompdump}.zwc" || "${zcompdump}" -nt "${zcompdump}.zwc") ]]; then
        zcompile "${zcompdump}"
    fi
}

async_start_worker compiler -u -n
async_job compiler _compile_compdump
unfunction _compile_compdump
