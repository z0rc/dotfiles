# Alias commands supported by grc
if (( ${+commands[grc]} )); then
    grc_commands=(blkid df dig dnf du env free gcc getfacl getsebool
                  ifconfig ip iptables last lsattr lsblk lsmod lspci
                  mount mtr netstat nmap ping ps pv semanage ss stat
                  sysctl systemctl tcpdump traceroute tune2fs ulimit
                  uptime vmstat wdiff)

    for grc_command in ${grc_commands[@]}; do
        if (( ${+commands[$grc_command]} )) && [[ -f "/usr/local/share/grc/conf.${grc_command}" || -f "/usr/share/grc/conf.${grc_command}" ]]; then
            if (( ${+aliases[$grc_command]} )); then
                alias ${grc_command}="grc --colour=auto $(whence -f ${grc_command})"
            else
                alias ${grc_command}="grc --colour=auto ${grc_command}"
            fi
        fi
    done

    for grc_command in w who; do
        if (( ${+commands[$grc_command]} )); then
            if (( ${+aliases[$grc_command]} )); then
                alias ${grc_command}="grc --colour=auto $(whence -f ${grc_command})"
            else
                alias ${grc_command}="grc --colour=auto ${grc_command}"
            fi
        fi
    done

    unset grc_commands grc_command
fi

# custom completion to allow completion for aliased commands
_grc () {
    setopt localoptions extended_glob
    local environ e cmd
    local -a args
    local -a _comp_priv_prefix
    zstyle -a ":completion:${curcontext}:" environ environ
    for e in "${environ[@]}"; do
        local -x "${e}"
    done
    cmd="${words[1]}"
    args=(
        '(-e --stderr)'{-e,--stderr}'[redirect stderr; do not automatically redirect stdout]'
        '(-s --stdout)'{-s,--stdout}'[redirect stdout; even with -e/--stderr]'
        '(-c <name>--config=<name>)'{-c+,--config=-}'[use <name> as configuration file for grcat]:file:_files'
        '--color=-[colo?urize output]:color:(on off auto)'
        '(-h --help)'{-h,--help}'[display help message and exit]'
        '--pty[run command in pseudotermnial (experimental)]'
        '*::arguments:{ _normal }'
    )
    _arguments -s -S $args
}
