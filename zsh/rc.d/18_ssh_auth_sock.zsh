# Maintain SSH_AUTH_SOCK to link at well-known places
if (( EUID != 0 )) && [[ -d $HOME/.ssh ]]; then
    # `-=` matches sockets following symlinks, `om` prefers the newest
    local -a ssh_socks=(
        # agent forwarded over ssh, `:A` resolves the link itself, when it's inherited from remote tmux
        ${SSH_CONNECTION:+$SSH_AUTH_SOCK}(#qN-=:A)
        $GNUPGHOME/S.gpg-agent.ssh(#qN-=)
        /run/user/$EUID/gnupg/S.gpg-agent.ssh(#qN-=)
        /run/user/$EUID/gnupg/*/S.gpg-agent.ssh(#qN-=om)
        $XDG_RUNTIME_DIR/ssh-agent.socket(#qN-=)
        # whatever agent is there already, `=` without `-` skips the link itself
        $SSH_AUTH_SOCK(#qN=)
    )
    if (( $#ssh_socks )); then
        zf_ln -sfn $ssh_socks[1] $HOME/.ssh/ssh_auth_sock
    fi
    [[ -S $HOME/.ssh/ssh_auth_sock ]] && export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock
    unset ssh_socks
fi
