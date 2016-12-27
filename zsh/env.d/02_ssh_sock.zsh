# Keep SSH_AUTH_SOCK valid across several attachments to the remote tmux session
if [[ `whoami` != root ]]; then
    if [[ -S "$XDG_RUNTIME_DIR/ssh-agent.socket" ]]; then
        ln -sf "$XDG_RUNTIME_DIR/ssh-agent.socket" "$HOME/.ssh/ssh_auth_sock"
    elif [[ -S "$SSH_AUTH_SOCK" ]] && [[ ! -h "$SSH_AUTH_SOCK" ]] && [[ "$SSH_AUTH_SOCK" != "$HOME/.ssh/ssh_auth_sock" ]]; then
        ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/ssh_auth_sock"
    fi
    export SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock"
fi
