# Color man
export LESS_TERMCAP_mb=$(printf "\e[1;31m")
export LESS_TERMCAP_md=$(printf "\e[1;31m")
export LESS_TERMCAP_me=$(printf "\e[0m")
export LESS_TERMCAP_se=$(printf "\e[0m")
export LESS_TERMCAP_so=$(printf "\e[0;37;102m")
export LESS_TERMCAP_ue=$(printf "\e[0m")
export LESS_TERMCAP_us=$(printf "\e[4;32m")

# Enable color support of ls
if (( $+commands[dircolors] )); then
    eval `dircolors "$ZSHDIR/plugins/dircolors-solarized/dircolors.256dark"`
    alias ls="ls --color=auto -F -X"
    alias dir="dir --color=auto"
    alias vdir="vdir --color=auto"
fi

# More colors
if (( $+commands[grc] )); then
    alias colorify="grc -es --colour=auto"
    for command in df dig gcc ifconfig mount mtr netstat ping ps traceroute; do
        if [[ -f "/usr/local/share/grc/conf.$command" ]] || [[ -f "/usr/share/grc/conf.$command" ]]; then
            alias $command="colorify $command"
        fi
    done
    for command in head tail make ld; do
        alias $command="colorify $command"
    done
fi
if (( $+commands[colordiff] )); then
    alias diff="colordiff -Naur"
fi
