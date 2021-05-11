# Don't indicate virtualenv in pyenv, indication is done in pure
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Lazy init wrapper on first call
() {
    local wrapper
    local wrappers=(goenv jenv luaenv nodenv phpenv plenv pyenv rbenv)
    for wrapper in "${wrappers[@]}"; do
        eval "${wrapper} () {
            unset -f ${wrapper}
            export ${wrapper:u}_ROOT=\"\${XDG_DATA_HOME}/${wrapper}\"
            PATH=\"\${DOTFILES}/env-wrappers/${wrapper}/${wrapper}/bin:\${PATH}\"
            evalcache ${wrapper} init -
            ${wrapper} \${@}
            if [[ $wrapper == \"pyenv\" ]]; then
                evalcache ${wrapper} init --path
            fi
        }"
    done
}
