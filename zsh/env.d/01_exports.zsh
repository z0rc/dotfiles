# Prefered editor and pager
export VISUAL=vim
export EDITOR=vim
export VIMINIT='let $MYVIMRC="$DOTFILES/vim/vimrc" | source $MYVIMRC'
export PAGER=less
export LESS="-RiwM"

# XDG basedir spec compliance
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME"=$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export LESSHISTFILE="$XDG_DATA_HOME/lesshst"
export MYSQL_HISTFILE="$XDG_DATA_HOME/mysql_history"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem/specs"
export WINEPREFIX="$XDG_DATA_HOME/wine"
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME/docker/machine"
export VAGRANT_HOME="$XDG_DATA_HOME/vagrant"
export HTOPRC="$XDG_CONFIG_HOME/htop/htoprc"
export PACKER_CONFIG="$XDG_CONFIG_HOME/packer"
export PACKER_CACHE_DIR="$XDG_CACHE_HOME/packer"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/config"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export GOPATH="$HOME/.local/go"

# Enable local binaries and man pages
export PATH="$HOME/.local/bin:$GOPATH/bin:$PATH"
export MANPATH="$XDG_DATA_HOME/man:$MANPATH"
