# History configuration
HISTFILE=$ZDOTDIR/history
HISTSIZE=2000
SAVEHIST=2000
setopt HIST_IGNORE_ALL_DUPS # remove all earlier duplicate lines
setopt APPEND_HISTORY # history appends to existing file
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS # trim multiple insgnificant blanks in history
setopt HIST_IGNORE_SPACE # don’t store lines starting with space

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Create a zkbd compatible hash
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# Setup keys accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# General configuration
setopt EXTENDED_GLOB
setopt CORRECT_ALL
setopt NO_FLOW_CONTROL # disable stupid annoying keys
setopt MULTIOS # allows multiple input and output redirections
setopt AUTO_CD
setopt CLOBBER
setopt BRACE_CCL
setopt NO_BEEP # do not beep on errors
autoload -U colors && colors  # initialize colors

# Completion basic
autoload -Uz compinit && compinit -d $ZDOTDIR/zcompdump
setopt AUTO_PARAM_SLASH
setopt LIST_TYPES
setopt COMPLETE_IN_WORD # allow completion from within a word/phrase

# URL magic
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# MIME aliases
autoload -U zsh-mime-setup
zsh-mime-setup

# Rehash on software upgrade
autoload -U add-zsh-hook
TRAPUSR1() { rehash };
_install_rehash_precmd() { [[ $history[$[ HISTCMD -1 ]] == *(apt-get|aptitude|pip|dpkg|yum|rpm|brew)* ]] && killall -u $USER -USR1 zsh }
add-zsh-hook precmd _install_rehash_precmd

# Tweaking vcs_info before load
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr '§'
zstyle ':vcs_info:*' unstagedstr '±'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b:%r'
zstyle ':vcs_info:*' enable git svn bzr hg cvs
zstyle ':vcs_info:*' formats '[%b%c%u]'

# Indicate that shell is running under Midnight Commander
_indicate_mc_precmd () {
    [[ -n "$MC_SID" ]] && psvar[1]="[mc]" || psvar[1]=
}

# vcs_info invocation
_indicate_vcs_precmd () {
    vcs_info
    psvar[2]="$vcs_info_msg_0_"
}

# Indicate python virtualenv
export VIRTUAL_ENV_DISABLE_PROMPT=1
_indicate_venv_precmd() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        if [[ -f "$VIRTUAL_ENV/__name__" ]]; then
            local name=$(cat $VIRTUAL_ENV/__name__)
        elif [[ `basename $VIRTUAL_ENV` = "__" ]]; then
            local name=$(basename $(dirname $VIRTUAL_ENV))
        else
            local name=$(basename $VIRTUAL_ENV)
        fi
        psvar[3]="[venv:$name]"
    else
        psvar[3]=
    fi
}

precmd_functions+=(_indicate_mc_precmd _indicate_vcs_precmd _indicate_venv_precmd)

# Indicate SSH session in prompt and window title
if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    echo -ne "\033]0;`id -un`:`id -gn`@`hostname||uname -n|sed 1q` `who -m|sed -e "s%^.* \(pts/[0-9]*\).*(\(.*\))%(\2%g"` → `hostname -i`)\007"
    psvar[4]="[%{$fg[red]%}ssh%{$reset_color%}]"
fi

# Fancy prompts
PROMPT="%1v$psvar[4][%{$fg_bold[yellow]%}%m%{$reset_color%}][%{$fg_bold[green]%}%~%{$reset_color%}]%3v%2v%# "
[[ -n "$MC_SID" ]] && RPROMPT="" || RPROMPT="[%(?..%{$fg_bold[red]%})%?%{$reset_color%}] (%B%T - %D{%m.%d.%Y}%b)"

# Set MC skin whether we're running under root or not
# Also set skin depending under which terminal we're running
if [[ "$TERM" = "linux" && "$USER" != "root" ]]; then
    export MC_SKIN=modarcon16-defbg
    sudo() { if [[ "$1" = "mc" ]]; then command sudo MC_SKIN=modarcon16root-defbg "$@"; else command sudo "$@"; fi; }
elif [[ "$TERM" = "linux" && "$USER" = "root" ]]; then
    export MC_SKIN=modarcon16root-defbg
elif [[ "$TERM" != "linux" && "$USER" != "root" ]]; then
    export MC_SKIN=modarin256-defbg
    sudo() { if [[ "$1" = "mc" ]]; then command sudo MC_SKIN=modarin256root-defbg "$@"; else command sudo "$@"; fi; }
elif [[ "$TERM" != "linux" && "$USER" = "root" ]]; then
    export MC_SKIN=modarin256root-defbg
fi

# Additional completion rules
fpath=(~/.dotfiles/zsh-completions/src $fpath)

# List all directories leading up to a filename; this is useful to see
# if some permissions are blocking access to a file.
lspath () {
    if [[ "$1" = "${1##/}" ]]; then
        pathlist=(/ ${(s:/:)PWD} ${(s:/:)1})
    else
        pathlist=(/ ${(s:/:)1})
    fi
    allpaths=()
    filepath=$pathlist[0]
    shift pathlist
    for i in $pathlist[@]; do
        allpaths=($allpaths[@] $filepath)
        filepath="${filepath%/}/$i"
    done
    allpaths=($allpaths[@] $filepath)
    ls -ld "$allpaths[@]"
}

# Grep from ps output
psg () {
    FST=`echo $1 | sed -e "s/^\(.\).*/\1/"`
    RST=`echo $1 | sed -e "s/^.\(.*\)/\1/"`
    ps aux | grep "[$FST]$RST"
}

# Autoexpand "..." to "../.." and so on
dot () {
    if [[ $LBUFFER = *.. ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}
autoload -U dot
zle -N dot
bindkey . dot

# Use multithreaded archivers if possible
if [[ -x /usr/bin/pigz ]]; then
    function gzip () { pigz $@ }
    export -f gzip > /dev/null
fi

if [[ -x /usr/bin/pbzip2 ]]; then
    function bzip2 () { pbzip2 $@ }
    export -f bzip2 > /dev/null
fi

# Print apt history
apt-history () {
    case "$1" in
    install)
        zgrep --no-filename 'install ' $(ls -rt /var/log/dpkg*)
        ;;
    upgrade|remove)
        zgrep --no-filename $1 $(ls -rt /var/log/dpkg*)
        ;;
    rollback)
        zgrep --no-filename upgrade $(ls -rt /var/log/dpkg*) | \
        grep "$2" -A10000000 | \
        grep "$3" -B10000000 | \
        awk '{print $4"="$5}'
        ;;
    *)
        echo "Parameters:"
        echo " install - Lists all packages that have been installed."
        echo " upgrade - Lists all packages that have been upgraded."
        echo " remove - Lists all packages that have been removed."
        echo " rollback - Lists rollback information."
        ;;
    esac
}

# Universal archive unpack
extract () {
    if [[ -f "$1" ]]; then
        case $1 in
            *.tar.bz2) tar xjf $1    ;;
            *.tar.gz)  tar xzf $1    ;;
            *.tar.xz)  tar xJf $1    ;;
            *.bz2)     bunzip2 $1    ;;
            *.rar)     unrar x $1    ;;
            *.gz)      gunzip $1     ;;
            *.tar)     tar xf $1     ;;
            *.tbz2)    tar xjf $1    ;;
            *.tgz)     tar xzf $1    ;;
            *.zip)     unzip $1      ;;
            *.Z)       uncompress $1 ;;
            *.7z)      7z x $1       ;;
            *)         echo "Unknown archive type '$1'" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Universal archive pack
pack () {
    if [[ -n "$1" ]]; then
        case $1 in
            tbz) tar cjvf $2.tar.bz2 $2   ;;
            tgz) tar czvf $2.tar.gz $2    ;;
            txz) tar cJvf $2.tar.xz $2    ;;
            tar) tar cpvf $2.tar $2       ;;
            bz2) bzip2 $2                 ;;
            gz)  gzip -c -9 -n $2 > $2.gz ;;
            zip) zip -r $2.zip $2         ;;
            7z)  7z a $2.7z $2            ;;
            *)   echo "'$1' cannot be packed via pack()" ;;
        esac
    else
        echo "'$1' is not a valid file type"
    fi
}

# Manual page completion
man_glob () {
    local a
    read -cA a
    if [[ $a[2] = [0-9]* ]]; then
        reply=( $^manpath/man$a[2]/$1*$2(N:t:r) )
    elif [[ $a[2] = -s ]]; then
        reply=( $^manpath/man$a[3]/$1*$2(N:t:r) )
    else
        reply=( $^manpath/man*/$1*$2(N:t:r) )
    fi
}
compctl -K man_glob man

# Make less more friendly
if type -f lesspipe &> /dev/null; then
    export LESSOPEN="| lesspipe %s"
    export LESSCLOSE="lesspipe %s %s"
fi
export LESS="-R"

# Color man
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Enable color support of ls
if type -f dircolors &> /dev/null; then
    eval `dircolors ~/.dotfiles/dircolors-solarized/dircolors.256dark`
    alias ls="ls --color=auto -F -X"
    alias dir="dir --color=auto"
    alias vdir="vdir --color=auto"
fi

# More colors
if type -f grc &> /dev/null; then
    alias ping="grc --colour=on ping"
    alias traceroute="grc --colour=on traceroute"
    alias netstat="grc --colour=on netstat"
fi
if type -f colordiff &> /dev/null; then
    alias diff="colordiff -Naur"
fi

# Some handy suffix aliases
alias -s log=less

# Human file sizes
alias df="df -Th"
alias du="du -hc"

# Make spark availiable withoud adding it to PATH
alias spark="~/.dotfiles/spark/spark"

# Enable mysqltuner without installing it to the PATH
alias mysqltuner="~/.dotfiles/MySQLTuner-perl/mysqltuner.pl"

# Enable mongo-hacker without symlink in home
mongo() { command mongo "$@" --shell --norc ~/.dotfiles/mongo-hacker/mongo_hacker.js; }

# Privatepaste uploader
ppaste() { python ~/.dotfiles/privatepaste.py "$@" }

# Enable "k" plugin
source ~/.dotfiles/k/k.sh

# Completion tweaks
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*' cache-path $ZDOTDIR/zcompcache
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=$color[cyan]=$color[red]"
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion::complete:*' use-cache true

# Transfer to root user's Xauth cookies
if [[ `whoami` = root ]] && [[ -n "$SSH_CLIENT" ]] && [[ -n "$SUDO_USER" ]] && [[ -n "$DISPLAY" ]]; then
    display=`echo $DISPLAY | cut -d':' -f 2 | cut -d'.' -f 1`
    cred=`su - $SUDO_USER -c "xauth list" | grep $display`
    echo $cred | xargs -n 3 xauth add
fi

# Allow root to use my DISPLAY (only on linux for now)
if [[ -n "$DISPLAY" ]] && [[ `uname -o` != "Darwin" ]] && type -f xhost &> /dev/null; then
    xhost +si:localuser:root 2>&1 1>/dev/null
fi

# Highlighting plugin
source ~/.dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# History substring search plugin
source ~/.dotfiles/zsh-history-substring-search/zsh-history-substring-search.zsh
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=green,fg=white,bold'
[[ -n "${key[Up]}"   ]]  && bindkey  "${key[Up]}"   history-substring-search-up
[[ -n "${key[Down]}" ]]  && bindkey  "${key[Down]}" history-substring-search-down

# Autosuggestions plugin
source ~/.dotfiles/zsh-autosuggestions/autosuggestions.zsh
AUTOSUGGESTION_ACCEPT_RIGHT_ARROW=1

# Make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid. And also activate autosuggestions.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
        zle autosuggest-start
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# Attach to a tmux session, if there's any (and only of we are running interactively)
if type -f tmux &> /dev/null && [[ $- = *i* ]] && [[ -z "$TMUX" ]] && pgrep -U `whoami` tmux; then
    tmux attach
fi

