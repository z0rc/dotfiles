# We'll do this later in zshrc by ourselves
skip_global_compinit=1

# Don't let Debian to override bindkeys
DEBIAN_PREVENT_KEYBOARD_CHANGES=1

# Disable global zsh configuration on OSX, path_helper doesn't help with sane path sanitization, have to do this by ourselves
if [[ "${OSTYPE}" == darwin* ]]; then
    unsetopt GLOBAL_RCS
fi
