# Add custom functions and completions
fpath=($ZDOTDIR/fpath $fpath)

# Ensure we have local paths enabled
path=(/usr/local/{bin,sbin}(N-/) $path)

if [[ $OSTYPE = darwin* ]]; then
    # Check whether homebrew available under new path
    if (( ! ${+commands[brew]} )) && [[ -x /opt/homebrew/bin/brew ]]; then
        path=(/opt/homebrew/bin $path)
    fi

    if (( ${+commands[brew]} )); then
        # Same result as `brew shellenv`, without forking brew and path_helper
        export HOMEBREW_PREFIX=${commands[brew]:h:h}
        export HOMEBREW_CELLAR=$HOMEBREW_PREFIX/Cellar
        export HOMEBREW_REPOSITORY=$HOMEBREW_PREFIX
        export INFOPATH=$HOMEBREW_PREFIX/share/info
        path=($HOMEBREW_PREFIX/{bin,sbin}(N-/) $path)
        fpath=($HOMEBREW_PREFIX/share/zsh/site-functions(N-/) $fpath)

        # Enable gnu version of utilities on macOS, if installed
        for gnuutil in coreutils gnu-sed gnu-tar grep gpatch; do
            if [[ -d $HOMEBREW_PREFIX/opt/$gnuutil/libexec/gnubin ]]; then
                path=($HOMEBREW_PREFIX/opt/$gnuutil/libexec/gnubin $path)
            fi
            if [[ -d $HOMEBREW_PREFIX/opt/$gnuutil/libexec/gnuman ]]; then
                MANPATH=$HOMEBREW_PREFIX/opt/$gnuutil/libexec/gnuman:$MANPATH
            fi
        done
        unset gnuutil
        # Prefer curl installed via brew
        if [[ -d $HOMEBREW_PREFIX/opt/curl/bin ]]; then
            path=($HOMEBREW_PREFIX/opt/curl/bin $path)
        fi
    fi
fi

# Enable local binaries and man pages
path=($HOME/.local/bin(N-/) $path)
MANPATH=$XDG_DATA_HOME/man:$MANPATH

# Add go binaries to paths
path=($GOPATH/bin(N-/) $path)

# Force path arrays to have unique values only
typeset -U path cdpath fpath manpath
