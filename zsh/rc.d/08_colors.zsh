# Color man
# Set originally "bold" as "bold and red"
# Set originally "underline" as "underline and green"
man () {
    # termcap codes
    # md    start bold
    # mb    start blink
    # me    turn off bold, blink and underline
    # so    start standout (reverse video)
    # se    stop standout
    # us    start underline
    # ue    stop underline
    LESS_TERMCAP_md=$(echoti bold; echoti setaf 1) \
    LESS_TERMCAP_mb=$(echoti blink) \
    LESS_TERMCAP_me=$(echoti sgr0) \
    LESS_TERMCAP_so=$(echoti smso) \
    LESS_TERMCAP_se=$(echoti rmso) \
    LESS_TERMCAP_us=$(echoti smul; echoti setaf 2) \
    LESS_TERMCAP_ue=$(echoti sgr0) \
    nocorrect noglob command man ${@}
}

# Enable color support of ls
if (( ${+commands[dircolors]} )); then
    evalcache dircolors "${ZDOTDIR}/plugins/dircolors-solarized/dircolors.256dark"
fi

# Enable diff with colors
if (( ${+commands[colordiff]} )); then
    alias diff="colordiff --new-file --text --recursive -u --algorithm patience"
fi
