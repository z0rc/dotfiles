# Override regular 'clear' with custom one, that puts prompt at bottom
# Also suppress it from history
alias clear=" clear-screen-soft-bottom"

# Prefer nvim when installed
(( ${+commands[nvim]} )) && {
    alias nv="nvim"
    alias vi="nvim"
    alias vim="nvim"
}

# Human file sizes
(( ${+commands[df]} )) && alias df="df --human-readable --print-type"
(( ${+commands[du]} )) && alias du="du --human-readable --total"

# Handy stuff and a bit of XDG compliance
(( ${+commands[grep]} )) && alias grep="grep --color=auto --binary-files=without-match --devices=skip"
(( ${+commands[quilt]} )) && alias quilt="quilt --quiltrc $DOTFILES/configs/quiltrc"
(( ${+commands[tmux]} )) && alias stmux="tmux new-session 'sudo --login'"
(( ${+commands[wget]} )) && alias wget="wget --hsts-file=$XDG_CACHE_HOME/wget-hsts"
(( ${+commands[ls]} )) && {
    alias ls="ls --group-directories-first --color=auto --hyperlink=auto --classify"
    alias ll="LC_COLLATE=C ls -l -v --almost-all --human-readable"
}
(( ${+commands[diff]} )) && alias diff="diff --color=auto --new-file --text --recursive --unified"

# History suppression
alias pwd=" pwd"
alias exit=" exit"

# Safety
(( ${+commands[rm]} )) && alias rm="rm -I --preserve-root=all"

# Suppress suggestions and globbing, enable wrappers
(( ${+commands[find]} )) && alias find="noglob find"
(( ${+commands[touch]} )) && alias touch="nocorrect touch"
(( ${+commands[mkdir]} )) && alias mkdir="nocorrect mkdir"
(( ${+commands[cp]} )) && alias cp="nocorrect cp --verbose"
(( ${+commands[ag]} )) && alias ag="noglob ag"
(( ${+commands[fd]} )) && alias fd="noglob fd"
(( ${+commands[man]} )) && alias man="nocorrect man"
(( ${+commands[sudo]} )) && alias sudo="noglob wrap-sudo " # trailing space is needed to enable alias expansion
