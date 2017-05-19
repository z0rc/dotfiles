# Alias commands supported by grc
if (( ${+commands[grc]} )); then
    grc_commands=(blkid df dig dnf du env free gcc getfacl getsebool
                  ifconfig ip iptables last lsattr lsblk lsmod lspci
                  mount mtr netstat nmap ping ps pv semanage ss stat
                  sysctl systemctl tcpdump traceroute tune2fs ulimit
                  uptime vmstat wdiff)

    for grc_command in ${grc_commands[@]}; do
        if (( ${+commands[$grc_command]} )) && [[ -f "/usr/local/share/grc/conf.${grc_command}" ]] || [[ -f "/usr/share/grc/conf.${grc_command}" ]]; then
            alias ${grc_command}="grc --color=auto ${grc_command}"
        fi
    done

    for grc_command in make w who; do
        if (( ${+commands[$grc_command]} )); then
            alias ${grc_command}="grc --color=auto ${grc_command}"
        fi
    done

    unset grc_commands grc_command
fi
