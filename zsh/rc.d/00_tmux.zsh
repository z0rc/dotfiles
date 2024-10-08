# Start tmux, if it's first terminal tab, skip this on remote sessions and root/sudo
# Handoff to tmux early, as rest of the rc config isn't needed for this
if (( ${+commands[tmux]} )) && [[ ! -v TMUX && ! -v SSH_TTY && ${EUID} != 0 ]] && ! tmux list-sessions &>/dev/null; then
    exec tmux new-session
fi
