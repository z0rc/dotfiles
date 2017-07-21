# Enable mysqltuner without installing it to the PATH
if (( ${+commands[perl]} )); then
    alias mysqltuner="${DOTFILES}/tools/MySQLTuner-perl/mysqltuner.pl"
fi
