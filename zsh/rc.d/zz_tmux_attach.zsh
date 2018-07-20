# Attach to a tmux session, if there's any. Do this only for remote SSH sessions, don't mess local tmux sessions.
if (( ${+commands[tmux]} )) && [[ -z "${TMUX}" ]] && pgrep -U $(whoami) tmux &>/dev/null && [[ -n "${SSH_TTY}" ]] && [[ -z "${MC_SID}" ]]; then
    tmux attach
fi
