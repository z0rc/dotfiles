# Color man
printf -v LESS_TERMCAP_mb "\e[1;31m"
printf -v LESS_TERMCAP_md "\e[1;31m"
printf -v LESS_TERMCAP_me "\e[0m"
printf -v LESS_TERMCAP_se "\e[0m"
printf -v LESS_TERMCAP_so "\e[0;37;102m"
printf -v LESS_TERMCAP_ue "\e[0m"
printf -v LESS_TERMCAP_us "\e[4;32m"
export LESS_TERMCAP_mb LESS_TERMCAP_md LESS_TERMCAP_me LESS_TERMCAP_se LESS_TERMCAP_so LESS_TERMCAP_ue LESS_TERMCAP_us

# Enable color support of ls
if (( ${+commands[dircolors]} )); then
    evalcache dircolors "${ZDOTDIR}/plugins/dircolors-solarized/dircolors.256dark"
fi

# Enable diff with colors
if (( ${+commands[colordiff]} )); then
    alias diff="colordiff -Naur"
fi
