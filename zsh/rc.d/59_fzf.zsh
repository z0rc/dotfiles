# Use ag if available as default fzf command
if (( ${+commands[ag]} )); then
    export FZF_DEFAULT_COMMAND='ag --ignore .git -g ""'
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
fi

source "${DOTFILES}/tools/fzf/shell/key-bindings.zsh"
