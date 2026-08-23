# Include interactive rc files
for conffile in $ZDOTDIR/rc.d/*.zsh(N.); do
    source $conffile
done
unset conffile
