# Enable profiling, if requested via env var
# do `ZSH_ZPROF_ENABLE=1 exec zsh`
if [[ -v ZSH_ZPROF_ENABLE ]]; then
    zmodload zsh/zprof
fi

# Load modules for file operations
zmodload -F zsh/files b:zf_ln b:zf_mkdir b:zf_mv b:zf_rm
zmodload -F zsh/stat b:zstat
