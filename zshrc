# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=2000
setopt HIST_IGNORE_ALL_DUPS
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# Proper keyboard configuration
autoload zkbd
[[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd
[[ ! -f ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE} ]] && zkbd
source  ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE}
[[ -n "${key[Home]}"   ]] && bindkey "${key[Home]}"   beginning-of-line
[[ -n "${key[End]}"    ]] && bindkey "${key[End]}"    end-of-line
[[ -n "${key[Insert]}" ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n "${key[Delete]}" ]] && bindkey "${key[Delete]}" delete-char
[[ -n "${key[Up]}"     ]] && bindkey "${key[Up]}"     up-line-or-history
[[ -n "${key[Down]}"   ]] && bindkey "${key[Down]}"   down-line-or-history
[[ -n "${key[Left]}"   ]] && bindkey "${key[Left]}"   backward-char
[[ -n "${key[Right]}"  ]] && bindkey "${key[Right]}"  forward-char

# General configuration
setopt EXTENDED_GLOB
setopt CORRECT_ALL
setopt AUTO_CD
setopt CLOBBER
setopt BRACE_CCL
unsetopt BEEP
autoload -U colors && colors

# Completion basic
autoload -Uz compinit && compinit
setopt AUTO_PARAM_SLASH
setopt LIST_TYPES
setopt COMPLETE_IN_WORD

# URL magic
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# MIME aliases
autoload -U zsh-mime-setup
zsh-mime-setup

# Tweaking vcs_info before load
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr '§'
zstyle ':vcs_info:*' unstagedstr '±'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b:%r'
zstyle ':vcs_info:*' enable git svn bzr hg cvs

# Workaround precmd change by mc (part 1)
fakeprecmd () { }

# Prompts
precmd () {
# Indicate that shell is running under Midnight Commander
	[ "$MC_SID" ] && psvar[1]="[mc]" || psvar[1]=""
# Further vcs_info tweaks and actual loading
	if [ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]; then
		zstyle ':vcs_info:*' formats '[%b%c%u]'
	else
		zstyle ':vcs_info:*' formats '[%b%c%u¿]'
	fi
	vcs_info
	psvar[2]="$vcs_info_msg_0_"
# Workaround precmd change by mc (part 2)
	fakeprecmd
}

# Fancy prompts
[ "$SSH_CLIENT" ] && psvar[3]="[%{$fg[red]%}ssh%{$reset_color%}]"
PROMPT="%1v$psvar[3][%{$fg[yellow]%}%B%m%b%{$reset_color%}][%{$fg[green]%}%B%~%b%{$reset_color%}]%2v%# "
[ "$MC_SID" ] && RPROMPT="" || RPROMPT="[%B%(?..%{$fg[red]%})%?%{$reset_color%}%b] (%B%T - %D{%m.%d.%Y}%b)"

# Exports
EDITOR=vim
VISUAL=$EDITOR
export VISUAL EDITOR
export GREP_OPTIONS="--color=auto --binary-files=without-match --devices=skip"

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Additional completion rules
fpath=(~/.dotfiles/zsh-completions/src $fpath)

# List all directories leading up to a filename; this is useful to see
# if some permissions are blocking access to a file.
lspath () {
	if [ "$1" = "${1##/}" ]; then
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
	FST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
	RST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
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
if [ -x /usr/bin/pigz ]; then
	function gzip () { pigz $@ }
	export -f gzip > /dev/null
fi

if [ -x /usr/bin/pbzip2 ]; then
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
	if [ -f $1 ] ; then
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
	if [ $1 ] ; then
		case $1 in
			tbz) tar cjvf $2.tar.bz2 $2   ;;
			tgz) tar czvf $2.tar.gz $2    ;;
			txz) tar cJvf $2.tar.xz $2    ;;
			tar) tar cpvf $2.tar $2       ;;
			bz2) bzip2 $2                 ;;
			gz)  gzip -c -9 -n $2 > $2.gz ;;
			zip) zip -r $2.zip $2         ;;
			7z)  7z a $2.7z $2            ;;
			*)   echo "'$1' cannot be packed via pk()" ;;
		esac
	else
		echo "'$1' is not a valid file"
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
if [ -x /usr/bin/lesspipe ]; then
	export LESSOPEN="| /usr/bin/lesspipe %s"
	export LESSCLOSE="/usr/bin/lesspipe %s %s"
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
if [ -x /usr/bin/dircolors ]; then
	eval `dircolors -b`
	alias ls="ls --color=auto -F -X"
	alias dir="dir --color=auto"
	alias vdir="vdir --color=auto"
fi

# More colors
if [ -x /usr/bin/grc ]; then
	alias ping="grc --colour=on ping"
	alias traceroute="grc --colour=on traceroute"
	alias netstat="grc --colour=on netstat"
fi
if [ -x /usr/bin/colordiff ]; then
	alias diff="colordiff -Naur"
fi

# Colorize via pygmentize
colorize() {
	if [ ! -x $(which pygmentize) ]; then
		echo package \'pygmentize\' is not installed!
		exit -1
	fi
	
	if [ $# -eq 0 ]; then
		pygmentize -g $@
	fi
	
	for FNAME in $@; do
		filename=$(basename "$FNAME")
		lexer=`pygmentize -N \"$filename\"`
		if [ "Z$lexer" != "Ztext" ]; then
			pygmentize -l $lexer "$FNAME"
		else
			pygmentize -g "$FNAME"
		fi
	done
}

# Human file sizes
alias df="df -Th"
alias du="du -hc"

# Make spark availiable withoud adding it to PATH
alias spark="~/.dotfiles/spark/spark"

# Some handy suffix aliases
alias -s log=less

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
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=$color[cyan]=$color[red]"
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion::complete:*' use-cache true

# Allow root to use my DISPLAY
if [ -n "$DISPLAY" ]; then
	xhost +si:localuser:root 2>&1 1>/dev/null
fi

# Workaround precmd change by mc (part 3)
alias precmd="noglob fakeprecmd"

# Z (jump-list) plugin
source ~/.dotfiles/z/z.sh

# Highlighting plugin
source ~/.dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
