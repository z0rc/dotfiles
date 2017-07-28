# Determine own path if ZDOTDIR isn't set
if [[ -z "${ZDOTDIR}" ]]; then
    local source="${(%):-%N}"
    local dir
    while [[ -h "${source}" ]]; do
        dir="$(cd -P "$(dirname "${source}")" && pwd)"
        source="$(readlink "${source}")"
        [[ ${source} != /* ]] && source="${dir}/${source}"
    done
    export ZDOTDIR="$(cd -P "$(dirname "${source}")" && pwd)"
fi
export DOTFILES="$(cd "${ZDOTDIR}/.." && pwd)"

# Source local env files
for envfile in "${ZDOTDIR}"/env.d/*; do
    source "${envfile}"
done
