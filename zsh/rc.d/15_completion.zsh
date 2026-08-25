# Completion tweaks
zstyle ':completion:*'                          list-colors         ${(s.:.)LS_COLORS}
zstyle ':completion:*'                          list-dirs-first     true
zstyle ':completion:*'                          verbose             true
zstyle ':completion:*'                          menu                no
zstyle ':completion:*'                          matcher-list        'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*'                          use-cache           true
zstyle ':completion:*'                          cache-path          $XDG_CACHE_HOME/zsh/compcache
zstyle ':completion:*'                          squeeze-slashes     true
zstyle ':completion:*:descriptions'             format              [%d]
zstyle ':completion:*:manuals'                  separate-sections   true
zstyle ':completion:*'                          completer           _complete _match _approximate
zstyle ':completion:*:approximate:*'            max-errors          2 numeric
zstyle ':completion:*:(approximate|correct)*:*' original            true
zstyle ':completion:*:corrections'              format              '[%d (errors: %e)]'

# Ignore some non-useful completions
zstyle ':completion:*:(rm|kill|diff):*'                    ignore-line      other
zstyle ':completion:*:functions'                           ignored-patterns '_*'
zstyle ':completion:*:git-*:argument-rest:heads'           ignored-patterns '(FETCH_|ORIG_|*/|)HEAD'
zstyle ':completion:*:*:(vi|vim|nvim|nv|bat|cat|less):*:*' ignored-patterns '*.zwc'
zstyle ':completion:*:parameters'                          ignored-patterns \
    '_(p9k|_p9k|POWERLEVEL9K|gitstatus|GITSTATUS|zsh_highlight|ZSH_HIGHLIGHT|zsh_autosuggest|ZSH_AUTOSUGGEST|abbr|ABBR|ftb|FTB)*'

# Enable cached completions, if present
if [[ -d $XDG_CACHE_HOME/zsh/fpath ]]; then
    fpath=($XDG_CACHE_HOME/zsh/fpath $fpath)
fi

# Additional completions
fpath=($ZDOTDIR/plugins/completions/src $ZDOTDIR/plugins/git-completion/src $fpath)

# Enable git-extras completions
source $DOTFILES/tools/git-extras/etc/git-extras-completion.zsh

# Make sure complist is loaded
zmodload zsh/complist

_compdump=$XDG_CACHE_HOME/zsh/compdump-$ZSH_VERSION
autoload -Uz compinit
# Regenerate compdump when completions actually change 
# fpath directory's mtime changes whenever a completion file is added, removed or renamed
# This is what signature records among other things
() {
    local -a mtimes dirs=(${^fpath}(-/N))
    (( $#dirs )) && zstat -A mtimes +mtime -- $dirs
    local -a sig=($ZSH_VERSION $ZSH_PATCHLEVEL $dirs $mtimes)
    local want=${(j.:.)sig} have

    if [[ -r $_compdump && -r $_compdump.sig ]] &&
       IFS= read -r have <$_compdump.sig && [[ $have == $want ]]; then
        compinit -C -d $_compdump
    else
        compinit -i -d $_compdump
        print -r -- $want >$_compdump.sig
        {
            autoload -Uz zrecompile
            zrecompile -pq $_compdump
        } &!
    fi
}
unset _compdump

# Enable bash completions too
autoload -Uz bashcompinit
bashcompinit
