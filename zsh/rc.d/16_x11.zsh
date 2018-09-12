# Transfer to root user's Xauth cookies
if [[ ${EUID} -eq 0 && -n "${SSH_CLIENT}" && -n "${SUDO_USER}" && -n "${DISPLAY}" ]]; then
    local_display=$(echo ${DISPLAY} | cut -d':' -f 2 | cut -d'.' -f 1)
    cred=$(su - ${SUDO_USER} -c "xauth list" | grep ${local_display})
    echo ${cred} | xargs -n 3 xauth add
fi

# Allow root to use my DISPLAY (only on linux for now)
if [[ -n "${DISPLAY}" && "${OSTYPE}" == linux* ]] && (( ${+commands[xhost]} )); then
    xhost +si:localuser:root 2>&1 1>/dev/null
fi
