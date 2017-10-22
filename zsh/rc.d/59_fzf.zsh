if (( ${+commands[ag]} )); then
    export FZF_DEFAULT_COMMAND='ag --ignore .git -g ""'
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
fi

source "${DOTFILES}/tools/fzf/shell/key-bindings.zsh"
bindkey -r '^T'
bindkey '^E' fzf-cd-widget

source "${DOTFILES}/tools/fzf/shell/completion.zsh"
