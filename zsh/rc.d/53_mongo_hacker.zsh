# Enable mongo-hacker without symlink in home
if [[ -f "${DOTFILES}/tools/mongo-hacker/mongo_hacker.js" ]] && (( ${+commands[mongo]} )); then
    mongo() { command mongo "${@}" --shell --norc "${DOTFILES}/tools/mongo-hacker/mongo_hacker.js"; }
fi
