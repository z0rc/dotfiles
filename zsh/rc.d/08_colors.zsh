source "${ZDOTDIR}/plugins/ls-colors/lscolors.sh"

# Enable diff with colors
if (( ${+commands[colordiff]} )); then
    alias diff="colordiff --new-file --text --recursive -u --algorithm patience"
fi
