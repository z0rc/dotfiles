# iTerm2 integration
if [[ -v ITERM_PROFILE || -v ITERM_SESSION ]]; then
    export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
    source $ZDOTDIR/plugins/iterm2-shell-integration/shell_integration/zsh
    path=($ZDOTDIR/plugins/iterm2-shell-integration/utilities $path)
fi
