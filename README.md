# dotfiles
There are many like them, but these one are mine.

This repostory holds conguration for most common tools I use in shell. No graphical stuff, usable both on servers and personal workstations. Battle tested on various Linux distributions including Debian, Ubuntu, CentOS and OSX. But with BSD/OSX it requires to have GNU coreutils to be avaliable under regular names (without `g` prefix).

I'm a big fan of [XDG Base Directory Specification](http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html) and organize my dotfiles in a way that they don't clutter the `$HOME`. I was able to reduce files required to be in `$HOME` to single `.zshenv`, everything else is in `.config` or launched via aliases.

To install navigate to your `$HOME`, `git clone https://github.com/z0rc/dotfiles.git .dotfiles`, `.dotfiles/deploy.sh`, `chsh -s /bin/zsh` and you're ready to go (don't forget to open a new session).

Repostory includes:
* Extensive Zsh [configuration](zsh/.zshrc)
  * [completions plugin](https://github.com/zsh-users/zsh-completions)
  * [autosuggestions plugin](https://github.com/tarruda/zsh-autosuggestions)
  * [history substring search plugin](https://github.com/zsh-users/zsh-history-substring-search)
  * [syntax highlighting plugin](https://github.com/zsh-users/zsh-syntax-highlighting)
* Vim [configuration](vim/vimrc) and [plugins](vim/bundle) managed by [pathogen](https://github.com/tpope/vim-pathogen)
* tmux [configuration](tmux.conf)
* Midnight Commander [configuration](mc.ini)
* quilt [configuration](quiltrc)
* Git [config](gitconfig)
* Handy utilities
  * [MySQLTuner](https://github.com/major/MySQLTuner-perl)
  * [MongoDB Shell Enhancements](https://github.com/TylerBrock/mongo-hacker)
  * [`k`](https://github.com/rimraf/k), modern `ls` with bells and whistles
  * [spark](https://github.com/holman/spark) to draw bar charts right in the console
  * [privatepaste uploader](privatepaste.py)

[Simple deployment script](deploy.sh) helps to set up all required symlinks after the initial clone. Also it adds cron job to pull updates every midnight and serves as a post-merge git hook, so you don't have to care about submodules after successful pull.
