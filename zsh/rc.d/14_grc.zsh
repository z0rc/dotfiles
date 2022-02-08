# Alias commands supported by grc
if (( ${+commands[grc]} )); then
    () {
        local grc_commands=(blkid df dig dnf du env free gcc getfacl getsebool
                            ifconfig ip iptables last lsattr lsblk lsmod lspci
                            mount mtr netstat nmap ping ps pv semanage ss stat
                            sysctl systemctl tcpdump traceroute tune2fs ulimit
                            uptime vmstat w wdiff who)
        local grc_command

        for grc_command in ${grc_commands[@]}; do
            if (( ${+commands[$grc_command]} )); then
                $grc_command() {
                    grc --colour=auto ${commands[$0]} "${@}"
                }
            fi
        done
    }
fi
