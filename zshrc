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
	if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
		zstyle ':vcs_info:*' formats '[%b%c%u]'
	} else {
		zstyle ':vcs_info:*' formats '[%b%c%u¿]'
	}
	vcs_info
	psvar[2]="$vcs_info_msg_0_"
# Workaround precmd change by mc (part 2)
	fakeprecmd
}

# Fancy prompts
PROMPT="%1v[%{$fg[yellow]%}%B%m%b%{$reset_color%}][%{$fg[green]%}%B%~%b%{$reset_color%}]%2v%# "
[ "$MC_SID" ] && RPROMPT="" || RPROMPT="[%B%?%b] (%B%T - %D%b)"

# Exports
EDITOR=vim
VISUAL=$EDITOR
export VISUAL EDITOR
DEBEMAIL="z0rc3r@gmail.com"
DEBFULLNAME="Igor Urazov"
export DEBEMAIL DEBFULLNAME
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

# Universal archive unpack
extract () {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2) tar xjf $1    ;;
			*.tar.gz)  tar xzf $1    ;;
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
			tgz) tar czvf $2.tar.gz  $2   ;;
			tar) tar cpvf $2.tar  $2      ;;
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

# Make less more friendly for non-text input files
if [ -x /usr/bin/lesspipe ]; then
	export LESSOPEN="| /usr/bin/lesspipe %s"
	export LESSCLOSE="/usr/bin/lesspipe %s %s"
fi

# Enable color support of ls and grep
if [ -x /usr/bin/dircolors ]; then
	eval `dircolors -b`
	alias ls="ls --color=auto -F -X"
	alias dir="dir --color=auto"
	alias vdir="vdir --color=auto"
fi

# More colors
if [ -x /usr/bin/grc ]; then
	alias ping="grc --colour=auto ping"
	alias traceroute="grc --colour=auto traceroute"
	alias netstat="grc --colour=auto netstat"
fi
if [ -x /usr/bin/colordiff ]; then
	alias diff="colordiff -Naur"
fi

# Color man
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Human file sizes
alias df="df -Th"
alias du="du -hc"

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
	xhost + 2>&1 1>/dev/null
fi

# Workaround precmd change by mc (part 3)
alias precmd="noglob fakeprecmd"

# Highlighting plugin
source ~/.dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
