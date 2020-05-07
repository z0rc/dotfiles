# Completion tweaks
zstyle ':completion:*'                  matcher-list    'm:{a-zA-Z}={A-Za-z}' 'l:|=* r:|=*'
zstyle ':completion:*'                  completer       _complete
zstyle ':completion:*:*:-subscript-:*'  tag-order       indexes parameters
zstyle ':completion:*'                  squeeze-slashes true
zstyle ':completion:*'                  single-ignored  show
zstyle ':completion:*:(rm|kill|diff):*' ignore-line     other
zstyle ':completion:*:rm:*'             file-patterns   '*:all-files'
zstyle ':completion:*'                  list-colors     ${(s.:.)LS_COLORS}
zstyle ':completion::complete:*'        use-cache       true
zstyle ':completion::complete:*'        cache-path      "${XDG_CACHE_HOME}/zsh/compcache"

# Manual page completion
man_glob () {
    local a
    read -cA a
    if [[ $a[2] = [0-9]* ]]; then
        reply=( $^manpath/man$a[2]/$1*$2(N:t:r) )
    elif [[ $a[2] = -s ]]; then
        reply=( $^manpath/man$a[3]/$1*$2(N:t:r) )
    else
        reply=( $^manpath/man*/$1*$2(N:t:r) )
    fi
}
compctl -K man_glob man

# Additional completion rules
fpath+="${ZDOTDIR}/plugins/completions/src"

# Enable git-extras completions
source "${DOTFILES}/tools/git-extras/etc/git-extras-completion.zsh"

# Make sure complist is loaded
zmodload zsh/complist

# Init completions, but regenerate compdump only once a day.
# The globbing is a little complicated here:
# - '#q' is an explicit glob qualifier that makes globbing work within zsh's [[ ]] construct.
# - 'N' makes the glob pattern evaluate to nothing when it doesn't match (rather than throw a globbing error)
# - '.' matches "regular files"
# - 'mh+20' matches files (or directories or whatever) that are older than 20 hours.
autoload -Uz compinit
if [[ -n "${XDG_CACHE_HOME}/zsh/compdump"(#qN.mh+20) ]]; then
    compinit -i -d "${XDG_CACHE_HOME}/zsh/compdump"
else
    compinit -i -C -d "${XDG_CACHE_HOME}/zsh/compdump"
fi

# Properly enable z completion
compdef _zshz z=zshz
