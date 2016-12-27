# Use multithreaded archivers if possible
if (( $+commands[pigz] )); then
    function gzip () { command pigz $@ }
fi
if (( $+commands[unpigz] )); then
    function gunzip () { command unpigz $@ }
fi
if (( $+commands[pbzip2] )); then
    function bzip2 () { command pbzip2 $@ }
fi
if (( $+commands[pbunzip2] )); then
    function bunzip2 () { command pbunzip2 $@ }
fi

# Universal unarchive function
unarchive () {
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

# Universal archive function
archive () {
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
