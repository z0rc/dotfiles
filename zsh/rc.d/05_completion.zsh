# Completion tweaks
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/compcache"
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=$color[cyan]=$color[red]"
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion::complete:*' use-cache true

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

# Enable fzf completions
source "${DOTFILES}/tools/fzf/shell/completion.zsh"

# Init completions, but regenerate compdump only once a day.
# The globbing is a little complicated here:
# - '#q' is an explicit glob qualifier that makes globbing work within zsh's [[ ]] construct.
# - 'N' makes the glob pattern evaluate to nothing when it doesn't match (rather than throw a globbing error)
# - '.' matches "regular files"
# - 'mh+24' matches files (or directories or whatever) that are older than 24 hours.
autoload -Uz compinit
if [[ -n "${XDG_CACHE_HOME}/zsh/compdump"(#qN.mh+24) ]]; then
    compinit -d "${XDG_CACHE_HOME}/zsh/compdump"
else
    compinit -C -d "${XDG_CACHE_HOME}/zsh/compdump"
fi
