# Some handy suffix aliases
alias -s log=less

# Human file sizes
(( ${+commands[df]} )) && alias df="df --human-readable --print-type"
(( ${+commands[du]} )) && alias du="du --human-readable --total"

# Handy stuff and a bit of XDG compliance
(( ${+commands[grep]} )) && alias grep="grep --color=auto --binary-files=without-match --devices=skip"
(( ${+commands[quilt]} )) && alias quilt="quilt --quiltrc ${DOTFILES}/configs/quiltrc"
(( ${+commands[tmux]} )) && {
    alias tmux="tmux -f ${DOTFILES}/tmux/tmux.conf"
    alias stmux="tmux new-session 'sudo --login'"
}
(( ${+commands[wget]} )) && alias wget="wget --hsts-file=${XDG_CACHE_HOME}/wget-hsts"
(( ${+commands[ls]} )) && {
    alias ls="ls --group-directories-first --color=auto --hyperlink=auto --classify"
    alias ll="LC_COLLATE=C ls -l -v --almost-all --human-readable"
}

# History suppression
(( ${+commands[clear]} )) && alias clear=" clear"
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
(( ${+commands[man]} )) && alias man="nocorrect wrap_man"
(( ${+commands[sudo]} )) && alias sudo="noglob wrap_sudo " # trailing space is needed to enable alias expansion
