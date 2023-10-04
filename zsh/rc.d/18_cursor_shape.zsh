# Set cursor shape as I-beam before prompt, switch to block before executing commands
# https://invisible-island.net/ncurses/terminfo.ti.html#toc-_X_T_E_R_M__Features
# Ss - set cursor shape, usually 6 as argument means I-beam
# Se - reset cursor shape, which is usually block
if (( ${+terminfo[Ss]} && ${+terminfo[Se]} )); then
    _zsh_cursor_shape_block() {
        echoti Se
    }

    _zsh_cursor_shape_ibeam() {
        echoti Ss 6
    }

    add-zsh-hook preexec _zsh_cursor_shape_block
    add-zsh-hook precmd _zsh_cursor_shape_ibeam
fi
