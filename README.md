# Zero home presence dotfiles

## License

[WTFPL](COPYING)

## There are many like it, but this one is mine

This repository contains tools and configs I use in shell. No graphical stuff,
usable on servers and personal workstations. Battle tested on macOS and
various Linux distributions including Debian, Ubuntu, CentOS and even WSL.

I'm a big fan of [XDG Base Directory
Specification](http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html)
and organize my dotfiles in a way that they don't clutter the `$HOME`. I was
able to reduce files required to be in `$HOME` to single `.zshenv`, everything
else goes under standard XDG paths or launched via aliases. Additionally if you
have root permissions, you can install dotfiles with [zero home
presence](#zero-home-presence).

## Features

* Extensive Zsh [configuration](zsh/rc.d) and [plugins](zsh/plugins), including:
  * [powerline10k](https://github.com/romkatv/powerlevel10k) prompt
  * [additional completions](https://github.com/zsh-users/zsh-completions)
  * [async autosuggestions
    plugin](https://github.com/zsh-users/zsh-autosuggestions)
  * [syntax highlighting
    plugin](https://github.com/zsh-users/zsh-syntax-highlighting)
  * [autoenv plugin](https://github.com/Tarrasch/zsh-autoenv)
  * [autopair plugin](https://github.com/hlissner/zsh-autopair)
  * [clean zsh implementation of `z`](https://github.com/agkozak/zsh-z)
* Vim [configuration](vim/vimrc) and [plugins](vim/pack)
* Tmux [configuration](tmux/tmux.conf) and [plugins](tmux/plugins)
* Other configs:
  * [Midnight Commander](configs/mc.ini)
  * [ranger](configs/ranger)
  * [quilt](configs/quiltrc)
  * [Git](configs/gitconfig)
  * [htop](configs/htoprc)
* Handy [utilities](tools), including:
  * [fzf](https://github.com/junegunn/fzf)
  * [spark](https://github.com/holman/spark) to draw bar charts right in the
    console
  * [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy) for much better
    git diff layout
  * [git-extras](https://github.com/tj/git-extras) additional helpers for Git
* env wrappers for multiple programming languages:
  * [goenv](https://github.com/syndbg/goenv)
  * [jenv](https://github.com/jenv/jenv)
  * [luaenv](https://github.com/cehoffman/luaenv)
  * [nodenv](https://github.com/nodenv/nodenv)
  * [phpenv](https://github.com/phpenv/phpenv)
  * [plenv](https://github.com/tokuhirom/plenv)
  * [pyenv](https://github.com/yyuu/pyenv)
  * [rbenv](https://github.com/rbenv/rbenv)

## Installation

Requirements:

* `zsh` version 5.9 or newer is strongly recommended
* `git` all external components are added as git submodules

Recommended:

* `make` (optional: required to install git helpers)
* `perl` (optional: used by diff-so-fancy)
* [`fd`](https://github.com/sharkdp/fd),
  [`ag`](https://github.com/ggreer/the_silver_searcher) and
  [`bat`](https://github.com/sharkdp/bat) (optional: will be used
  in fzf by default, if present)

Dotfiles can be installed in any dir, but probably somewhere under `$HOME`.
Personally I use `$HOME/.local/dotfiles`. The installation is pretty simple:

```shell
git clone https://github.com/z0rc/dotfiles.git "$HOME/.local/dotfiles"
$HOME/.local/dotfiles/deploy.zsh
chsh -s /bin/zsh
```

[Deployment script](deploy.zsh) helps to set up all required symlinks after the
initial clone. Also it adds cron job to pull updates every midnight and serves
as a post-merge git hook, so you don't have to care about updating submodules
after successful pull.

## Zero home presence

It's possible to install dotfiles without creating `~/.zshenv` symlink. In
order to do so, there should be an environment variable `ZDOTDIR` set to
`<installation dir>/zsh`, e.g. `$HOME/.local/dotfiles/zsh`. This variable
should be set super early in login process, before zsh starts sourcing user's
`.zshenv`. One possible option is to add

```sh
export ZDOTDIR="$HOME/.local/dotfiles/zsh"
```

into `/etc/zsh/zshenv`. Or you can do it with PAM env module.

## Vim version

Vim 9.1 or higher is required to support XDG Base Dir Spec. In order you use
all bundled vim plugins, please install vim with python3 and ruby support
built-in.

## Configuration

### Git configuration

Update `~/.config/git/local/user` with your email and name. Something like
this:

```ini
[user]
    email = jdoe@example.com
    name = John Doe
```

Also you can put additional configuration in `~/.config/git/local/stuff`.

### Zsh configuration

Keep in mind that Zsh configuration skips every global configuration file
except `/etc/zsh/zshenv`.

You can add your local configuration into `$ZDOTDIR/env.d/9[0-9]_*` and
`$ZDOTDIR/rc.d/9[0-9]_*`. The difference is that `env.d` is sourced always while
`rc.d` is sourced in interactive session only.

Also `$ZDOTDIR/.zlogin` and `$ZDOTDIR/.zlogout` are available for
modifications, albeit missing by default.

### Vim configuration

Add your local configuration to `$DOTFILES/vim/vimrc.local`.

### Local paths

Local binaries can be put into `$HOME/.local/bin`, it's added to `PATH` by
default. Also man pages can be put into `$XDG_DATA_HOME/man`.

### Lazy \*env

Pyenv and similar wrappers are lazy-loaded, it means that they won't be
initialized on shell start. Activation is done on the first execution. Check
out output of `type -f pyenv` in shell and
[implementation](zsh/rc.d/11_many_env.zsh). Also this means, that files like
`.python-version` won't work as expected, it's recommended to use `autoenv.zsh`
to explicitly activate needed environment.

### Ignore config files changes locally

Midnight Commander is quite volatile in terms of writing to its configuration
file. Running `mc` using different screen size results in updating panel size
value in `mc.ini`. Same goes with `htop`.

In order to ignore local changes to configuration files you can do:

```sh
git update-index --assume-unchanged configs/mc.ini
```

To restore git tracking of those files use:

```
git update-index --no-assume-unchanged configs/mc.ini
```
