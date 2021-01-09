# Some handy suffix aliases
alias -s log=less

# sudo wrapper which is able to expand aliases and handle noglob/nocorrect builtins
alias sudo="noglob do_sudo "

# Human file sizes
alias df="df -Th"
alias du="du -hc"

# Handy stuff and a bit of XDG compliance
alias grep="grep --color=auto --binary-files=without-match --devices=skip"
(( ${+commands[quilt]} )) && alias quilt="quilt --quiltrc ${DOTFILES}/configs/quiltrc"
(( ${+commands[tmux]} )) && alias tmux="tmux -f ${DOTFILES}/tmux/tmux.conf"
(( ${+commands[tmux]} )) && alias stmux="tmux new-session 'sudo -i'"
(( ${+commands[wget]} )) && alias wget="wget --hsts-file=${XDG_CACHE_HOME}/wget-hsts"
alias ls="ls --group-directories-first --color=auto --classify"
alias ll="LC_COLLATE=C ls -l -v --almost-all --human-readable"

# History suppression
alias clear=" clear"
alias pwd=" pwd"
alias exit=" exit"

# Safety
alias rm="rm -I"

# Suppress suggestions and globbing
alias man="nocorrect noglob man"
alias find="noglob find"
alias touch="nocorrect touch"
alias mkdir="nocorrect mkdir"
alias cp="nocorrect cp"
(( ${+commands[ag]} )) && alias ag="noglob ag"
(( ${+commands[fd]} )) && alias fd="noglob fd"
