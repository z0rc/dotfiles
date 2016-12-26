# Rehash on software upgrade
autoload -U add-zsh-hook
TRAPUSR1() { rehash };
_install_rehash_precmd() {
    if [[ $history[$[HISTCMD-1]] == *(apt-get|aptitude|pip|dpkg|yum|rpm|brew|npm|gem|dnf)* ]]; then
        ps ux | grep "[z]sh" | awk '{print $2}' | xargs kill -USR1
    fi
}
add-zsh-hook precmd _install_rehash_precmd
