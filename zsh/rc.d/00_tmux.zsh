# Start tmux, if it's first terminal tab, skip this on remote sessions and root/sudo
# Handoff to tmux early, as rest of the rc config isn't needed for this
if (( ${+commands[tmux]} )) && [[ ! -v TMUX && ! -v SSH_TTY ]] && (( EUID != 0 )); then
    zmodload -F zsh/net/socket b:zsocket 2>/dev/null
    if ! zsocket ${TMUX_TMPDIR:-/tmp}/tmux-$UID/default 2>/dev/null; then
        exec tmux new-session
    else
        # close file descriptor, so it doesn't leak
        exec {REPLY}>&-
        unset REPLY
    fi
fi
