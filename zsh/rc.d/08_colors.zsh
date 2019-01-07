# Color man
export LESS_TERMCAP_mb=$(printf "\e[1;31m")
export LESS_TERMCAP_md=$(printf "\e[1;31m")
export LESS_TERMCAP_me=$(printf "\e[0m")
export LESS_TERMCAP_se=$(printf "\e[0m")
export LESS_TERMCAP_so=$(printf "\e[0;37;102m")
export LESS_TERMCAP_ue=$(printf "\e[0m")
export LESS_TERMCAP_us=$(printf "\e[4;32m")

# Enable color support of ls
if (( ${+commands[dircolors]} )); then
    eval $(dircolors "${ZDOTDIR}/plugins/dircolors-solarized/dircolors.256dark")
fi

# Enable diff with colors
if (( ${+commands[colordiff]} )); then
    alias diff="colordiff -Naur"
fi
