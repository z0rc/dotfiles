# Use default zsh prompt symbol
PURE_PROMPT_SYMBOL="%#"

# Enable pure prompt
source "$ZSHDIR/plugins/pure/pure.zsh"

# Indicate that shell is running under Midnight Commander or ranger
if [[ -n "$MC_SID" ]]; then
    _pure_indicate_filemanager() {
        preprompt+=("%F{white}[mc]%f")
    }
elif [[ -n "$RANGER_LEVEL" ]]; then
    _pure_indicate_filemanager() {
        preprompt+=("%F{white}[ranger]%f")
    }
else
    _pure_indicate_filemanager() {}
fi

# Indicate virtualenv environment
_pure_indicate_env() {
    if [[ -n "${VIRTUAL_ENV}" ]]; then
        preprompt+=("%F{green}venv:${VIRTUAL_ENV:t}%f")
    elif [[ -n "$RBENV_VERSION" ]]; then
        preprompt+=("%F{green}rbenv:${RBENV_VERSION}%f")
    fi
}

# Build pure prompt with additional indicators
prompt_pure_pieces=(
    _pure_indicate_filemanager
    ${prompt_pure_pieces:0:1}
    _pure_indicate_env
    ${prompt_pure_pieces:1}
)
