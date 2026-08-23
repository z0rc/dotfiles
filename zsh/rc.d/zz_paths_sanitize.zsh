# Force path arrays to have unique values only
typeset -U path cdpath fpath manpath

# Reformat MANPATH into expected format, so it ends with colon
# Trailing colon is what makes man prepend this to its built-in defaults
# Ghostty breaks it with own env var append logic
MANPATH="${(j.:.)${(@)manpath:#}}:"
