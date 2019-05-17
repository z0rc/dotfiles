# Compile heavy scripts to increase startup speed
{
    setopt LOCAL_OPTIONS EXTENDED_GLOB
    local plugin_file

    # completion cache
    zrecompile -pq "${XDG_CACHE_HOME}/zsh/compdump"

    for plugin_file in ${ZDOTDIR}/plugins/*/*.zsh; do
        zrecompile -pq "${plugin_file}"
    done
} &!

# Update tldr pages
{
    if [[ -n "${XDG_DATA_HOME}/tldr"(#qN/mh+20) ]]; then
        tldr -u < /dev/null &> /dev/null
    fi
} &!
