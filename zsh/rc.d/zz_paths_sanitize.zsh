# Force path arrays to have unique values only
typeset -U path cdpath fpath manpath

# Reformat MANPATH into expected format, so it ends with colon
# Ghostty breaks it with own env var append logic
local mpath="" manpath_old=($manpath)
MANPATH=""
for mpath in $manpath_old; do
    printf -v MANPATH "%s%s:" $MANPATH $mpath
done
unset mpath manpath_old
