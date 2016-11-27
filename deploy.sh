#!/usr/bin/env zsh

set -e

# Default XDG paths
XDG_CACHE_HOME="$HOME/.cache"
XDG_CONFIG_HOME="$HOME/.config"
XDG_DATA_HOME="$HOME/.local/share"

# Get the current path
SCRIPT_DIR="${0:A:h}"
cd "$SCRIPT_DIR"

# Create required directories
print "Creating required directory tree..."
mkdir -p "$XDG_CONFIG_HOME"/{git/local,mc,htop,ranger}
mkdir -p "$XDG_CACHE_HOME"/{vim/{backup,swap,undo},zsh}
mkdir -p "$XDG_DATA_HOME"/{pyenv/plugins,rbenv/plugins,nodenv/plugins,zsh,man}
mkdir -p "$HOME"/.local/{bin,etc}
print "  ...done"

# Link config files
print "Linking config files..."
ln -sf "$SCRIPT_DIR/zsh/zshenv" "$HOME/.zshenv"
ln -sf "$SCRIPT_DIR/configs/gitconfig" "$XDG_CONFIG_HOME/git/config"
ln -sf "$SCRIPT_DIR/configs/gitattributes" "$XDG_CONFIG_HOME/git/attributes"
ln -sf "$SCRIPT_DIR/configs/gitignore" "$XDG_CONFIG_HOME/git/ignore"
ln -sf "$SCRIPT_DIR/configs/mc.ini" "$XDG_CONFIG_HOME/mc/ini"
ln -sf "$SCRIPT_DIR/configs/htoprc" "$XDG_CONFIG_HOME/htop/htoprc"
ln -sf "$SCRIPT_DIR/configs/ranger" "$XDG_CONFIG_HOME/ranger/rc.conf"
print "  ...done"

# Make sure submodules are installed
print "Syncing submodules..."
git submodule sync > /dev/null
git submodule update --init --recursive > /dev/null
print "  ...done"

# Install hook to call deploy script after successful pull
print "Installing git hook..."
mkdir -p .git/hooks
ln -sf ../../deploy.sh .git/hooks/post-merge
print "  ...done"

if (( $+commands[make] )); then
    # Make mongo-hacker
    print "Making mongo-hacker config..."
    pushd tools/mongo-hacker
    make mongo_hacker.js > /dev/null
    popd
    print "  ...done"

    # Make install git-extras
    print "Installing git-extras..."
    pushd tools/git-extras
    PREFIX="$HOME"/.local make install > /dev/null
    popd
    print "  ...done"
fi

if (( $+commands[perl] )); then
    # Install diff-so-fancy
    print "Installing diff-so-fancy..."
    ln -sf "$SCRIPT_DIR/tools/diff-so-fancy/diff-so-fancy" "$HOME/.local/bin/diff-so-fancy"
    ln -sf "$SCRIPT_DIR/tools/diff-so-fancy/third_party/diff-highlight/diff-highlight" "$HOME/.local/bin/diff-highlight"
    print "  ...done"
fi

# Link pyenv plugins to $PYENV_ROOT
print "Linking pyenv plugins..."
ln -snf "$SCRIPT_DIR/pyenv/pyenv/plugins/python-build" "$XDG_DATA_HOME/pyenv/plugins/python-build"
ln -snf "$SCRIPT_DIR/pyenv/pyenv-virtualenv" "$XDG_DATA_HOME/pyenv/plugins/pyenv-virtualenv"
ln -snf "$SCRIPT_DIR/pyenv/pyenv-default-packages" "$XDG_DATA_HOME/pyenv/plugins/pyenv-default-packages"
ln -snf "$SCRIPT_DIR/pyenv/default-packages" "$XDG_DATA_HOME/pyenv/default-packages"
print "  ...done"

# Link rbenv plugins to $RBENV_ROOT
print "Linking rbenv plugins..."
local -a rbenv_plugins
rbenv_plugins=("ruby-build" "rbenv-binstubs" "rbenv-chefdk" "rbenv-ctags" "rbenv-default-gems" "rbenv-env" "rbenv-man" "default-gems")
for plugin in "${rbenv_plugins[@]}"; do
    ln -snf "$SCRIPT_DIR/rbenv/$plugin" "$XDG_DATA_HOME/rbenv/plugins/$plugin"
done
print "  ...done"

# Link nodenv plugins
print "Linking nodenv plugins..."
ln -snf "$SCRIPT_DIR/nodenv/node-build" "$XDG_DATA_HOME/nodenv/plugins/node-build"
ln -snf "$SCRIPT_DIR/nodenv/nodenv-aliases" "$XDG_DATA_HOME/nodenv/plugins/nodenv-aliases"
ln -snf "$SCRIPT_DIR/nodenv/nodenv-package-rehash" "$XDG_DATA_HOME/nodenv/plugins/nodenv-package-rehash"
print "  ...done"

# Install crontab task to pull updates every midnight
print "Installing cron job for periodic updates..."
CRON_TASK="cd $SCRIPT_DIR && git stash >/dev/null 2>&1 && git pull >/dev/null 2>&1 && git stash pop >/dev/null 2>&1"
CRON_SCHEDULE="0 0 * * * $CRON_TASK"
if cat <(fgrep -i -v "$CRON_TASK" <(crontab -l)) <(echo "$CRON_SCHEDULE") | crontab -; then
    print "  ...done"
else
    print "Please add \`cd $SCRIPT_DIR && git pull\` to your crontab or just ignore this, you can always update dotfiles manually"
fi
