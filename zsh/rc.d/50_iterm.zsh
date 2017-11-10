# iTerm2 integration
if [[ -n "${ITERM_PROFILE}" ]] || [[ -n "${ITERM_SESSION}" ]]; then
    source "${ZDOTDIR}/plugins/iterm2_integration.zsh"
fi
