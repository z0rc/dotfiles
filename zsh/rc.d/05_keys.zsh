# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

zmodload zsh/terminfo

# First setup keys using terminfo database
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
key[Backspace]=${terminfo[kbs]}
key[Enter]=${terminfo[cr]}
key[ShiftTab]=${terminfo[kcbt]}
# man 5 user_caps
key[CtrlLeft]=${terminfo[kLFT5]}
key[CtrlRight]=${terminfo[kRIT5]}

# Bind detected keys to widgets
[[ -n ${key[Home]}      ]] && bindkey ${key[Home]}      beginning-of-line
[[ -n ${key[End]}       ]] && bindkey ${key[End]}       end-of-line
[[ -n ${key[Insert]}    ]] && bindkey ${key[Insert]}    overwrite-mode
[[ -n ${key[Delete]}    ]] && bindkey ${key[Delete]}    delete-char
[[ -n ${key[Left]}      ]] && bindkey ${key[Left]}      backward-char
[[ -n ${key[Right]}     ]] && bindkey ${key[Right]}     forward-char
[[ -n ${key[Up]}        ]] && bindkey ${key[Up]}        up-line-or-beginning-search
[[ -n ${key[Down]}      ]] && bindkey ${key[Down]}      down-line-or-beginning-search
[[ -n ${key[PageUp]}    ]] && bindkey ${key[PageUp]}    beginning-of-buffer-or-history
[[ -n ${key[PageDown]}  ]] && bindkey ${key[PageDown]}  end-of-buffer-or-history
[[ -n ${key[Backspace]} ]] && bindkey ${key[Backspace]} backward-delete-char
[[ -n ${key[Enter]}     ]] && bindkey ${key[Enter]}     accept-line
[[ -n ${key[ShiftTab]}  ]] && bindkey ${key[ShiftTab]}  reverse-menu-complete
[[ -n ${key[CtrlLeft]}  ]] && bindkey ${key[CtrlLeft]}  backward-word
[[ -n ${key[CtrlRight]} ]] && bindkey ${key[CtrlRight]} forward-word
unset key

# Also bind some 'CSI u' keys, https://www.leonerd.org.uk/hacks/fixterms/
typeset -A csi
csi[base]="\e["
csi[really-special-prefix]=${csi[base]}"1;"
csi[special-suffix]="~"
csi[modifier-Ctrl]="5"
csi[special-Insert]="2"
csi[special-Delete]="3"
csi[special-PageUp]="5"
csi[special-PageDown]="6"
csi[special-Home]="7"
csi[special-End]="8"
csi[exception-ShiftTab]="Z"
csi[really-special-Up]="A"
csi[really-special-Down]="B"
csi[really-special-Right]="C"
csi[really-special-Left]="D"
csi[really-special-End]="F"
csi[really-special-Home]="H"

bindkey ${csi[base]}${csi[really-special-Home]}                                         beginning-of-line
bindkey ${csi[base]}${csi[really-special-End]}                                          end-of-line
bindkey ${csi[base]}${csi[special-Home]}${csi[special-suffix]}                          beginning-of-line
bindkey ${csi[base]}${csi[special-End]}${csi[special-suffix]}                           end-of-line
bindkey ${csi[base]}${csi[special-Insert]}${csi[special-suffix]}                        overwrite-mode
bindkey ${csi[base]}${csi[special-Delete]}${csi[special-suffix]}                        delete-char
bindkey ${csi[base]}${csi[special-Left]}${csi[special-suffix]}                          backward-char
bindkey ${csi[base]}${csi[special-Right]}${csi[special-suffix]}                         forward-char
bindkey ${csi[base]}${csi[special-Up]}${csi[special-suffix]}                            up-line-or-beginning-search
bindkey ${csi[base]}${csi[special-Down]}${csi[special-suffix]}                          down-line-or-beginning-search
bindkey ${csi[base]}${csi[special-PageUp]}${csi[special-suffix]}                        beginning-of-buffer-or-history
bindkey ${csi[base]}${csi[special-PageDown]}${csi[special-suffix]}                      end-of-buffer-or-history
bindkey ${csi[base]}${csi[exception-ShiftTab]}                                          reverse-menu-complete
bindkey ${csi[really-special-prefix]}${csi[modifier-Ctrl]}${csi[really-special-Left]}   backward-word
bindkey ${csi[really-special-prefix]}${csi[modifier-Ctrl]}${csi[really-special-Right]}  forward-word
unset csi

# Make dot key autoexpand "..." to "../.." and so on
_zsh-dot () {
    if [[ ${LBUFFER} = *.. ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}
zle -N _zsh-dot
bindkey . _zsh-dot

# Make previously autoloaded function as widget and bind it to Ctrl+L
zle -N clear-screen-soft-bottom
bindkey '^L' clear-screen-soft-bottom

# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start { echoti smkx }
    function zle_application_mode_stop { echoti rmkx }
    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi
