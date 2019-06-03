# Compile heavy scripts to increase startup speed
{
    # completion cache
    zrecompile -pq "${XDG_CACHE_HOME}/zsh/compdump"

    # plugins and themes, only regular files (skip symlinks)
    local plugin_file
    for plugin_file in ${ZDOTDIR}/plugins/**/*.zsh{-theme,}(#q.); do
        zrecompile -pq "${plugin_file}"
    done
} &!

# Update tldr pages
{
    if [[ -n "${XDG_DATA_HOME}/tldr"(#qN/mh+20) ]]; then
        tldr -u < /dev/null &> /dev/null
    fi
} &!
