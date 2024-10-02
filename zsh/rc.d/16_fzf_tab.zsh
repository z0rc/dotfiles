# Use fzf for tab completions
source "${ZDOTDIR}/plugins/fzf-tab/fzf-tab.zsh"

zstyle ':fzf-tab:*' prefix ''

if [[ -v TMUX ]]; then
    zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
fi
