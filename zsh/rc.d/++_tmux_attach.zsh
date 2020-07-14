# Attach to a tmux session, if there's any. Do this only for remote SSH sessions, don't mess local tmux sessions.
if (( ${+commands[tmux]} )) && [[ ! -v TMUX ]] && pgrep -U "${USER}" tmux &>/dev/null && [[ -v SSH_TTY ]] && [[ ! -v MC_SID ]]; then
    exec tmux attach
fi
