# iTerm2 integration
if [[ -v ITERM_PROFILE ]] || [[ -v ITERM_SESSION ]]; then
    source "${ZDOTDIR}/plugins/iterm2_integration.zsh"
fi
