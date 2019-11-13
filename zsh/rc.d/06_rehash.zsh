# On USR1 signal do a rehash, to refresh available binaries in $PATH
TRAPUSR1() { rehash; };

# If previous command was something like package manager, then send USR1 to all zsh processes
_install_rehash_precmd() {
    if [[ $history[$[HISTCMD-1]] == *(apt|pip|dpkg|yum|rpm|brew|npm|gem|dnf)* ]]; then
        local psux=("${(@f)"$(command ps ux)"}")
        for zsh_proc in ${(M)psux:#*zsh*~*gitstatusd*}; do
            kill -USR1 ${${(s: :)zsh_proc}[2]} &>/dev/null &!
        done
    fi
}

# Do this check at precmd hook
autoload -U add-zsh-hook
add-zsh-hook precmd _install_rehash_precmd
