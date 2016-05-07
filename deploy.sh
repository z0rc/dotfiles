#!/usr/bin/env zsh

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
cd $SCRIPT_DIR/..
mkdir -p .config/{git,mc,htop}
mkdir -p .cache
mkdir -p .local/share/pyenv/plugins

# Link config files
ln -sf .dotfiles/zsh/.zshenv .zshenv
touch .dotfiles/zsh/.zshenv.local
ln -sf ../../.dotfiles/gitconfig .config/git/config
ln -sf ../../.dotfiles/gitattributes .config/git/attributes
ln -sf ../../.dotfiles/mc.ini .config/mc/ini
ln -sf ../../.dotfiles/htoprc .config/htop/htoprc

# Link pyenv plugins to $PYENV_ROOT
ln -sf ../../../../.dotfiles/pyenv/plugins/python-build .local/share/pyenv/plugins/python-build
ln -sf ../../../../.dotfiles/pyenv-virtualenv .local/share/pyenv/plugins/pyenv-virtualenv

# Install crontab task to pull updates every midnight
CRON_TASK="cd $SCRIPT_DIR && git pull >/dev/null 2>&1"
CRON_SCHEDULE="0 0 * * * $CRON_TASK"
cat <(fgrep -i -v "$CRON_TASK" <(crontab -l)) <(echo "$CRON_SCHEDULE") | crontab -
