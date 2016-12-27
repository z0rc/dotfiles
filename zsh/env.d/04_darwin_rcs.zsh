# Disable global zsh configuration on OSX, path_helper doesn't help with sane path sanitization, have to do this by ourselves
if [[ "$OSTYPE" == darwin* ]]; then
    unsetopt GLOBAL_RCS
fi
