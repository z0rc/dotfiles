export FZF_DEFAULT_OPTS="--ansi"
# Try to use fd or rg or ag, if available as default fzf command
if (( ${+commands[fd]} )); then
    export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --color=always'
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
elif (( ${+commands[rg]} )); then
    export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --color=always --glob "!.git/*"'
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
elif (( ${+commands[ag]} )); then
    export FZF_DEFAULT_COMMAND='ag --ignore .git --color -g ""'
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
fi

source "${DOTFILES}/tools/fzf/shell/key-bindings.zsh"
