# XDG basedir spec compliance
if [[ ! -v XDG_CONFIG_HOME ]]; then
    export XDG_CONFIG_HOME=$HOME/.config
fi
if [[ ! -v XDG_CACHE_HOME ]]; then
    export XDG_CACHE_HOME=$HOME/.cache
fi
if [[ ! -v XDG_DATA_HOME ]]; then
    export XDG_DATA_HOME=$HOME/.local/share
fi
if [[ ! -v XDG_STATE_HOME ]]; then
    export XDG_STATE_HOME=$HOME/.local/state
fi
if [[ ! -v XDG_RUNTIME_DIR ]]; then
    export XDG_RUNTIME_DIR=${TMPDIR:-/tmp}/runtime-$USER
fi

# ensure that XDG_RUNTIME_DIR dir exists, as it can be under tmpfs
if [[ ! -d $XDG_RUNTIME_DIR ]]; then
    zf_mkdir -m 0700 -p $XDG_RUNTIME_DIR
fi
