# Wrapper to set skip depending on terminal and effective permissions
mc () {
    if [[ "${TERM}" = "linux" && "${EUID}" -ne 0 ]]; then
        export MC_SKIN=modarcon16-defbg
    elif [[ "${TERM}" = "linux" && "${EUID}" -eq 0 ]]; then
        export MC_SKIN=modarcon16root-defbg
    elif [[ "${TERM}" != "linux" && "${EUID}" -ne 0 ]]; then
        export MC_SKIN=modarin256-defbg
    elif [[ "${TERM}" != "linux" && "${EUID}" -eq 0 ]]; then
        export MC_SKIN=modarin256root-defbg
    fi
    command mc "${@}"
}
