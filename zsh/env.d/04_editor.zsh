# prefer nvim over vim
if (( ${+commands[nvim]} )); then
    export EDITOR=nvim
    export VISUAL=nvim
elif (( ${+commands[vim]} )); then
    export EDITOR=vim
    export VISUAL=vim
fi
