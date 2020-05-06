export FZF_DEFAULT_OPTS="--ansi"
# Try to use fd or ag, if available as default fzf command
if (( ${+commands[fd]} )); then
    export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --color=always'
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
    export FZF_DEFAULT_OPTS="--ansi"
elif (( ${+commands[ag]} )); then
    export FZF_DEFAULT_COMMAND='ag --ignore .git -g ""'
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
fi

source "${DOTFILES}/tools/fzf/shell/completion.zsh"
source "${DOTFILES}/tools/fzf/shell/key-bindings.zsh"

# fzf-history-widget with duplicate removal, preview and syntax highlighting (requires `bat`).
function z4h-fzf-history() {
    emulate -L zsh -o pipefail
    zmodload zsh/system           || return
    zmodload -F zsh/files b:zf_rm || return
    local preview='printf "%s" {}'
    (( $+commands[bat] )) && preview+=' | bat -l bash --color always -pp'
    local tmp=${TMPDIR:-/tmp}/zsh-hist.$sysparams[pid]
    {
        print -rNC1 -- "${(@u)history}" |
            fzf --read0 --no-multi --tiebreak=index --cycle --height=80%             \
                --preview-window=down:40%:wrap --preview=$preview                    \
                --bind '?:toggle-preview,ctrl-h:backward-kill-word' --query=$LBUFFER \
            >$tmp || return
        local cmd
        while true; do
            sysread 'cmd[$#cmd+1]' && continue
            (( $? == 5 ))          || return
            break
        done <$tmp
        [[ $cmd == *$'\n' ]] || return
        cmd[-1]=
        [[ -n $cmd ]] || return
        zle .vi-fetch-history -n $(($#history - ${${history[@]}[(ie)$cmd]} + 1))
    } always {
        zf_rm -f -- $tmp
        zle .reset-prompt
    }
}
zle -N z4h-fzf-history

bindkey '^R' z4h-fzf-history
