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
#
#   cursor keys    CSI <letter>      modified:  CSI 1 ; <modifier> <letter>
#   special keys   CSI <number> ~    modified:  CSI <number> ; <modifier> ~
#   any other key                    modified:  CSI <codepoint> ; <modifier> u
#
# where <modifier> is 1 + Shift(1) + Alt(2) + Ctrl(4), so Alt is 3 and Ctrl is 5
typeset -A csi

# Cursor keys 'CSI <letter>'
csi[Up]="\e[A"
csi[Down]="\e[B"
csi[Right]="\e[C"
csi[Left]="\e[D"
csi[End]="\e[F"
csi[Home]="\e[H"
# Cursor keys with Ctrl 'CSI 1 ; 5 <letter>'
csi[Ctrl-Up]="\e[1;5A"
csi[Ctrl-Down]="\e[1;5B"
csi[Ctrl-Right]="\e[1;5C"
csi[Ctrl-Left]="\e[1;5D"
csi[Ctrl-End]="\e[1;5F"
csi[Ctrl-Home]="\e[1;5H"
# Cursor keys with Alt 'CSI 1 ; 3 <letter>'
csi[Alt-Right]="\e[1;3C"
csi[Alt-Left]="\e[1;3D"
# Special keys 'CSI <number> ~'
csi[Insert]="\e[2~"
csi[Delete]="\e[3~"
csi[PageUp]="\e[5~"
csi[PageDown]="\e[6~"
csi[Home-tilde]="\e[7~"
csi[End-tilde]="\e[8~"
# Special keys with Ctrl 'CSI <number> ; 5 ~'
csi[Ctrl-Delete]="\e[3;5~"
csi[Ctrl-Home-tilde]="\e[7;5~"
csi[Ctrl-End-tilde]="\e[8;5~"
# Encoded keys 'CSI <codepoint> ; <modifier> u'
csi[Ctrl-Backspace]="\e[127;5u"
csi[Alt-Backspace]="\e[127;3u"
# Spec exception
csi[Shift-Tab]="\e[Z"

bindkey ${csi[Up]}               up-line-or-beginning-search
bindkey ${csi[Down]}             down-line-or-beginning-search
bindkey ${csi[Right]}            forward-char
bindkey ${csi[Left]}             backward-char
bindkey ${csi[End]}              end-of-line
bindkey ${csi[Home]}             beginning-of-line
bindkey ${csi[Ctrl-Up]}          up-line-or-beginning-search
bindkey ${csi[Ctrl-Down]}        down-line-or-beginning-search
bindkey ${csi[Ctrl-Right]}       forward-word
bindkey ${csi[Ctrl-Left]}        backward-word
bindkey ${csi[Ctrl-End]}         end-of-buffer-or-history
bindkey ${csi[Ctrl-Home]}        beginning-of-buffer-or-history
bindkey ${csi[Alt-Right]}        forward-word
bindkey ${csi[Alt-Left]}         backward-word
bindkey ${csi[Insert]}           overwrite-mode
bindkey ${csi[Delete]}           delete-char
bindkey ${csi[PageUp]}           beginning-of-buffer-or-history
bindkey ${csi[PageDown]}         end-of-buffer-or-history
bindkey ${csi[Home-tilde]}       beginning-of-line
bindkey ${csi[End-tilde]}        end-of-line
bindkey ${csi[Ctrl-Delete]}      kill-word
bindkey ${csi[Ctrl-Home-tilde]}  beginning-of-buffer-or-history
bindkey ${csi[Ctrl-End-tilde]}   end-of-buffer-or-history
bindkey ${csi[Ctrl-Backspace]}   backward-kill-word
bindkey ${csi[Alt-Backspace]}    backward-kill-word
bindkey ${csi[Shift-Tab]}        reverse-menu-complete
unset csi

# Make dot key autoexpand "..." to "../.." and so on
_zsh-dot () {
    if [[ $LBUFFER = *.. ]]; then
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
