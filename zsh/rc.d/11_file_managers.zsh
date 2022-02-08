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

        local mc_pwd_file="${XDG_RUNTIME_DIR}/mc.pwd.$$"
        command mc -P "${mc_pwd_file}" "${@}"

        if [[ -r ${mc_pwd_file} ]]; then
            local mc_last_pwd=$(<"${mc_pwd_file}")
            if [[ -d ${mc_last_pwd} ]] && [[ ${mc_last_file} != ${PWD} ]]; then
                cd "${mc_last_pwd}"
            fi
            zf_rm -f "${mc_pwd_file}"
        fi
    }
fi

if (( ${+commands[ranger]} )); then
    ranger () {
        if [[ -v RANGER_LEVEL ]]; then
            exit
        fi

        local ranger_pwd_file="$(mktemp -t ranger_pwd.XXXXXXXXXX)"

        command ranger --choosedir="${ranger_pwd_file}" "${@}"

        if [[ -r ${ranger_pwd_file} ]]; then
            local ranger_last_pwd=$(<"${ranger_pwd_file}")
            if [[ -d ${ranger_last_pwd} ]] && [[ ${ranger_last_pwd} != ${PWD} ]]; then
                cd "${ranger_last_pwd}"
            fi
            zf_rm -f "${ranger_pwd_file}"
        fi
    }

    # Change ranger CWD to PWD on subshell exit
    if [[ -v RANGER_LEVEL ]]; then
        _ranger_cd () {
            print "cd ${PWD}" > "${XDG_RUNTIME_DIR}/ranger-ipc.${PPID}"
        }
        add-zsh-hook zshexit _ranger_cd
    fi
fi
