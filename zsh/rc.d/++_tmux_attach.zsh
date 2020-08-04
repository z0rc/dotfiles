# Attach to a tmux session, if there's any. Do this only for remote SSH sessions, don't mess local tmux sessions
# Handoff to tmux early, as rest of the rc config isn't needed for this
if (( ${+commands[tmux]} )) && [[ ! -v TMUX ]] && pgrep -u "${EUID}" tmux &>/dev/null && [[ -v SSH_TTY ]] && [[ ! -v MC_SID ]]; then
    exec tmux attach
fi
