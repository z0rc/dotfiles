# Determine own path if ZDOTDIR isn't set or doesn't match current dir
if [[ -z "${ZDOTDIR}" || "${ZDOTDIR}" != "${(%):-%d}" ]]; then
    # magic to resolve symlinks into real path
    local source="${(%):-%N}"
    local dir
    while [[ -h "${source}" ]]; do
        dir="$(cd -P "$(dirname "${source}")" && pwd)"
        source="$(readlink "${source}")"
        [[ ${source} != /* ]] && source="${dir}/${source}"
    done
    export ZDOTDIR="$(cd -P "$(dirname "${source}")" && pwd)"
    unset source dir
fi
export DOTFILES="$(cd "${ZDOTDIR}/.." && pwd)"

# Source local env files
for envfile in "${ZDOTDIR}"/env.d/*; do
    source "${envfile}"
done
