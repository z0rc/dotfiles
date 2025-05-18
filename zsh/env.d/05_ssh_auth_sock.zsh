# Keep SSH_AUTH_SOCK valid across several attachments to the remote tmux session
if (( EUID != 0 )); then
    if [[ -S "${GNUPGHOME}/S.gpg-agent.ssh" ]]; then
        zf_ln -sf "${GNUPGHOME}/S.gpg-agent.ssh" "${HOME}/.ssh/ssh_auth_sock"
    elif [[ -S "/run/user/${EUID}/gnupg/S.gpg-agent.ssh" ]]; then
        zf_ln -sf "/run/user/${EUID}/gnupg/S.gpg-agent.ssh" "${HOME}/.ssh/ssh_auth_sock"
    elif [[ -S "${XDG_RUNTIME_DIR}/ssh-agent.socket" ]]; then
        zf_ln -sf "${XDG_RUNTIME_DIR}/ssh-agent.socket" "${HOME}/.ssh/ssh_auth_sock"
    elif [[ -S "${SSH_AUTH_SOCK}" ]] && [[ ! -h "${SSH_AUTH_SOCK}" ]] && [[ "${SSH_AUTH_SOCK}" != "${HOME}/.ssh/ssh_auth_sock" ]]; then
        zf_ln -sf "${SSH_AUTH_SOCK}" "${HOME}/.ssh/ssh_auth_sock"
    fi
    export SSH_AUTH_SOCK="${HOME}/.ssh/ssh_auth_sock"
fi
