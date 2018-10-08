# pipsi wrapper that adds upgrade-all command
if (( ${+commands[pipsi]} )); then
    pipsi() {
        case "$1" in
            upgrade-all)
                command pipsi list | grep -oP 'Package "\K[\w-]+' | xargs -n 1 pipsi upgrade
                ;;
            *)
                command pipsi "$@"
                ;;
        esac
    }
fi
