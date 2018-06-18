# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
zmodload zsh/terminfo
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init() {
        echoti smkx
    }
    function zle-line-finish() {
        echoti rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# Create a zkbd compatible hash
typeset -A key
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}
key[BackSpace]=${terminfo[kbs]}
# TODO find better way to detect this
key[Alt]='\e[1;3'
key[Ctrl]='\e[1;5'

# Setup keys accordingly
[[ -n "${key[Home]}" ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n "${key[End]}" ]] && bindkey "${key[End]}" end-of-line
[[ -n "${key[Insert]}" ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n "${key[Delete]}" ]] && bindkey "${key[Delete]}" delete-char
[[ -n "${key[Left]}" ]] && bindkey "${key[Left]}" backward-char
[[ -n "${key[Right]}" ]] && bindkey "${key[Right]}" forward-char
[[ -n "${key[PageUp]}" ]] && bindkey "${key[PageUp]}" beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]] && bindkey "${key[PageDown]}" end-of-buffer-or-history
[[ -n "${key[BackSpace]}" ]] && bindkey "${key[BackSpace]}" backward-delete-char
[[ -n "${key[Right]}" ]] && bindkey "${key[Ctrl]}${key[Right]:(-1)}" forward-word
[[ -n "${key[Left]}" ]] && bindkey "${key[Ctrl]}${key[Left]:(-1)}" backward-word
