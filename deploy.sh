#!/bin/zsh

# Get out current path
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
cd $SCRIPT_DIR

# Make sure submodules are installed
git submodule update --init --recursive

# Install hook to call deploy script after successful pull
ln -sf ../../deploy.sh .git/hooks/post-merge

# Make mongo-hacker
cd mongo-hacker
make mongo_hacker.js

# Create required directories
cd $SCRIPT_DIR/..
mkdir -p .config/{git,mc}
mkdir -p .cache
mkdir -p .local/share

# Link config files
ln -sf .dotfiles/zsh/.zshenv .zshenv
touch .dotfiles/zsh/.zshenv.local
ln -sf ../../.dotfiles/gitconfig .config/git/config
ln -sf ../../.dotfiles/mc.ini .config/mc/ini

# Install crontab task to pull updates every midnight
CRON_TASK="cd $SCRIPT_DIR && git pull"
CRON_SCHEDULE="0 0 * * * $CRON_TASK"
cat <(fgrep -i -v "$CRON_TASK" <(crontab -l)) <(echo "$CRON_SCHEDULE") | crontab -

