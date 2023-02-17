# Some handy suffix aliases
alias -s log=less

# Human file sizes
alias df="df -Th"
alias du="du -hc"

# Handy stuff and a bit of XDG compliance
alias grep="grep --color=auto --binary-files=without-match --devices=skip"
(( ${+commands[quilt]} )) && alias quilt="quilt --quiltrc ${DOTFILES}/configs/quiltrc"
(( ${+commands[tmux]} )) && {
    alias tmux="tmux -f ${DOTFILES}/tmux/tmux.conf"
    alias stmux="tmux new-session 'sudo -i'"
}
(( ${+commands[wget]} )) && alias wget="wget --hsts-file=${XDG_CACHE_HOME}/wget-hsts"
alias ls="ls --group-directories-first --color=auto --hyperlink=auto --classify"
alias ll="LC_COLLATE=C ls -l -v --almost-all --human-readable"

# History suppression
alias clear=" clear"
alias pwd=" pwd"
alias exit=" exit"

# Safety
alias rm="rm -I"

# Suppress suggestions and globbing
alias find="noglob find"
alias touch="nocorrect touch"
alias mkdir="nocorrect mkdir"
alias cp="nocorrect cp"
(( ${+commands[ag]} )) && alias ag="noglob ag"
(( ${+commands[fd]} )) && alias fd="noglob fd"

# sudo wrapper which is able to expand aliases and handle noglob/nocorrect builtins
do_sudo () {
    integer glob=1
    local -a run
    run=(command sudo)
    if [[ ${#} -gt 1 && ${1} = -u ]]; then
        run+=(${1} ${2})
        shift; shift
    fi
    while (( ${#} )); do
        case "${1}" in
            command|exec|-) shift; break ;;
            nocorrect) shift ;;
            noglob) glob=0; shift ;;
            *) break ;;
        esac
    done
    if (( glob )); then
        ${run} $~==*
    else
        ${run} $==*
    fi
}
alias sudo="noglob do_sudo "
