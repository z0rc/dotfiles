# Some handy suffix aliases
alias -s log=less

# Human file sizes
alias df="df -Th"
alias du="du -hc"

# Handy stuff
alias grep="grep --color=auto --binary-files=without-match --devices=skip"
alias quilt="quilt --quiltrc ${DOTFILES}/configs/quiltrc"
alias tmux="tmux -f ${DOTFILES}/tmux/tmux.conf"
alias wget="wget --hsts-file=${XDG_CACHE_HOME}/wget-hsts"
alias stmux="tmux new-session 'sudo -i'"
alias ls="ls --group-directories-first --color"
alias ll="LC_COLLATE=C ls -l --almost-all --file-type --human-readable"
