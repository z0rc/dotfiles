# Taken from Arch, most of default zsh configurations don't do this
# Skip it on macOS to disallow path_helper run
if [[ -r /etc/profile && $OSTYPE != darwin* ]]; then
    # profile logic can unset MANPATH, we need to preserve it
    local save_manpath=$MANPATH

    emulate sh -c 'source /etc/profile'

    MANPATH=$save_manpath
    unset save_manpath
fi
