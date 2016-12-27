# Don't indicate virtualenv in pyenv, indication is done in pure
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# Init async callbacks
env_init_callback() {
    eval "$3" # $3 is stdout
    typeset -U path # sanitize $PATH after init
}

async_init
async_start_worker env_init_worker -n
async_register_callback env_init_worker env_init_callback

wrappers=(pyenv rbenv nodenv)
for wrapper in "${wrappers[@]}"; do
    export "${wrapper:u}_ROOT"="$XDG_DATA_HOME/$wrapper"
    PATH="$DOTFILES/$wrapper/$wrapper/bin:$PATH"

    async_job env_init_worker $wrapper init -
done
unset wrappers wrapper
