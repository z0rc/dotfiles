setopt HIST_IGNORE_ALL_DUPS # remove all earlier duplicate lines
setopt APPEND_HISTORY # history appends to existing file
setopt SHARE_HISTORY # import new commands from the history file also in other zsh-session
setopt EXTENDED_HISTORY # save each commands beginning timestamp and the duration to the history file
setopt HIST_REDUCE_BLANKS # trim multiple insgnificant blanks in history
setopt HIST_IGNORE_SPACE # don’t store lines starting with space
setopt EXTENDED_GLOB
setopt CORRECT_ALL
setopt NO_FLOW_CONTROL # disable stupid annoying keys
setopt MULTIOS # allows multiple input and output redirections
setopt AUTO_CD # if the command is directory and cannot be executed, perfort cd to this directory
setopt CLOBBER
setopt BRACE_CCL # allow brace character class list expansion
setopt NO_BEEP # do not beep on errors
setopt NO_NOMATCH # try to avoid the 'zsh: no matches found...'
setopt INTERACTIVE_COMMENTS # allow use of comments in interactive code
setopt AUTO_PARAM_SLASH
setopt LIST_TYPES
setopt HASH_LIST_ALL # whenever a command completion is attempted, make sure the entire command path is hashed first
setopt COMPLETE_IN_WORD # allow completion from within a word/phrase
setopt COMPLETE_ALIASES # keep completion for aliased commands
setopt ALWAYS_TO_END # move cursor to the end of a completed word
setopt LONG_LIST_JOBS # list jobs in the long format by default
setopt AUTO_RESUME # attempt to resume existing job before creating a new process
setopt NOTIFY # report status of background jobs immediately
