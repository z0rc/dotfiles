# Maintain SSH_AUTH_SOCK to link at well-known places
if [[ EUID -ne 0 && -d $HOME/.ssh ]]; then
    if [[ -S $GNUPGHOME/S.gpg-agent.ssh ]]; then
        zf_ln -sfn $GNUPGHOME/S.gpg-agent.ssh $HOME/.ssh/ssh_auth_sock
    elif [[ -S /run/user/$EUID/gnupg/S.gpg-agent.ssh ]]; then
        zf_ln -sfn /run/user/$EUID/gnupg/S.gpg-agent.ssh $HOME/.ssh/ssh_auth_sock
    elif [[ -S /run/user/$EUID/gnupg/*/S.gpg-agent.ssh(#qN) ]]; then
        zf_ln -sfn /run/user/$EUID/gnupg/*/S.gpg-agent.ssh $HOME/.ssh/ssh_auth_sock
    elif [[ -S $XDG_RUNTIME_DIR/ssh-agent.socket ]]; then
        zf_ln -sfn $XDG_RUNTIME_DIR/ssh-agent.socket $HOME/.ssh/ssh_auth_sock
    elif [[ -S $SSH_AUTH_SOCK && ! -h $SSH_AUTH_SOCK && $SSH_AUTH_SOCK != $HOME/.ssh/ssh_auth_sock ]]; then
        zf_ln -sfn $SSH_AUTH_SOCK $HOME/.ssh/ssh_auth_sock
    fi
    export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock
fi
