#!/usr/bin/env zsh

# Default XDG paths
XDG_CACHE_HOME=$HOME/.cache
XDG_CONFIG_HOME=$HOME/.config
XDG_DATA_HOME=$HOME/.local/share

# Get out current path
SCRIPT_DIR="${0:A:h}"
cd $SCRIPT_DIR

# Make sure submodules are installed
git submodule sync
git submodule update --init --recursive

# Install hook to call deploy script after successful pull
ln -sf ../../deploy.sh .git/hooks/post-merge

# Make mongo-hacker
cd mongo-hacker
make mongo_hacker.js

# Create required directories
mkdir -p $XDG_CONFIG_HOME/{git,mc,htop}
mkdir -p $XDG_CACHE_HOME/{vim,zsh}
mkdir -p $XDG_DATA_HOME/{pyenv/plugins,rbenv/plugins,zsh}

# Link config files
ln -sf "$SCRIPT_DIR/zsh/zshenv" "$HOME/.zshenv"
ln -sf "$SCRIPT_DIR/gitconfig" "$XDG_CONFIG_HOME/git/config"
ln -sf "$SCRIPT_DIR/gitattributes" "$XDG_CONFIG_HOME/git/attributes"
ln -sf "$SCRIPT_DIR/mc.ini" "$XDG_CONFIG_HOME/mc/ini"
ln -sf "$SCRIPT_DIR/htoprc" "$XDG_CONFIG_HOME/htop/htoprc"

# Link pyenv plugins to $PYENV_ROOT
ln -snf "$SCRIPT_DIR/pyenv/plugins/python-build" "$XDG_DATA_HOME/pyenv/plugins/python-build"
ln -snf "$SCRIPT_DIR/pyenv-virtualenv" "$XDG_DATA_HOME/pyenv/plugins/pyenv-virtualenv"

# Link rbenv plugins to $RBENV_ROOT
ln -snf "$SCRIPT_DIR/ruby-build" "$XDG_DATA_HOME/rbenv/plugins/ruby-build"
ln -snf "$SCRIPT_DIR/rbenv-ctags" "$XDG_DATA_HOME/rbenv/plugins/rbenv-ctags"
ln -snf "$SCRIPT_DIR/rbenv-default-gems" "$XDG_DATA_HOME/rbenv/plugins/rbenv-default-gems"
ln -snf "$SCRIPT_DIR/default-gems" "$XDG_DATA_HOME/rbenv/default-gems"

# Install crontab task to pull updates every midnight
CRON_TASK="cd $SCRIPT_DIR && git pull >/dev/null 2>&1"
CRON_SCHEDULE="0 0 * * * $CRON_TASK"
cat <(fgrep -i -v "$CRON_TASK" <(crontab -l)) <(echo "$CRON_SCHEDULE") | crontab -
