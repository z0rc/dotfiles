# iTerm2 integration
if [[ -v ITERM_PROFILE || -v ITERM_SESSION ]]; then
    export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=1
    source $ZDOTDIR/plugins/iterm2-shell-integration/shell_integration/zsh
    path=($ZDOTDIR/plugins/iterm2-shell-integration/utilities $path)
fi

# Konsole integration
# Based on https://www.reddit.com/r/kde/comments/zf1ehj/psa_konsole_2208_now_supports_semantic_shell/ and P10K native support
if [[ -v KONSOLE_VERSION ]]; then
    export POWERLEVEL9K_TERM_SHELL_INTEGRATION=true

    _konsole_precmd() {
        print -n "\e]133;L\a\e]133;D;$?\a"
    }

    _konsole_preexec() {
        print -n "\e]133;C\a"
    }

    add-zsh-hook precmd _konsole_precmd
    add-zsh-hook preexec _konsole_preexec
fi

# Ghostty integration
if [[ -v GHOSTTY_RESOURCES_DIR ]]; then
    export GHOSTTY_SHELL_FEATURES=cursor,path,title
    source $GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration
fi
