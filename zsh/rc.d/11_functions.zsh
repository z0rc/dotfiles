# List all directories leading up to a filename; this is useful to see
# if some permissions are blocking access to a file.
lspath () {
    local pathlist
    if [[ "${1}" = "${1##/}" ]]; then
        pathlist=(/ ${(s:/:)PWD} ${(s:/:)1})
    else
        pathlist=(/ ${(s:/:)1})
    fi
    local allpaths=()
    local filepath=${pathlist[0]}
    shift pathlist
    for i in ${pathlist[@]}; do
        allpaths=(${allpaths[@]} ${filepath})
        filepath="${filepath%/}/$i"
    done
    allpaths=(${allpaths[@]} ${filepath})
    ls -ld "${allpaths[@]}"
}

# Grep from ps output
psg () {
    if [[ -z "${1}" ]]; then
        echo "Please specify process search pattern"
        return 2
    fi
    local psaux=$(ps aux)
    local result
    if result=$(grep --color=always -i "[${1[1]}]${1#?}" <<< ${psaux}); then
        { echo ${${(f)psaux}[1]}; echo ${result}; } | less -FRX
    else
        echo "No process found matching pattern '${1}'"
        return 1
    fi
}

# Autoexpand "..." to "../.." and so on
dot () {
    if [[ ${LBUFFER} = *.. ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}
zle -N dot
bindkey . dot

# Print apt history
apt-history () {
    case "${1}" in
    install)
        if [[ -e /var/log/dpkg.log ]]; then
            zgrep --no-filename ' installed' "$(ls -rt /var/log/dpkg*)"
        else
            journalctl -t dpkg | grep ' installed'
        fi
        ;;
    upgrade|remove)
        if [[ -e /var/log/dpkg.log ]]; then
            zgrep --no-filename "${1}" "$(ls -rt /var/log/dpkg*)"
        else
            journalctl -t dpkg | grep "${1}"
        fi
        ;;
    *)
        echo "Parameters:"
        echo " install - Lists all packages that have been installed."
        echo " upgrade - Lists all packages that have been upgraded."
        echo " remove - Lists all packages that have been removed."
        ;;
    esac
}

# vpaste uploader
vpaste () {
    local uri="http://vpaste.net/"
    local out
    if [[ -f "${1}" ]]; then
        out=$(curl -s -F "text=<${1}" "${uri}?${2}")
    else
        out=$(curl -s -F 'text=<-' "${uri}?${1}")
    fi
    echo "${out}"
    if (( ${+commands[xclip]} )) && [[ ! -z "${DISPLAY}" ]]; then
        echo -n "${out}" | xclip -i -selection primary
        echo -n "${out}" | xclip -i -selection clipboard
    elif (( ${+commands[pbcopy]} )); then
        echo -n "${out}" | pbcopy
    fi
}

# fzf selector for cdr
fcd () {
    local selection
    # tr filters out slashes used for escaping spaces (and maybe something else?)
    # also we have to explicitly expand ~ into $HOME, as tilde works only in interactive mode
    selection=$(cdr -l | tr -d '\\' | fzf --no-multi --no-sort --with-nth=2..-1 --reverse --height 40% --preview 'pd={+2..-1}; ls -AFh --group-directories-first --color ${pd/#\~/$HOME}' --query="${1}" --select-1)
    # clean up beginning of selection and expand tilde
    cd "${selection/#[[:digit:]]##[[:blank:]]##~/$HOME}"
}

# git history browser with fzf
fgl () {
    git rev-parse --is-inside-work-tree &> /dev/null || return
    git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
    fzf --ansi --height 50% --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
        --header 'Press CTRL-S to toggle sort' \
        --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -200' |
    grep -o "[a-f0-9]\{7,\}"
}

# git branch selector with fzf
fgb () {
    git rev-parse --is-inside-work-tree &> /dev/null || return
    git branch --color=always | grep -v '/HEAD\s' | sort |
    fzf --ansi --height 50% --tac --preview-window right:70% \
        --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -200' |
    sed 's/^..//' | cut -d' ' -f1 | sed 's#^remotes/##'
}

# simple find shortener
fd () {
    if [[ ARGC -eq 1 ]]; then
        find . -iname "*${1}*"
    elif [[ ARGC -ge 2 ]]; then
        find . -iname "*${1}*" ${@[2,-1]}
    else
        find .
    fi
}
