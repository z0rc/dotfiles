# Compile the completion dump to increase startup speed
{
    zcompdump="${XDG_CACHE_HOME}/zsh/compdump"
    if [[ -s "${zcompdump}" && (! -s "${zcompdump}.zwc" || "${zcompdump}" -nt "${zcompdump}.zwc") ]]; then
        zcompile "${zcompdump}"
    fi
} &!

# Generate vim tags
{
    if (( ${+commands[vim]} )); then
        nohup vim -c 'silent! helptags ALL | q' &> /dev/null
    fi
} &!
