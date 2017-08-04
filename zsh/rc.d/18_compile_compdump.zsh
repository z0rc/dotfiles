# Asynchonously compile compdump
_compile_compdump () {
    zcompdump="${XDG_CACHE_HOME}/zsh/compdump"
    if [[ -s "${zcompdump}" && (! -s "${zcompdump}.zwc" || "${zcompdump}" -nt "${zcompdump}.zwc") ]]; then
        zcompile "${zcompdump}"
    fi
}

_finish_compiler () {
    async_stop_worker compiler
    unfunction _finish_compiler _compile_compdump
}

async_init
async_start_worker compiler -u -n
async_register_callback compiler _finish_compiler
async_job compiler _compile_compdump
