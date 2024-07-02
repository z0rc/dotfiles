# prefer nvim over vim
if (( ${+commands[nvim]} )); then
    export EDITOR=nvim
    export VISUAL=nvim
else
    export EDITOR=vim
    export VISUAL=vim
fi
