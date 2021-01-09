# Wrapper to set skin depending on terminal and effective permissions
if (( ${+commands[mc]} )); then
    mc () {
        if [[ -v MC_SID ]]; then
            print "Midnight Commander is already running, press Ctrl+O to return to it"
            return
        fi

        if [[ "${TERM}" = "linux" && "${EUID}" -ne 0 ]]; then
            export MC_SKIN=modarcon16-defbg
        elif [[ "${TERM}" = "linux" && "${EUID}" -eq 0 ]]; then
            export MC_SKIN=modarcon16root-defbg
        elif [[ "${TERM}" != "linux" && "${EUID}" -ne 0 ]]; then
            export MC_SKIN=modarin256-defbg
        elif [[ "${TERM}" != "linux" && "${EUID}" -eq 0 ]]; then
            export MC_SKIN=modarin256root-defbg
        fi

        local mc_pwd_file="${TMPDIR:-/tmp}/mc-${USER}/mc.pwd.$$"
        command mc -P "${mc_pwd_file}" "${@}"

        if [[ -r ${mc_pwd_file} ]]; then
            local mc_last_pwd=$(<"${mc_pwd_file}")
            if [[ -d ${mc_last_pwd} ]]; then
                cd "${mc_last_pwd}"
            fi
            rm -f "${mc_pwd_file}"
        fi
    }
fi
