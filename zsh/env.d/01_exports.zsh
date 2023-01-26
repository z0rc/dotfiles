# Prefered editor and pager
export VISUAL=vim
export EDITOR=vim
export VIMINIT='let $MYVIMRC="$DOTFILES/vim/vimrc" | source $MYVIMRC'
export PAGER=less
export LESS="--RAW-CONTROL-CHARS --ignore-case --hilite-unread --LONG-PROMPT --window=-4 --tabs=4"
export READNULLCMD=${PAGER}

# make sure gpg knows about current TTY
export GPG_TTY=${TTY}

# XDG basedir spec compliance
if [[ ! -v XDG_CONFIG_HOME ]]; then
    export XDG_CONFIG_HOME"=${HOME}/.config"
fi
if [[ ! -v XDG_CACHE_HOME ]]; then
    export XDG_CACHE_HOME="${HOME}/.cache"
fi
if [[ ! -v XDG_DATA_HOME ]]; then
    export XDG_DATA_HOME="${HOME}/.local/share"
fi
if [[ ! -v XDG_STATE_HOME ]]; then
    export XDG_STATE_HOME="${HOME}/.local/state"
fi
if [[ ! -v XDG_RUNTIME_DIR ]]; then
    export XDG_RUNTIME_DIR="${TMPDIR:-/tmp}/runtime-${USER}"
fi

# best effort to make tools compliant to XDG basedir spec
export GNUPGHOME="${XDG_CONFIG_HOME}/gnupg"
export LESSHISTFILE="${XDG_DATA_HOME}/lesshst"
export MYSQL_HISTFILE="${XDG_DATA_HOME}/mysql_history"
export REDISCLI_HISTFILE="${XDG_DATA_HOME}/rediscli_history"
export BUNDLE_USER_CONFIG="${XDG_CONFIG_HOME}/bundle"
export BUNDLE_USER_CACHE="${XDG_CACHE_HOME}/bundle"
export BUNDLE_USER_PLUGIN="${XDG_DATA_HOME}/bundle"
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export WINEPREFIX="${XDG_DATA_HOME}/wine"
export MACHINE_STORAGE_PATH="${XDG_DATA_HOME}/docker/machine"
export MINIKUBE_HOME="${XDG_DATA_HOME}/minikube"
export VAGRANT_HOME="${XDG_DATA_HOME}/vagrant"
export HTOPRC="${XDG_CONFIG_HOME}/htop/htoprc"
export PACKER_CONFIG="${XDG_CONFIG_HOME}/packer"
export PACKER_CACHE_DIR="${XDG_CACHE_HOME}/packer"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/config"
export NPM_CONFIG_CACHE="${XDG_CACHE_HOME}/npm"
export HTTPIE_CONFIG_DIR="${XDG_CONFIG_HOME}/httpie"
export ANSIBLE_LOCAL_TEMP="${XDG_RUNTIME_DIR}/ansible/tmp"
export GOPATH="${XDG_DATA_HOME}/go"
export GEM_HOME="${XDG_DATA_HOME}/gem"
export GEM_SPEC_CACHE="${XDG_CACHE_HOME}/gem"
export GEMRC="${XDG_CONFIG_HOME}/gem/gemrc"
export TASKDATA="${XDG_DATA_HOME}/task"
export TASKRC="${XDG_CONFIG_HOME}/task/taskrc"
export PERL_CPANM_HOME="${XDG_CACHE_HOME}/cpanm"
export SOLARGRAPH_CACHE="${XDG_CACHE_HOME}/solargraph"
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc"

# Ensure we have local paths enabled
path=(/usr/local/bin /usr/local/sbin ${path})

if [[ "${OSTYPE}" = darwin* ]]; then
    # Enable gnu version of utilities on macOS, if installed
    for gnuutil in coreutils gnu-sed gnu-tar grep; do
        if [[ -d /usr/local/opt/${gnuutil}/libexec/gnubin ]]; then
            path=(/usr/local/opt/${gnuutil}/libexec/gnubin ${path})
        fi
        if [[ -d /usr/local/opt/${gnuutil}/libexec/gnuman ]]; then
            MANPATH="/usr/local/opt/${gnuutil}/libexec/gnuman:${MANPATH}"
        fi
    done
    # Prefer curl installed via brew
    if [[ -d /usr/local/opt/curl/bin ]]; then
        path=(/usr/local/opt/curl/bin ${path})
    fi
fi

# Enable local binaries and man pages
path=(${HOME}/.local/bin ${path})
MANPATH="${XDG_DATA_HOME}/man:${MANPATH}"

# Add go binaries to paths
path=(${GOPATH}/bin ${path})

# Add custom functions and completions
fpath=(${ZDOTDIR}/fpath ${fpath})
