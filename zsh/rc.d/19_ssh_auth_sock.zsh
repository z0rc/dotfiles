# Maintain SSH_AUTH_SOCK to link at well-known places
if (( EUID != 0 )) && [[ -d $HOME/.ssh ]]; then
    # `-=` matches sockets following symlinks, `om` prefers the newest
    local -a ssh_socks=(
        $GNUPGHOME/S.gpg-agent.ssh(#qN-=)
        /run/user/$EUID/gnupg/S.gpg-agent.ssh(#qN-=)
        /run/user/$EUID/gnupg/*/S.gpg-agent.ssh(#qN-=om)
        $XDG_RUNTIME_DIR/ssh-agent.socket(#qN-=)
    )
    if (( $#ssh_socks )); then
        zf_ln -sfn $ssh_socks[1] $HOME/.ssh/ssh_auth_sock
    elif [[ -S $SSH_AUTH_SOCK && ! -h $SSH_AUTH_SOCK && $SSH_AUTH_SOCK != $HOME/.ssh/ssh_auth_sock ]]; then
        zf_ln -sfn $SSH_AUTH_SOCK $HOME/.ssh/ssh_auth_sock
    fi
    [[ -S $HOME/.ssh/ssh_auth_sock ]] && export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock
    unset ssh_socks
fi
