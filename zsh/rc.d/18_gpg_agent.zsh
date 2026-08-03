# Remind gpg-agent to update current tty before running git or ssh
if (( ${+commands[gpg-connect-agent]} )) && pgrep -u $EUID gpg-agent &>/dev/null; then
    function _preexec_gpg-agent-update-tty {
        if [[ $1 == (git|ssh)* ]]; then
            gpg-connect-agent --quiet --no-autostart updatestartuptty /bye &>/dev/null
        fi
    }

    add-zsh-hook preexec _preexec_gpg-agent-update-tty
fi
