# Include interactive rc files
for conffile in "${ZDOTDIR}"/rc.d/*; do
    source "${conffile}"
done

unset conffile
