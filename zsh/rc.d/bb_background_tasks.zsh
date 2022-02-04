# Update tldr pages
{
    if [[ -n "${XDG_DATA_HOME}/tldr"(#qN/mh+20) ]]; then
        tldr -u < /dev/null &> /dev/null
    fi
} &!
