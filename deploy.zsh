#!/usr/bin/env zsh

setopt extended_glob err_exit

zmodload -m -F zsh/files b:zf_\*

SCRIPT_DIR=${0:A:h}
# with systemd-homed `a`/`A` expands to storage location `/home/username.homedir` instead of mounted location `/home/username`
# therefore massage SCRIPT_DIR to expected home location by removing `.homedir` from it
if [[ $SCRIPT_DIR == $HOME.homedir* ]]; then
    SCRIPT_DIR=${SCRIPT_DIR/.homedir/}
fi
cd $SCRIPT_DIR

# Default XDG paths
XDG_CACHE_HOME=$HOME/.cache
XDG_CONFIG_HOME=$HOME/.config
XDG_DATA_HOME=$HOME/.local/share
XDG_STATE_HOME=$HOME/.local/state

# Create required directories
print "Creating required directory tree..."
zf_mkdir -p $XDG_CONFIG_HOME/{git/local,htop,ranger,gem,tig,gnupg,nvim/{plugin,after},yazi}
zf_mkdir -p $XDG_CACHE_HOME/{vim/{backup,swap,undo},zsh,tig}
zf_mkdir -p $XDG_DATA_HOME/{{goenv,jenv,luaenv,nodenv,phpenv,plenv,pyenv,rbenv}/plugins,zsh,man/man1,vim/spell,nvim/site/pack/plugins}
zf_mkdir -p $XDG_STATE_HOME
zf_mkdir -p $HOME/.local/{bin,etc}
zf_chmod 700 $XDG_CONFIG_HOME/gnupg
print "  ...done"

# Link zshenv if needed
print "Checking for ZDOTDIR env variable..."
if [[ $ZDOTDIR == $SCRIPT_DIR/zsh ]]; then
    print "  ...present and valid, skipping .zshenv symlink"
else
    print "  ...failed to match this script dir. ZDOTDIR is \"$ZDOTDIR\", which doesn't match expected value \"$SCRIPT_DIR/zsh\". Symlinking .zshenv"
    zf_ln -sfn $SCRIPT_DIR/zsh/.zshenv ${ZDOTDIR:-$HOME}/.zshenv
fi

# Link config files
print Linking config files...
zf_ln -sfn $SCRIPT_DIR/vim $XDG_CONFIG_HOME/vim
zf_ln -sfn $SCRIPT_DIR/nvim/init $XDG_CONFIG_HOME/nvim/plugin/init
zf_ln -sfn $SCRIPT_DIR/nvim/lsp $XDG_CONFIG_HOME/nvim/after/lsp
zf_ln -sfn $SCRIPT_DIR/nvim/ftplugin $XDG_CONFIG_HOME/nvim/ftplugin
zf_ln -sfn $SCRIPT_DIR/nvim/plugins $XDG_DATA_HOME/nvim/site/pack/plugins/start
zf_ln -sfn $SCRIPT_DIR/tmux $XDG_CONFIG_HOME/tmux
zf_ln -sfn $SCRIPT_DIR/configs/gitconfig $XDG_CONFIG_HOME/git/config
zf_ln -sfn $SCRIPT_DIR/configs/gitattributes $XDG_CONFIG_HOME/git/attributes
zf_ln -sfn $SCRIPT_DIR/configs/gitignore $XDG_CONFIG_HOME/git/ignore
zf_ln -sfn $SCRIPT_DIR/configs/tigrc $XDG_CONFIG_HOME/tig/config
zf_ln -sfn $SCRIPT_DIR/configs/htoprc $XDG_CONFIG_HOME/htop/htoprc
zf_ln -sfn $SCRIPT_DIR/configs/ranger $XDG_CONFIG_HOME/ranger/rc.conf
zf_ln -sfn $SCRIPT_DIR/configs/gemrc $XDG_CONFIG_HOME/gem/gemrc
zf_ln -sfn $SCRIPT_DIR/configs/ranger-plugins $XDG_CONFIG_HOME/ranger/plugins
zf_ln -sfn $SCRIPT_DIR/yazi/init.lua $XDG_CONFIG_HOME/yazi/init.lua
zf_ln -sfn $SCRIPT_DIR/yazi/keymap.toml $XDG_CONFIG_HOME/yazi/keymap.toml
zf_ln -sfn $SCRIPT_DIR/yazi/theme.toml $XDG_CONFIG_HOME/yazi/theme.toml
zf_ln -sfn $SCRIPT_DIR/yazi/yazi.toml $XDG_CONFIG_HOME/yazi/yazi.toml
zf_ln -sfn $SCRIPT_DIR/yazi/plugins $XDG_CONFIG_HOME/yazi/plugins
zf_ln -sfn $SCRIPT_DIR/gpg/gpg.conf $XDG_CONFIG_HOME/gnupg/gpg.conf
zf_ln -sfn $SCRIPT_DIR/gpg/gpg-agent.conf $XDG_CONFIG_HOME/gnupg/gpg-agent.conf
print "  ...done"

# Make sure submodules are installed
print "Syncing submodules..."
git submodule sync > /dev/null
git submodule update --init --recursive > /dev/null
git clean -ffd
print "  ...done"

print "Compiling zsh plugins..."
autoload -Uz zrecompile
for zsh_plugin_file in $SCRIPT_DIR/zsh/plugins/**/*.zsh{-theme,}(#q.); do
    zrecompile -pq $zsh_plugin_file
done
print "  ...done"

# Install hook to call deploy script after successful pull
print "Installing git hooks..."
zf_mkdir -p .git/hooks
zf_ln -sfn ../../deploy.zsh .git/hooks/post-merge
zf_ln -sfn ../../deploy.zsh .git/hooks/post-checkout
print "  ...done"

if (( ${+commands[make]} )); then
    # Make install git-extras
    print "Installing git-extras..."
    pushd tools/git-extras
    PREFIX=$HOME/.local make install > /dev/null
    popd
    print "  ...done"

    print "Installing git-quick-stats..."
    pushd tools/git-quick-stats
    PREFIX=$HOME/.local make install > /dev/null
    popd
    print "  ...done"
fi

print "Installing fzf..."
pushd tools/fzf
if fzf_install_output=$(./install --bin); then
    zf_ln -sfn $SCRIPT_DIR/tools/fzf/bin/fzf $HOME/.local/bin/fzf
    zf_ln -sfn $SCRIPT_DIR/tools/fzf/bin/fzf-tmux $HOME/.local/bin/fzf-tmux
    zf_ln -sfn $SCRIPT_DIR/tools/fzf/man/man1/fzf.1 $XDG_DATA_HOME/man/man1/fzf.1
    zf_ln -sfn $SCRIPT_DIR/tools/fzf/man/man1/fzf-tmux.1 $XDG_DATA_HOME/man/man1/fzf-tmux.1
    print "  ...done"
else
    print $fzf_install_output
    print "  ...error detected, ignoring, please check the fzf installation guide"
fi
popd

if (( ${+commands[perl]} )); then
    # Install diff-so-fancy
    print "Installing diff-so-fancy..."
    zf_ln -sfn $SCRIPT_DIR/tools/diff-so-fancy/diff-so-fancy $HOME/.local/bin/diff-so-fancy
    print "  ...done"
fi

if (( ${+commands[vim]} )); then
    # Generate vim help tags
    print "Generating vim helptags..."
    command vim --not-a-term -i "NONE" -c "helptags ALL" -c "qall" &> /dev/null
    print "  ...done"
fi

if (( ${+commands[nvim]} )); then
    # Generate nvim help tags
    print "Generating nvim helptags..."
    command nvim --headless -c "helptags ALL" -c "qall" &> /dev/null
    print "  ...done"
    # Update treesitter config
    print "Updating tree-sitter parsers..."
    command nvim --headless -c "TSUpdate" -c "qall" &> /dev/null
    print "  ...done"
    # Update mason registries
    print "Updating mason registries..."
    command nvim --headless -c "MasonUpdate" -c "qall" &> /dev/null
    print "  ...done"
fi

# For each env-wrapper link its plugins
print "Linking env-wrappers' plugins..."
    for env_wrapper in $SCRIPT_DIR/env-wrappers/*; do
        # 'plugin' here is a directory with name which doesn't match env-wrapper's name
        for env_wrapper_plugin in $env_wrapper/^${env_wrapper:t}$*(#qN/); do
            zf_ln -sfn $env_wrapper_plugin $XDG_DATA_HOME/${env_wrapper:t}/plugins/${env_wrapper_plugin:t}
        done
    done
    zf_ln -sfn $SCRIPT_DIR/env-wrappers/goenv/goenv/plugins/go-build $XDG_DATA_HOME/goenv/plugins/go-build
    zf_ln -sfn $SCRIPT_DIR/env-wrappers/jenv/jenv/available-plugins/export $XDG_DATA_HOME/jenv/plugins/export
    zf_ln -sfn $SCRIPT_DIR/env-wrappers/pyenv/default-packages $XDG_DATA_HOME/pyenv/default-packages
    zf_ln -sfn $SCRIPT_DIR/env-wrappers/rbenv/default-gems $XDG_DATA_HOME/rbenv/default-gems
print "  ...done"

# Trigger zsh run with powerlevel10k prompt to download gitstatusd
print "Downloading gitstatusd for powerlevel10k..."
zsh -is <<< '' &> /dev/null
print "  ...done"

# Download/refresh TLDR pages
print "Downloading TLDR pages..."
pushd tools/tldr-bash-client
if tldr_u_output=$(./tldr -u); then
    print "  ...done"
else
    print $tldr_u_output
    print "  ...error detected, ignoring"
fi
popd

# Install task to pull updates every midnight
print "Installing periodic update task..."
if (( ${+commands[systemctl]} )); then
    print "  ...systemd detected, installing timer for periodic updates..."

    if (( EUID == 0 )); then
        systemd_unit_dir=/etc/systemd/system
        systemctl_cmd=(systemctl)
        print "  ...running as root, installing system-wide timer..."
    else
        systemd_unit_dir=$XDG_CONFIG_HOME/systemd/user
        systemctl_cmd=(systemctl --user)
        print "  ...running as regular user, installing user timer..."
    fi
    zf_mkdir -p $systemd_unit_dir

    service_name=pull-dotfiles.service
    service_content="[Unit]
Description=Pull dotfiles update
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/bin/git -c user.name=systemd.update -c user.email=systemd@localhost pull
WorkingDirectory=$SCRIPT_DIR"
    print -r -- $service_content > $systemd_unit_dir/$service_name

    timer_name=pull-dotfiles.timer
    timer_content="[Unit]
Description=Pull dotfiles update daily

[Timer]
OnCalendar=daily
RandomizedDelaySec=120s
Persistent=true

[Install]
WantedBy=timers.target"
    print -r -- $timer_content > $systemd_unit_dir/$timer_name

    if ${systemctl_cmd[@]} daemon-reload > /dev/null && ${systemctl_cmd[@]} enable --now $timer_name > /dev/null; then
       print "  ...done"
    else
       print "Failed to install systemd timer. Check permissions and systemd setup"
    fi
elif (( ${+commands[crontab]} )); then
    print "  ...cron detected, installing job for periodic updates..."
    cron_task="cd $SCRIPT_DIR && git -c user.name=cron.update -c user.email=cron@localhost pull"
    cron_schedule="0 0 * * * $cron_task"
    if cat <(grep --ignore-case --invert-match --fixed-strings $cron_task <(crontab -l)) <(echo $cron_schedule) | crontab -; then
        print "  ...done"
    else
        print "Please add \`cd $SCRIPT_DIR && git pull\` to your crontab or just ignore this, you can always update dotfiles manually"
    fi
else
    print "  ...no systemd or cron detected, skipping"
fi
