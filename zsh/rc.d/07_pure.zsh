# Use default zsh prompt symbol
PURE_PROMPT_SYMBOL="%#"

# Enable pure prompt
source "$ZSHDIR/plugins/async/async.zsh"
source "$ZSHDIR/plugins/pure/pure.zsh"

# Indicate that shell is running under Midnight Commander or ranger
if [[ -n "$MC_SID" ]]; then
    _pure_indicate_filemanager() {
        preprompt+=("[mc]")
    }
elif [[ -n "$RANGER_LEVEL" ]]; then
    _pure_indicate_filemanager() {
        preprompt+=("[ranger]")
    }
else
    _pure_indicate_filemanager() {}
fi

# Indicate virtualenv environment
_pure_indicate_virtualenv() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        preprompt+=("%F{green}venv:${VIRTUAL_ENV:t}%f")
    fi
}

# Build pure prompt with additional indicators
prompt_pure_pieces=(
    _pure_indicate_filemanager
    ${prompt_pure_pieces:0:1}
    _pure_indicate_virtualenv
    ${prompt_pure_pieces:1}
)
