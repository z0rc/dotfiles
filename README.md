# License
[WTFPL](COPYING)

# There are many like it, but this one is mine
This repository contains tools and configs I use in shell. No graphical stuff,
usable both on server and personal workstation. Battle tested on macOS and
various Linux distributions including Debian, Ubuntu, CentOS and even WSL.

I'm a big fan of [XDG Base Directory
Specification](http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html)
and organize my dotfiles in a way that they don't clutter the `$HOME`. I was
able to reduce files required to be in `$HOME` to single `.zshenv`, everything
else goes under standard XDG paths or launched via aliases. Additionally if you
have root permissions, you can install dotfiles with [zero home
presence](#zero-home-presence).

# Features
* Extensive Zsh [configuration](zsh/rc.d) and [plugins](zsh/plugins):
  * [pure prompt with async vcs info](https://github.com/intelfx/pure) with couple of additional indicators
  * [completions plugin](https://github.com/zsh-users/zsh-completions)
  * [async autosuggestions plugin](https://github.com/zsh-users/zsh-autosuggestions)
  * [history substring search plugin](https://github.com/zsh-users/zsh-history-substring-search)
  * [syntax highlighting plugin](https://github.com/zsh-users/zsh-syntax-highlighting)
  * [autoenv plugin](https://github.com/Tarrasch/zsh-autoenv)
  * [autopair plugin](https://github.com/hlissner/zsh-autopair)
* Vim [configuration](vim/vimrc) and [plugins](vim/pack)
* Tmux [configuration](tmux/tmux.conf) and [plugins](tmux/plugins)
* Other configs:
  * [Midnight Commander](configs/mc.ini)
  * [ranger](configs/ranger)
  * [quilt](configs/quiltrc)
  * [Git](configs/gitconfig)
  * [htop](configs/htoprc)
* Handy [utilities](tools):
  * [fzf](https://github.com/junegunn/fzf)
  * [MySQLTuner](https://github.com/major/MySQLTuner-perl)
  * [MongoDB Shell Enhancements](https://github.com/TylerBrock/mongo-hacker)
  * [spark](https://github.com/holman/spark) to draw bar charts right in the console
  * [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy) for much better git diff layout
  * [git-extras](https://github.com/tj/git-extras) and [git-standup](https://github.com/kamranahmedse/git-standup), additional helpers for Git
* [pyenv](https://github.com/yyuu/pyenv), [rbenv](https://github.com/rbenv/rbenv), [nodenv](https://github.com/nodenv/nodenv), [luaenv](https://github.com/cehoffman/luaenv) and [goenv](https://github.com/syndbg/goenv)

# Installation
Requirements:
* `zsh` 5.1 or newer (async stuff requires recent enough version of zsh)
* `git` (all external components are added as git submodules
* `make` (optional: required to build mongo-hacker and install git helpers)
* `perl` (optional: used by diff-so-fancy and MySQLTuner)
* `python3` and `pip3` (optional: used by several vim plugins, but they won't be activated, if python3 is missing)

Dotfiles can be installed in any dir, but probably somewhere under `$HOME`.
Personally I use `$HOME/.local/dotfiles`. The installation is pretty simple:
```sh
git clone https://github.com/z0rc/dotfiles.git "$HOME/.local/dotfiles"
$HOME/.local/dotfiles/deploy.sh
chsh -s /bin/zsh
```

[Deployment script](deploy.sh) helps to set up all required symlinks after the
initial clone. Also it adds cron job to pull updates every midnight and serves
as a post-merge git hook, so you don't have to care about updating submodules
after successful pull.

In case of missing python or ruby, they can be installed via pyenv and rbenv
after the deployment.

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

## Vim
Vim 8.0 or higher is required as plugins are configured via native package
interface available in mentioned version. In order you use all bundled vim
plugins, please install vim with python3 and ruby support built-in.

Debian/Ubuntu:
```
apt-get install vim-nox
```

CentOS/RHEL/Fedora:
```
yum install vim-enhanced
```
or
```
dnf install vim-enhanced
```

MacOS:
```
brew install vim --with-python3
```

# Configuration
## Git
Update `~/.config/git/local/user` with your email and name. Something like
this:
```ini
[user]
    email = jdoe@example.com
    name = John Doe
```

Also you can put additional configuration in `~/.config/git/local/stuff`.

## Zsh
Keep in mind that Zsh configuration skips every global configuration file
except `/etc/zsh/zshenv`.

You can add your local configuration into `$ZDOTDIR/env.d/9[0-9]_*` and
`$ZDOTDIR/rc.d/9[0-9]_*`. The difference is that `env.d` is sourced always while
`rc.d` is sourced in interactive session only.

Also `$ZDOTDIR/.zlogin` and `$ZDOTDIR/.zlogout` are available for
modifications, albeit missing by default.

## Vim
Add your local configuration to `$DOTFILES/vim/vimrc.local`.

## Local paths
Local binaries can be put into `$HOME/.local/bin`, it's added to `PATH` by
default. Also man pages can be put into `$XDG_DATA_HOME/man`.

## *env
Pyenv and similar wrappers are lazy-loaded, it means that they won't be
initialized on shell start. Activation is done on the first execution. Check
out output of `type -f pyenv` in shell and
[implementation](zsh/rc.d/15_many_env.zsh).
