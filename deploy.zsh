#!/usr/bin/env zsh

setopt extended_glob err_exit

zmodload -m -F zsh/files b:zf_\*

# Get the current absolute path of script dir, but don't pass though zsh's `a` or `A` expansion
# `a`/`A` expand bind mounted dirs to source dir, which is undesired with systemd-homed managed $HOME
0="${${(M)0:#/*}:-$PWD/$0}"
SCRIPT_DIR="${0:P:h}"
cd "${SCRIPT_DIR}"

# Default XDG paths
XDG_CACHE_HOME="${HOME}/.cache"
XDG_CONFIG_HOME="${HOME}/.config"
XDG_DATA_HOME="${HOME}/.local/share"
XDG_STATE_HOME="${HOME}/.local/state"

# Create required directories
print "Creating required directory tree..."
zf_mkdir -p "${XDG_CONFIG_HOME}"/{git/local,htop,ranger,gem,tig,gnupg,nvim/plugin,yazi}
zf_mkdir -p "${XDG_CACHE_HOME}"/{vim/{backup,swap,undo},zsh,tig}
zf_mkdir -p "${XDG_DATA_HOME}"/{{goenv,jenv,luaenv,nodenv,phpenv,plenv,pyenv,rbenv}/plugins,zsh,man/man1,vim/spell,nvim/site/pack/plugins}
zf_mkdir -p "${XDG_STATE_HOME}"
zf_mkdir -p "${HOME}"/.local/{bin,etc}
zf_chmod 700 "${XDG_CONFIG_HOME}/gnupg"
print "  ...done"

# Link zshenv if needed
print "Checking for ZDOTDIR env variable..."
if [[ "${ZDOTDIR}" = "${SCRIPT_DIR}/zsh" ]]; then
    print "  ...present and valid, skipping .zshenv symlink"
else
    zf_ln -sf "${SCRIPT_DIR}/zsh/.zshenv" "${ZDOTDIR:-${HOME}}/.zshenv"
    print "  ...failed to match this script dir, symlinking .zshenv"
fi

# Link config files
print "Linking config files..."
zf_ln -sfn "${SCRIPT_DIR}/vim" "${XDG_CONFIG_HOME}/vim"
zf_ln -sfn "${SCRIPT_DIR}/nvim/init" "${XDG_CONFIG_HOME}/nvim/plugin/init"
zf_ln -sfn "${SCRIPT_DIR}/nvim/lsp" "${XDG_CONFIG_HOME}/nvim/lsp"
zf_ln -sfn "${SCRIPT_DIR}/nvim/after" "${XDG_CONFIG_HOME}/nvim/after"
zf_ln -sfn "${SCRIPT_DIR}/nvim/plugins" "${XDG_DATA_HOME}/nvim/site/pack/plugins/start"
zf_ln -sfn "${SCRIPT_DIR}/tmux" "${XDG_CONFIG_HOME}/tmux"
zf_ln -sf "${SCRIPT_DIR}/configs/gitconfig" "${XDG_CONFIG_HOME}/git/config"
zf_ln -sf "${SCRIPT_DIR}/configs/gitattributes" "${XDG_CONFIG_HOME}/git/attributes"
zf_ln -sf "${SCRIPT_DIR}/configs/gitignore" "${XDG_CONFIG_HOME}/git/ignore"
zf_ln -sf "${SCRIPT_DIR}/configs/tigrc" "${XDG_CONFIG_HOME}/tig/config"
zf_ln -sf "${SCRIPT_DIR}/configs/htoprc" "${XDG_CONFIG_HOME}/htop/htoprc"
zf_ln -sf "${SCRIPT_DIR}/configs/ranger" "${XDG_CONFIG_HOME}/ranger/rc.conf"
zf_ln -sf "${SCRIPT_DIR}/configs/gemrc" "${XDG_CONFIG_HOME}/gem/gemrc"
zf_ln -sfn "${SCRIPT_DIR}/configs/ranger-plugins" "${XDG_CONFIG_HOME}/ranger/plugins"
zf_ln -sf "${SCRIPT_DIR}/yazi/init.lua" "${XDG_CONFIG_HOME}/yazi/init.lua"
zf_ln -sf "${SCRIPT_DIR}/yazi/keymap.toml" "${XDG_CONFIG_HOME}/yazi/keymap.toml"
zf_ln -sf "${SCRIPT_DIR}/yazi/theme.toml" "${XDG_CONFIG_HOME}/yazi/theme.toml"
zf_ln -sf "${SCRIPT_DIR}/yazi/yazi.toml" "${XDG_CONFIG_HOME}/yazi/yazi.toml"
zf_ln -sfn "${SCRIPT_DIR}/yazi/plugins" "${XDG_CONFIG_HOME}/yazi/plugins"
print "  ...done"

# Make sure submodules are installed
print "Syncing submodules..."
git submodule sync > /dev/null
git submodule update --init --recursive > /dev/null
git clean -ffd
print "  ...done"

print "Compiling zsh plugins..."
{
    local plugin_file
    autoload -Uz zrecompile
    for plugin_file in "${SCRIPT_DIR}"/zsh/plugins/**/*.zsh{-theme,}(#q.); do
        zrecompile -pq "${plugin_file}"
    done
}
print "  ...done"

# Install hook to call deploy script after successful pull
print "Installing git hooks..."
zf_mkdir -p .git/hooks
zf_ln -sf ../../deploy.zsh .git/hooks/post-merge
zf_ln -sf ../../deploy.zsh .git/hooks/post-checkout
print "  ...done"

if (( ${+commands[make]} )); then
    # Make install git-extras
    print "Installing git-extras..."
    pushd tools/git-extras
    PREFIX="${HOME}/.local" make install > /dev/null
    popd
    print "  ...done"

    print "Installing git-quick-stats..."
    pushd tools/git-quick-stats
    PREFIX="${HOME}/.local" make install > /dev/null
    popd
    print "  ...done"
fi

# Link gpg configs to $GNUPGHOME
print "Linking gnupg configs..."
zf_ln -sf "${SCRIPT_DIR}/gpg/gpg.conf" "${XDG_CONFIG_HOME}/gnupg/gpg.conf"
zf_ln -sf "${SCRIPT_DIR}/gpg/gpg-agent.conf" "${XDG_CONFIG_HOME}/gnupg/gpg-agent.conf"
print "  ...done"

print "Installing fzf..."
pushd tools/fzf
if ./install --bin > /dev/null; then
    zf_ln -sf "${SCRIPT_DIR}/tools/fzf/bin/fzf" "${HOME}/.local/bin/fzf"
    zf_ln -sf "${SCRIPT_DIR}/tools/fzf/bin/fzf-tmux" "${HOME}/.local/bin/fzf-tmux"
    zf_ln -sf "${SCRIPT_DIR}/tools/fzf/man/man1/fzf.1" "${XDG_DATA_HOME}/man/man1/fzf.1"
    zf_ln -sf "${SCRIPT_DIR}/tools/fzf/man/man1/fzf-tmux.1" "${XDG_DATA_HOME}/man/man1/fzf-tmux.1"
    print "  ...done"
else
    print "  ...failed. Probably unsupported architecture, please check fzf installation guide"
fi
popd

if (( ${+commands[perl]} )); then
    # Install diff-so-fancy
    print "Installing diff-so-fancy..."
    zf_ln -sf "${SCRIPT_DIR}/tools/diff-so-fancy/diff-so-fancy" "${HOME}/.local/bin/diff-so-fancy"
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
    command nvim --headless -c "TS update" -c "qall" &> /dev/null
    print "  ...done"
    # Update mason registries
    print "Updating mason registries..."
    command nvim --headless -c "MasonUpdate" -c "qall" &> /dev/null
    print "  ...done"
fi

# For each env-wrapper link its plugins
print "Linking env-wrappers' plugins..."
{
    local wrapper plugin
    for wrapper in "${SCRIPT_DIR}"/env-wrappers/*; do
        # 'plugin' here is a directory with name which doesn't match env-wrapper's name
        for plugin in "${wrapper}"/^${wrapper:t}$*(#qN/); do
            zf_ln -snf "${plugin}" "${XDG_DATA_HOME}/${wrapper:t}/plugins/${plugin:t}"
        done
    done
    zf_ln -snf "${SCRIPT_DIR}/env-wrappers/goenv/goenv/plugins/go-build" "${XDG_DATA_HOME}/goenv/plugins/go-build"
    zf_ln -snf "${SCRIPT_DIR}/env-wrappers/jenv/jenv/available-plugins/export" "${XDG_DATA_HOME}/jenv/plugins/export"
    zf_ln -sf "${SCRIPT_DIR}/env-wrappers/pyenv/default-packages" "${XDG_DATA_HOME}/pyenv/default-packages"
    zf_ln -sf "${SCRIPT_DIR}/env-wrappers/rbenv/default-gems" "${XDG_DATA_HOME}/rbenv/default-gems"
}
print "  ...done"

# Trigger zsh run with powerlevel10k prompt to download gitstatusd
print "Downloading gitstatusd for powerlevel10k..."
zsh -is <<< '' &> /dev/null
print "  ...done"

# Download/refresh TLDR pages
print "Downloading TLDR pages..."
{
    local tldr_u_output
    if ! tldr_u_output="$("${SCRIPT_DIR}/tools/tldr-bash-client/tldr" -u)"; then
        print ${tldr_u_output}
        print "  ...error detected, ignoring"
    else
        print "  ...done"
    fi
}


# Install task to pull updates every midnight
print "Installing periodic update task..."
if (( ${+commands[systemctl]} )); then
    print "  ...systemd detected, installing timer for periodic updates..."

    if (( EUID == 0 )); then
        local systemd_unit_dir="/etc/systemd/system"
        local systemctl_cmd=("systemctl")
        print "  ...running as root, installing system-wide timer..."
    else
        local systemd_unit_dir="${XDG_CONFIG_HOME}/systemd/user"
        local systemctl_cmd=("systemctl" "--user")
        print "  ...running as regular user, installing user timer..."
    fi
    zf_mkdir -p "${systemd_unit_dir}"

    local service_name="pull-dotfiles.service"
    local service_content="[Unit]
Description=Pull dotfiles update
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/bin/git -c user.name=systemd.update -c user.email=systemd@localhost pull
WorkingDirectory=${SCRIPT_DIR}
"
    print -r -- "${service_content}" > "${systemd_unit_dir}/${service_name}"

    local timer_name="pull-dotfiles.timer"
    local timer_content="[Unit]
Description=Pull dotfiles update daily

[Timer]
OnCalendar=daily
RandomizedDelaySec=120s
Persistent=true

[Install]
WantedBy=timers.target
"
    print -r -- "${timer_content}" > "${systemd_unit_dir}/${timer_name}"

    if ${systemctl_cmd[@]} daemon-reload > /dev/null && ${systemctl_cmd[@]} enable --now "${timer_name}" > /dev/null; then
       print "  ...done"
    else
       print "Failed to install systemd timer. Check permissions and systemd setup"
    fi
elif (( ${+commands[crontab]} )); then
    print "  ...cron detected, installing job for periodic updates..."
    local cron_task="cd ${SCRIPT_DIR} && git -c user.name=cron.update -c user.email=cron@localhost pull"
    local cron_schedule="0 0 * * * ${cron_task}"
    if cat <(grep --ignore-case --invert-match --fixed-strings "${cron_task}" <(crontab -l)) <(echo "${cron_schedule}") | crontab -; then
        print "  ...done"
    else
        print "Please add \`cd ${SCRIPT_DIR} && git pull\` to your crontab or just ignore this, you can always update dotfiles manually"
    fi
else
    print "  ...no systemd or cron detected, skipping"
fi
