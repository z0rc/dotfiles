# Determine own path if ZDOTDIR isn't set or home symlink exists
if [[ -z "$ZDOTDIR" || -L "${HOME}/.zshenv" ]]; then
    local homezshenv="${HOME}/.zshenv"
    export ZDOTDIR="${homezshenv:A:h}"
fi
export DOTFILES="$(cd "${ZDOTDIR}/.." && pwd)"

# Source local env files
for envfile in "${ZDOTDIR}"/env.d/*; do
    source "${envfile}"
done
