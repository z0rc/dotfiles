# Set cursor shape as I-beam before prompt, switch to block before executing commands
# https://invisible-island.net/ncurses/terminfo.ti.html#toc-_X_T_E_R_M__Features
# Ss - set cursor shape, usually 6 as argument means I-beam
# Se - reset cursor shape, which is usually block
#
# TODO: drop all of this once zsh ships the native zle_cursorform array
# (post-5.9), check for it with (( ${+parameters[zle_cursorform]} ))
if (( ${+terminfo[Ss]} && ${+terminfo[Se]} )); then
    autoload -Uz add-zle-hook-widget

    _zsh_cursor_shape_reset() {
        echoti Se
    }

    _zsh_cursor_shape_ibeam() {
        echoti Ss 6
    }

    add-zle-hook-widget -Uz zle-line-init   _zsh_cursor_shape_ibeam
    add-zle-hook-widget -Uz zle-line-finish _zsh_cursor_shape_reset
    add-zsh-hook zshexit _zsh_cursor_shape_reset
fi
