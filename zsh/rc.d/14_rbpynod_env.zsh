# Don't indicate virtualenv in pyenv, indication is done in pure
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# Lazy init wrapper on first call
wrappers=(pyenv rbenv nodenv)
for wrapper in "${wrappers[@]}"; do
    eval "$wrapper() {
        unset -f $wrapper
        export "${wrapper:u}_ROOT"="\$XDG_DATA_HOME/$wrapper"
        PATH="\$DOTFILES/$wrapper/$wrapper/bin:\$PATH"
        eval \"\$(command $wrapper init -)\"
        $wrapper \$@
    }"
done
unset wrappers wrapper
