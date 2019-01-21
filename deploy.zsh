#!/usr/bin/env zsh

set -e

# Get the current path
SCRIPT_DIR="${0:A:h}"
cd "${SCRIPT_DIR}"

# Default XDG paths
XDG_CACHE_HOME="${HOME}/.cache"
XDG_CONFIG_HOME="${HOME}/.config"
XDG_DATA_HOME="${HOME}/.local/share"
VIMINIT='let $MYVIMRC="'${SCRIPT_DIR}'/vim/vimrc" | source $MYVIMRC'

# Create required directories
print "Creating required directory tree..."
mkdir -p "${XDG_CONFIG_HOME}"/{git/local,mc,htop,ranger}
mkdir -p "${XDG_CACHE_HOME}"/{vim/{backup,swap,undo},zsh}
mkdir -p "${XDG_DATA_HOME}"/{{pyenv,rbenv,nodenv,luaenv,goenv}/plugins,zsh,man/man1}
mkdir -p "${HOME}"/.local/{bin,etc}
print "  ...done"

# Link zshenv if needed
print "Checking for ZDOTDIR env variable..."
if [[ "${ZDOTDIR}" = "${SCRIPT_DIR}/zsh" ]]; then
    print "  ...present and valid, skipping .zshenv symlink"
else
    ln -sf "${SCRIPT_DIR}/zsh/.zshenv" "${ZDOTDIR:-${HOME}}/.zshenv"
    print "  ...failed to match this script dir, symlinking .zshenv"
fi

# Link config files
print "Linking config files..."
ln -sf "${SCRIPT_DIR}/configs/gitconfig" "${XDG_CONFIG_HOME}/git/config"
ln -sf "${SCRIPT_DIR}/configs/gitattributes" "${XDG_CONFIG_HOME}/git/attributes"
ln -sf "${SCRIPT_DIR}/configs/gitignore" "${XDG_CONFIG_HOME}/git/ignore"
ln -sf "${SCRIPT_DIR}/configs/mc.ini" "${XDG_CONFIG_HOME}/mc/ini"
ln -sf "${SCRIPT_DIR}/configs/htoprc" "${XDG_CONFIG_HOME}/htop/htoprc"
ln -sf "${SCRIPT_DIR}/configs/ranger" "${XDG_CONFIG_HOME}/ranger/rc.conf"
print "  ...done"

# Make sure submodules are installed
print "Syncing submodules..."
git submodule sync > /dev/null
git submodule update --init --recursive > /dev/null
git clean -ffd
print "  ...done"

# Install hook to call deploy script after successful pull
print "Installing git hook..."
mkdir -p .git/hooks
ln -sf ../../deploy.zsh .git/hooks/post-merge
print "  ...done"

if (( ${+commands[make]} )); then
    # Make mongo-hacker
    print "Making mongo-hacker config..."
    pushd tools/mongo-hacker
    make mongo_hacker.js > /dev/null
    popd
    print "  ...done"

    # Make install git-extras
    print "Installing git-extras..."
    pushd tools/git-extras
    PREFIX="${HOME}/.local" make install > /dev/null
    popd
    print "  ...done"
fi

print "Installing git-quick-stats..."
ln -snf "${SCRIPT_DIR}/tools/git-quick-stats/git-quick-stats" "${HOME}/.local/bin/git-quick-stats"
ln -snf "${SCRIPT_DIR}/tools/git-quick-stats/git-quick-stats.1" "${XDG_DATA_HOME}/man/man1/git-quick-stats.1"
print "  ...done"

print "Installing fzf..."
pushd tools/fzf
./install --bin &> /dev/null
ln -sf "${SCRIPT_DIR}/tools/fzf/bin/fzf" "${HOME}/.local/bin/fzf"
ln -sf "${SCRIPT_DIR}/tools/fzf/bin/fzf-tmux" "${HOME}/.local/bin/fzf-tmux"
ln -sf "${SCRIPT_DIR}/tools/fzf/man/man1/fzf.1" "${XDG_DATA_HOME}/man/man1/fzf.1"
ln -sf "${SCRIPT_DIR}/tools/fzf/man/man1/fzf-tmux.1" "${XDG_DATA_HOME}/man/man1/fzf-tmux.1"
popd
print "  ...done"

if (( ${+commands[perl]} )); then
    # Install diff-so-fancy
    print "Installing diff-so-fancy..."
    ln -sf "${SCRIPT_DIR}/tools/diff-so-fancy/diff-so-fancy" "${HOME}/.local/bin/diff-so-fancy"
    print "  ...done"
fi

if (( ${+commands[pip3]} )); then
    # Install neovim python plugin
    print "Installing neovim python client..."
    pip3 install --user --upgrade pynvim > /dev/null
    print "  ...done"
fi

if (( ${+commands[vim]} )); then
    # Generating vim help tags
    print "Generating vim helptags..."
    nohup vim -c 'silent! helptags ALL | q' </dev/null &>/dev/null
    print "  ...done"
fi

if (( ${+commands[make]} )) && (( ${+commands[vim]} )) && (( ${+commands[go]} )); then
    # Making deoplete-go dependencies
    print "Installing deoplete-go dependencies..."
    pushd vim/pack/03_plugins/start/deoplete-go
    if make > /dev/null; then
        print "  ...done"
    else
        print "  Please check intallation instructions at vim/pack/03_plugins/start/deoplete-go/README.md or just ignore this"
    fi
    popd
fi

# Link pyenv plugins to $PYENV_ROOT
print "Linking pyenv plugins..."
ln -snf "${SCRIPT_DIR}/pyenv/pyenv/plugins/python-build" "${XDG_DATA_HOME}/pyenv/plugins/python-build"
ln -snf "${SCRIPT_DIR}/pyenv/pyenv-virtualenv" "${XDG_DATA_HOME}/pyenv/plugins/pyenv-virtualenv"
ln -snf "${SCRIPT_DIR}/pyenv/pyenv-default-packages" "${XDG_DATA_HOME}/pyenv/plugins/pyenv-default-packages"
ln -sf "${SCRIPT_DIR}/pyenv/default-packages" "${XDG_DATA_HOME}/pyenv/default-packages"
print "  ...done"

# Link rbenv plugins to $RBENV_ROOT
print "Linking rbenv plugins..."
local -a rbenv_plugins
rbenv_plugins=("ruby-build" "rbenv-binstubs" "rbenv-chefdk" "rbenv-ctags" "rbenv-default-gems" "rbenv-env" "rbenv-man")
local plugin
for plugin in "${rbenv_plugins[@]}"; do
    ln -snf "${SCRIPT_DIR}/rbenv/${plugin}" "${XDG_DATA_HOME}/rbenv/plugins/${plugin}"
done
ln -sf "${SCRIPT_DIR}/rbenv/default-gems" "${XDG_DATA_HOME}/rbenv/default-gems"
print "  ...done"

# Link nodenv plugins to $NODENV_ROOT
print "Linking nodenv plugins..."
ln -snf "${SCRIPT_DIR}/nodenv/node-build" "${XDG_DATA_HOME}/nodenv/plugins/node-build"
ln -snf "${SCRIPT_DIR}/nodenv/nodenv-aliases" "${XDG_DATA_HOME}/nodenv/plugins/nodenv-aliases"
ln -snf "${SCRIPT_DIR}/nodenv/nodenv-package-rehash" "${XDG_DATA_HOME}/nodenv/plugins/nodenv-package-rehash"
print "  ...done"

# Link luaenv plugins to $LUAENV_ROOT
print "Linking luaenv plugins..."
ln -snf "${SCRIPT_DIR}/luaenv/lua-build" "${XDG_DATA_HOME}/luaenv/plugins/lua-build"
ln -snf "${SCRIPT_DIR}/luaenv/luaenv-luarocks" "${XDG_DATA_HOME}/luaenv/plugins/luaenv-luarocks"
print "  ...done"

# Link goenv plugins to $GOENV_ROOT
print "Linking goenv plugins..."
ln -snf "${SCRIPT_DIR}/goenv/goenv/plugins/go-build" "${XDG_DATA_HOME}/goenv/plugins/go-build"
print "  ...done"

# Install crontab task to pull updates every midnight
print "Installing cron job for periodic updates..."
local cron_task="cd ${SCRIPT_DIR} && git -c user.name=cron.update -c user.email=cron@localhost stash && git pull && git stash pop"
local cron_schedule="0 0 * * * ${cron_task}"
if cat <(fgrep -i -v "${cron_task}" <(crontab -l)) <(echo "${cron_schedule}") | crontab -; then
    print "  ...done"
else
    print "Please add \`cd ${SCRIPT_DIR} && git pull\` to your crontab or just ignore this, you can always update dotfiles manually"
fi
