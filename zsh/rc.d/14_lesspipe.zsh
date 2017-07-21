# Make less more friendly
for lpipe in lesspipe lesspipe.sh; do
    if (( ${+commands[$lpipe]} )); then
        export LESSOPEN="| ${lpipe} %s"
        export LESSCLOSE="${lpipe} %s %s"
        export LESS_ADVANCED_PREPROCESSOR=1
    fi
done

unset lpipe
