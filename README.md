# Zero Home Presence Dotfiles

## License

[WTFPL](COPYING)

## There are many like it, but this one is mine

This repository contains tools and configurations I use in the shell. It
includes no graphical configurations, making it usable on servers and personal
workstations. It has been battle-tested on macOS and various Linux
distributions, including Debian, Ubuntu, CentOS, and even WSL.

I'm a big fan of the [XDG Base Directory
Specification](http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html)
and organize my dotfiles in a way that they don't clutter the `$HOME`
directory. I have reduced the files required in `$HOME` to a single
`.zshenv`; everything else goes under standard XDG paths or is launched via
aliases. Additionally, if you have root permissions, you can install dotfiles
with [zero home presence](#zero-home-presence).

## Features

* Extensive Zsh [configuration](zsh/rc.d) and [plugins](zsh/plugins), including:
  * [powerlevel10k](https://github.com/romkatv/powerlevel10k) prompt
  * [additional completions](https://github.com/zsh-users/zsh-completions)
  * [async autosuggestions plugin](https://github.com/zsh-users/zsh-autosuggestions)
  * [syntax highlighting plugin](https://github.com/zsh-users/zsh-syntax-highlighting)
  * [autoenv plugin](https://github.com/Tarrasch/zsh-autoenv)
  * [autopair plugin](https://github.com/hlissner/zsh-autopair)
  * [clean Zsh implementation of `z`](https://github.com/agkozak/zsh-z)
* Vim [configuration](vim/vimrc) and [plugins](vim/pack)
* Neovim [configuration](nvim/init.lua) and [plugins](nvim/plugins)
* Tmux [configuration](tmux/tmux.conf) and [plugins](tmux/plugins)
* Yazi [configuration](yazi/yazi.toml) and [plugins](yazi/plugins)
* Other configurations:
  * [ranger](configs/ranger)
  * [quilt](configs/quiltrc)
  * [Git](configs/gitconfig)
  * [htop](configs/htoprc)
  * [Ghostty](configs/ghostty)
* Handy [utilities](tools), including:
  * [fzf](https://github.com/junegunn/fzf)
  * [spark](https://github.com/holman/spark) to draw bar charts right in the console
  * [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy) for a much better git diff layout
  * [git-extras](https://github.com/tj/git-extras) additional helpers for Git
* [Environment wrappers](env-wrappers) for multiple programming languages:
  * [goenv](https://github.com/syndbg/goenv)
  * [jenv](https://github.com/jenv/jenv)
  * [luaenv](https://github.com/cehoffman/luaenv)
  * [nodenv](https://github.com/nodenv/nodenv)
  * [phpenv](https://github.com/phpenv/phpenv)
  * [plenv](https://github.com/tokuhirom/plenv)
  * [pyenv](https://github.com/yyuu/pyenv)
  * [rbenv](https://github.com/rbenv/rbenv)

## Installation

> [!WARNING]
> I'm in process on switching to Neovim. Vim configuration isn't maintained
> anymore, might be removed in future.

### Requirements

* `zsh` version 5.9 or newer is strongly recommended
* `git` all external components are added as git submodules
* `which` required build dependecy

### Optional Dependencies

* `make` required to install git helpers
* `perl` diff-so-fancy runtime
* [`delta`](https://github.com/dandavison/delta) will be used as git pager instead of diff-so-fancy
* [`bat`](https://github.com/sharkdp/bat) will be used as man pager
* Nerd Fonts Symbols Only installed and enabled fallback in terminal emulator

### Location

Dotfiles can be installed in any directory, but probably somewhere under
`$HOME`. Personally, I use `$HOME/.local/dotfiles`. The installation is
simple:

```sh
git clone https://github.com/z0rc/dotfiles.git "$HOME/.local/dotfiles"
$HOME/.local/dotfiles/deploy.zsh
chsh -s /bin/zsh
```

The [deployment script](deploy.zsh) helps set up all required symlinks after
the initial clone. It also adds a cron job to pull updates every midnight and
serves as a post-merge git hook, so you don't have to worry about updating
submodules after a successful pull.

## Zero Home Presence

It's possible to install dotfiles without creating a `~/.zshenv` symlink. To
do so, set the environment variable `ZDOTDIR` to `<installation dir>/zsh`,
e.g., `$HOME/.local/dotfiles/zsh`. This variable should be set very early in
the login process, before zsh starts sourcing the user's `.zshenv`. One
possible option is to add:

```sh
export ZDOTDIR="$HOME/.local/dotfiles/zsh"
```

into `/etc/zsh/zshenv`. Alternatively, you can set it with a PAM environment
module.

## Neovim Version

Neovim configuration is tested with latest released Neovim version only. At the
moment of writing it's version 0.11.0.

## Vim Version

Vim 9.1 or higher is required to support the XDG Base Directory Specification.
To use all bundled vim plugins, install vim with Python and Ruby support
built-in.

## Configuration

### Git Configuration

Update `~/.config/git/local/user` with your email and name. It should look
like this:

```ini
[user]
    email = jdoe@example.com
    name = John Doe
```

You can also add additional configurations in `~/.config/git/local/stuff`.

### Zsh Configuration

Note that Zsh configuration skips every global configuration file except
`/etc/zsh/zshenv`.

You can add your local configuration into `$ZDOTDIR/env.d/9[0-9]_*` and
`$ZDOTDIR/rc.d/9[0-9]_*`. The difference is that `env.d` is sourced always,
while `rc.d` is sourced only in interactive sessions.

Additionally, `$ZDOTDIR/.zlogin` and `$ZDOTDIR/.zlogout` are available for
modifications, though they are missing by default.

### Neovim Configuration

Local configuration can be added to:

* `$DOTFILES/nvim/init/0[1-9]_*` (like `01_local.lua`) to load after default
  options, but before any plugin.
* `$DOTFILES/nvim/init/9[0-9]_*` (like `99_local.vim`) to load after plugins.

### Vim Configuration

Add your local configuration to `$DOTFILES/vim/vimrc.local`.

### Local Paths

Local binaries can be placed in `$HOME/.local/bin`; it's added to `PATH` by
default. Man pages can be placed in `$XDG_DATA_HOME/man`.

### Lazy \*env

Pyenv and similar wrappers are lazy-loaded, meaning they won't be initialized
at shell start. Activation occurs on the first execution. Check the output of
`type -f pyenv` in the shell and the
[implementation](zsh/rc.d/12_many_env.zsh). Because of this, files like
`.python-version` won't work as expected; it's recommended to use
`autoenv.zsh` to explicitly activate the needed environment.

### Ignore Config Files Changes Locally

For example, Htop updates its config file `htoprc` when changing any view
mode or sort order. To ignore local changes to configuration files, you can do:

```sh
git update-index --assume-unchanged configs/htoprc
```

To restore git tracking of those files, use:

```sh
git update-index --no-assume-unchanged configs/htoprc
```
