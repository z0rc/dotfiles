# Get absolute path for zshdir and dotfiles
SOURCE="${(%):-%N}"
while [[ -h "$SOURCE" ]]; do
    DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
export ZSHDIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
export DOTFILES="$(cd $ZSHDIR/.. && pwd)"

# Source local env files
for envfile in "$ZSHDIR"/env.d/*; do
    source $envfile
done

# Include interactive rc files
if [[ -o interactive ]]; then
    for conffile in "$ZSHDIR"/rc.d/*; do
        source $conffile
    done
fi
