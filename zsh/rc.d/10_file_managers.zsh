if (( ${+commands[ranger]} )); then
    alias rr=ranger

    ranger () {
        if [[ -v RANGER_LEVEL ]]; then
            exit
        fi

        local ranger_pwd_file=$(mktemp -t ranger_pwd.XXXXXXXXXX)

        command ranger --choosedir=$ranger_pwd_file $@

        if [[ -r $ranger_pwd_file ]]; then
            local ranger_last_pwd=$(<$ranger_pwd_file)
            if [[ -d $ranger_last_pwd && $ranger_last_pwd != $PWD ]]; then
                cd $ranger_last_pwd
            fi
            zf_rm -f $ranger_pwd_file
        fi
    }

    # Change ranger CWD to PWD on subshell exit
    if [[ -v RANGER_LEVEL ]]; then
        _ranger_cd () {
            print "cd $PWD" > $XDG_RUNTIME_DIR/ranger-ipc.$PPID
        }
        add-zsh-hook zshexit _ranger_cd
    fi
fi

if (( ${+commands[yazi]} )); then
    alias yy=yazi

    yazi () {
        if [[ -v YAZI_LEVEL ]]; then
            exit
        fi

        local yazi_cwd_file=$(mktemp -t yazi_cwd.XXXXXXXXXX)

        command yazi --cwd-file=$yazi_cwd_file $@

        if [[ -r $yazi_cwd_file ]]; then
            local yazi_last_cwd=$(<$yazi_cwd_file)
            if [[ -d $yazi_last_cwd && $yazi_last_cwd != $PWD ]]; then
                cd $yazi_last_cwd
            fi
            zf_rm -f $yazi_cwd_file
        fi
    }

    # Change yazi CWD to PWD on subshell exit
    if [[ -v YAZI_ID ]]; then
        _yazi_cd () {
            ya emit cd $PWD
        }
        add-zsh-hook zshexit _yazi_cd
    fi
fi
