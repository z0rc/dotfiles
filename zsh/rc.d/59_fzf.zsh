# Try to use fd or ag, if available as default fzf command
if (( ${+commands[fd]} )); then
    export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --color=always'
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
    export FZF_DEFAULT_OPTS="--ansi"
elif (( ${+commands[ag]} )); then
    export FZF_DEFAULT_COMMAND='ag --ignore .git -g ""'
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
fi

# If bat is available, use it for previews
if (( ${+commands[bat]})); then
    export FZF_DEFAULT_OPTS="--ansi --preview 'bat --pager=never --color=always --style=plain,changes --line-range :30 {}'"
fi

source "${DOTFILES}/tools/fzf/shell/key-bindings.zsh"
