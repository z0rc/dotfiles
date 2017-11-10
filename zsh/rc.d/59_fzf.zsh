# Use ag if available as default fzf command
if (( ${+commands[ag]} )); then
    export FZF_DEFAULT_COMMAND='ag --ignore .git -g ""'
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
fi

source "${DOTFILES}/tools/fzf/shell/key-bindings.zsh"

# Rebind ctrl+t to ctrl+e as former is occupied by konsole's new tab
bindkey -r '^T'
bindkey '^E' fzf-cd-widget
