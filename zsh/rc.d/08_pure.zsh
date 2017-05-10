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

# Indicate various virtual environments
_pure_indicate_env() {
    if [[ -n "${VIRTUAL_ENV}" ]]; then
        preprompt+=("%F{green}venv:${VIRTUAL_ENV:t}%f")
    else
        local wrapper
        local wrappers=(pyenv rbenv nodenv luaenv)
        for wrapper in "${wrappers[@]}"; do
            local wrapper_version="${wrapper:u}_VERSION"
            local wrapper_root="${wrapper:u}_ROOT"
            if [[ -n "${(P)wrapper_version}" ]]; then
                preprompt+=("%F{green}${wrapper}-shell:${(P)wrapper_version}%f")
            elif [[ -n "${(P)wrapper_root}" ]]; then
                local wrapper_version_name=$(${wrapper} version-name)
                if [[ "${wrapper_version_name}" != "system" ]]; then
                    preprompt+=("%F{green}${wrapper}-local:${wrapper_version_name}%f")
                fi
            fi
        done
    fi
}

# Build pure prompt with additional indicators
prompt_pure_pieces=(
    _pure_indicate_filemanager
    ${prompt_pure_pieces:0:1}
    _pure_indicate_env
    ${prompt_pure_pieces:1}
)
