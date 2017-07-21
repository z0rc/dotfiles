# Set MC skin whether we're running under root or not
# Also set skin depending under which terminal we're running
if [[ "${TERM}" = "linux" && "${EUID}" -ne 0 ]]; then
    export MC_SKIN=modarcon16-defbg
    sudo() { if [[ "${1}" = "mc" ]]; then command sudo MC_SKIN=modarcon16root-defbg "${@}"; else command sudo "${@}"; fi; }
elif [[ "${TERM}" = "linux" && "${EUID}" -eq 0 ]]; then
    export MC_SKIN=modarcon16root-defbg
elif [[ "${TERM}" != "linux" && "${EUID}" -ne 0 ]]; then
    export MC_SKIN=modarin256-defbg
    sudo() { if [[ "${1}" = "mc" ]]; then command sudo MC_SKIN=modarin256root-defbg "${@}"; else command sudo "${@}"; fi; }
elif [[ "${TERM}" != "linux" && "${EUID}" -eq 0 ]]; then
    export MC_SKIN=modarin256root-defbg
fi
