# Add custom functions and completions
fpath=($ZDOTDIR/fpath $fpath)

# Ensure we have local paths enabled
path=(/usr/local/bin /usr/local/sbin $path)

if [[ $OSTYPE = darwin* ]]; then
    # Check whether homebrew available under new path
    if (( ! ${+commands[brew]} )) && [[ -x /opt/homebrew/bin/brew ]]; then
        path=(/opt/homebrew/bin $path)
    fi

    if (( ${+commands[brew]} )); then
        autoload -z evalcache
        evalcache brew shellenv

        # Enable gnu version of utilities on macOS, if installed
        for gnuutil in coreutils gnu-sed gnu-tar grep; do
            if [[ -d $HOMEBREW_PREFIX/opt/$gnuutil/libexec/gnubin ]]; then
                path=($HOMEBREW_PREFIX/opt/$gnuutil/libexec/gnubin $path)
            fi
            if [[ -d $HOMEBREW_PREFIX/opt/$gnuutil/libexec/gnuman ]]; then
                MANPATH=$HOMEBREW_PREFIX/opt/$gnuutil/libexec/gnuman:$MANPATH
            fi
        done
        # Prefer curl installed via brew
        if [[ -d $HOMEBREW_PREFIX/opt/curl/bin ]]; then
            path=($HOMEBREW_PREFIX/opt/curl/bin $path)
        fi
    fi
fi

# Enable local binaries and man pages
path=($HOME/.local/bin $path)
MANPATH=$XDG_DATA_HOME/man:$MANPATH

# Add go binaries to paths
path=($GOPATH/bin $path)
