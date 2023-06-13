# Enable color support of ls
if (( ${+commands[dircolors]} )); then
    evalcache dircolors "${ZDOTDIR}/plugins/dircolors-solarized/dircolors.256dark"
fi

# Enable diff with colors
if (( ${+commands[colordiff]} )); then
    alias diff="colordiff --new-file --text --recursive -u --algorithm patience"
fi
