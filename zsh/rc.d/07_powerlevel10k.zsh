# Enable powerlevel10k prompt
source "${ZDOTDIR}/plugins/powerlevel10k/powerlevel10k.zsh-theme"

# Losely based on results from `p10k configure`

# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
    emulate -L zsh -o extended_glob

    # Unset all configuration options. This allows you to apply configuration changes without
    # restarting zsh. Edit ~/.p10k.zsh and type `source ~/.p10k.zsh`.
    unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

    # Configure left prompt
    typeset -ga POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
        midnight_commander
        nnn
        ranger
        vim_shell
        context
        dir
        vcs
        virtualenv
        pyenv
        goenv
        nodenv
        rbenv
        plenv
        luenv
        jenv
        terraform
        kubecontext
        aws
        status
        command_execution_time
        background_jobs
        newline
        prompt_char
    )

    # Disable right prompt
    typeset -g POWERLEVEL9K_DISABLE_RPROMPT=true

    # Defines character set used by powerlevel10k. It's best to let `p10k configure` set it for you.
    typeset -g POWERLEVEL9K_MODE=compatible
    # When set to `moderate`, some icons will have an extra space after them. This is meant to avoid
    # icon overlap when using non-monospace fonts. When set to `none`, spaces are not added.
    typeset -g POWERLEVEL9K_ICON_PADDING=none

    # Basic style options that define the overall look of your prompt. You probably don't want to
    # change them.
    typeset -g POWERLEVEL9K_BACKGROUND=                            # transparent background
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=  # no surrounding whitespace
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '  # separate segments with a space
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=        # no end-of-line symbol

    # When set to true, icons appear before content on both sides of the prompt. When set
    # to false, icons go after content. If empty or not set, icons go before content in the left
    # prompt and after content in the right prompt.
    #
    # You can also override it for a specific segment:
    #
    #   POWERLEVEL9K_STATUS_ICON_BEFORE_CONTENT=false
    #
    # Or for a specific segment in specific state:
    #
    #   POWERLEVEL9K_DIR_NOT_WRITABLE_ICON_BEFORE_CONTENT=false
    typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=true

    # Add an empty line before each prompt.
    typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
    # Disable ruler
    typeset -g POWERLEVEL9K_SHOW_RULER=false

    ################################[ prompt_char: prompt symbol ]################################
    # Green prompt symbol if the last command succeeded.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=76
    # Red prompt symbol if the last command failed.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=196
    # Default prompt symbol.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_{VIINS,VICMD,VIVIS,VIOWR}_CONTENT_EXPANSION='%#'
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
    # No line terminator if prompt_char is the last segment.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
    # No line introducer if prompt_char is the first segment.
    typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=

    ##################################[ dir: current directory ]##################################
    # Default current directory color.
    typeset -g POWERLEVEL9K_DIR_FOREGROUND=31
    # If directory is too long, shorten some of its segments to the shortest possible unique
    # prefix. The shortened directory can be tab-completed to the original.
    typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
    # Replace removed segment suffixes with this symbol.
    typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
    # Color of the shortened directory segments.
    typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=103
    # Color of the anchor directory segments. Anchor segments are never shortened. The first
    # segment is always an anchor.
    typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=39
    # Display anchor directory segments in bold.
    typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
    # Don't shorten directories that contain any of these files. They are anchors.
    local anchor_files=(
        .bzr
        .citc
        .git
        .hg
        .node-version
        .python-version
        .go-version
        .ruby-version
        .lua-version
        .java-version
        .perl-version
        .php-version
        .tool-version
        .shorten_folder_marker
        .svn
        .terraform
        CVS
        Cargo.toml
        composer.json
        go.mod
        package.json
        stack.yaml
    )
    typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER="(${(j:|:)anchor_files})"
    # If set to "first" ("last"), remove everything before the first (last) subdirectory that contains
    # files matching $POWERLEVEL9K_SHORTEN_FOLDER_MARKER. For example, when the current directory is
    # /foo/bar/git_repo/nested_git_repo/baz, prompt will display git_repo/nested_git_repo/baz (first)
    # or nested_git_repo/baz (last). This assumes that git_repo and nested_git_repo contain markers
    # and other directories don't.
    #
    # Optionally, "first" and "last" can be followed by ":<offset>" where <offset> is an integer.
    # This moves the truncation point to the right (positive offset) or to the left (negative offset)
    # relative to the marker. Plain "first" and "last" are equivalent to "first:0" and "last:0"
    # respectively.
    typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=false
    # Don't shorten this many last directory segments. They are anchors.
    typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
    # Shorten directory if it's longer than this even if there is space for it. The value can
    # be either absolute (e.g., '80') or a percentage of terminal width (e.g, '50%'). If empty,
    # directory will be shortened only when prompt doesn't fit or when other parameters demand it
    # (see POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS and POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT below).
    # If set to `0`, directory will always be shortened to its minimum length.
    typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80
    # When `dir` segment is on the last prompt line, try to shorten it enough to leave at least this
    # many columns for typing commands.
    typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
    # When `dir` segment is on the last prompt line, try to shorten it enough to leave at least
    # COLUMNS * POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT * 0.01 columns for typing commands.
    typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50
    # If set to true, embed a hyperlink into the directory. Useful for quickly
    # opening a directory in the file manager simply by clicking the link.
    # Can also be handy when the directory is shortened, as it allows you to see
    # the full directory that was used in previous commands.
    typeset -g POWERLEVEL9K_DIR_HYPERLINK=false

    # Enable special styling for non-writable and non-existent directories. See POWERLEVEL9K_LOCK_ICON
    # and POWERLEVEL9K_DIR_CLASSES below.
    typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3

    # The default icon shown next to non-writable and non-existent directories when
    # POWERLEVEL9K_DIR_SHOW_WRITABLE is set to v3.
    typeset -g POWERLEVEL9K_LOCK_ICON='#'

    # Override default ETC_ICON as unicode cog symbol doesn't render properly with current font.
    typeset -g POWERLEVEL9K_ETC_ICON=

    #####################################[ vcs: git status ]######################################
    # Branch icon. Set this parameter to '\uF126 ' for the popular Powerline branch icon.
    typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=

    # Untracked files icon. It's really a question mark, your font isn't broken.
    # Change the value of this parameter to show a different icon.
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

    # Formatter for Git status.
    #
    # Example output: master ⇣42⇡42 *42 merge ~42 +42 !42 ?42.
    #
    # You can edit the function to customize how Git status looks.
    #
    # VCS_STATUS_* parameters are set by gitstatus plugin. See reference:
    # https://github.com/romkatv/gitstatus/blob/master/gitstatus.plugin.zsh.
    function my_git_formatter() {
        emulate -L zsh

        if [[ -n $P9K_CONTENT ]]; then
            # If P9K_CONTENT is not empty, use it. It's either "loading" or from vcs_info (not from
            # gitstatus plugin). VCS_STATUS_* parameters are not available in this case.
            typeset -g my_git_format=$P9K_CONTENT
            return
        fi

        if (( $1 )); then
            # Styling for up-to-date Git status.
            local       meta='%f'     # default foreground
            local      clean='%76F'   # green foreground
            local   modified='%178F'  # yellow foreground
            local  untracked='%39F'   # blue foreground
            local conflicted='%196F'  # red foreground
        else
            # Styling for incomplete and stale Git status.
            local       meta='%244F'  # grey foreground
            local      clean='%244F'  # grey foreground
            local   modified='%244F'  # grey foreground
            local  untracked='%244F'  # grey foreground
            local conflicted='%244F'  # grey foreground
        fi

        local res

        if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
            local branch=${(V)VCS_STATUS_LOCAL_BRANCH}
            # If local branch name is at most 32 characters long, show it in full.
            # Otherwise show the first 12 … the last 12.
            # Tip: To always show local branch name in full without truncation, delete the next line.
            (( $#branch > 32 )) && branch[13,-13]="…"  # <-- this line
            res+="${clean}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${branch//\%/%%}"
        fi

        if [[ -n $VCS_STATUS_TAG
              # Show tag only if not on a branch.
              # Tip: To always show tag, delete the next line.
              && -z $VCS_STATUS_LOCAL_BRANCH  # <-- this line
        ]]; then
            local tag=${(V)VCS_STATUS_TAG}
            # If tag name is at most 32 characters long, show it in full.
            # Otherwise show the first 12 … the last 12.
            # Tip: To always show tag name in full without truncation, delete the next line.
            (( $#tag > 32 )) && tag[13,-13]="…"  # <-- this line
            res+="${meta}#${clean}${tag//\%/%%}"
        fi

        # Display the current Git commit if there is no branch and no tag.
        # Tip: To always display the current Git commit, delete the next line.
        [[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] &&  # <-- this line
        res+="${meta}@${clean}${VCS_STATUS_COMMIT[1,8]}"

        # Show tracking branch name if it differs from local branch.
        if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
            res+="${meta}:${clean}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"
        fi

        # ⇣42 if behind the remote.
        (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}"
        # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
        (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
        (( VCS_STATUS_COMMITS_AHEAD  )) && res+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"
        # ⇠42 if behind the push remote.
        (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" ${clean}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
        (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" "
        # ⇢42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42.
        (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && res+="${clean}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
        # *42 if have stashes.
        (( VCS_STATUS_STASHES        )) && res+=" ${clean}*${VCS_STATUS_STASHES}"
        # 'merge' if the repo is in an unusual state.
        [[ -n $VCS_STATUS_ACTION     ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}"
        # ~42 if have merge conflicts.
        (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"
        # +42 if have staged changes.
        (( VCS_STATUS_NUM_STAGED     )) && res+=" ${modified}+${VCS_STATUS_NUM_STAGED}"
        # !42 if have unstaged changes.
        (( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
        # ?42 if have untracked files. It's really a question mark, your font isn't broken.
        # See POWERLEVEL9K_VCS_UNTRACKED_ICON above if you want to use a different icon.
        # Remove the next line if you don't want to see untracked files at all.
        (( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}"
        # "─" if the number of unstaged files is unknown. This can happen due to
        # POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY (see below) being set to a non-negative number lower
        # than the number of files in the Git index, or due to bash.showDirtyState being set to false
        # in the repository config. The number of staged and untracked files may also be unknown
        # in this case.
        (( VCS_STATUS_HAS_UNSTAGED == -1 )) && res+=" ${modified}─"

        typeset -g my_git_format=$res
    }
    functions -M my_git_formatter 2>/dev/null

    # Don't count the number of unstaged, untracked and conflicted files in Git repositories with
    # more than this many files in the index. Negative value means infinity.
    #
    # If you are working in Git repositories with tens of millions of files and seeing performance
    # sagging, try setting POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY to a number lower than the output
    # of `git ls-files | wc -l`. Alternatively, add `bash.showDirtyState = false` to the repository's
    # config: `git config bash.showDirtyState false`.
    typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1

    # Don't show Git status in prompt for repositories whose workdir matches this pattern.
    # For example, if set to '~', the Git repository at $HOME/.git will be ignored.
    # Multiple patterns can be combined with '|': '~(|/foo)|/bar/baz/*'.
    typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'

    # Disable the default Git status formatting.
    typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
    # Install our own Git status formatter.
    typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter(1)))+${my_git_format}}'
    typeset -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION='${$((my_git_formatter(0)))+${my_git_format}}'
    # Enable counters for staged, unstaged, etc.
    typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1

    # Icon color.
    typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR=76
    typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR=244
    # Custom icon.
    typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=
    # Custom prefix.
    # typeset -g POWERLEVEL9K_VCS_PREFIX='%fon '

    # Show status of repositories of these types. You can add svn and/or hg if you are
    # using them. If you do, your prompt may become slow even when your current directory
    # isn't in an svn or hg reposotiry.
    typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)

    # These settings are used for repositories other than Git or when gitstatusd fails and
    # Powerlevel10k has to fall back to using vcs_info.
    typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=76
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=76
    typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=178

    ##########################[ status: exit code of the last command ]###########################
    # Enable OK_PIPE, ERROR_PIPE and ERROR_SIGNAL status states to allow us to enable, disable and
    # style them independently from the regular OK and ERROR state.
    typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true

    # Status on success. No content, just an icon. No need to show it if prompt_char is enabled as
    # it will signify success by turning green.
    typeset -g POWERLEVEL9K_STATUS_OK=false
    typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=70
    typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='√'

    # Status when some part of a pipe command fails but the overall exit status is zero. It may look
    # like this: 1|0.
    typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
    typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=70
    typeset -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION='√'

    # Status when it's just an error code (e.g., '1'). No need to show it if prompt_char is enabled as
    # it will signify error by turning red.
    typeset -g POWERLEVEL9K_STATUS_ERROR=false
    typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=160
    typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='x'

    # Status when the last command was terminated by a signal.
    typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
    typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=160
    # Use terse signal names: "INT" instead of "SIGINT(2)".
    typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=true

    # Status when some part of a pipe command fails and the overall exit status is also non-zero.
    # It may look like this: 1|0.
    typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
    typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=160
    typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION='х'

    ###################[ command_execution_time: duration of the last command ]###################
    # Show duration of the last command if takes at least this many seconds.
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
    # Show this many fractional digits. Zero means round to seconds.
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
    # Execution time color.
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=101
    # Duration format: 1d 2h 3m 4s.
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
    # Custom icon.
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION=
    # Custom prefix.
    # typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX='%ftook '

    #######################[ background_jobs: presence of background jobs ]#######################
    # Don't show the number of background jobs.
    typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
    # Background jobs color.
    typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=70
    # Custom icon.
    typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION='≡'

    #################[ ranger: ranger shell (https://github.com/ranger/ranger) ]##################
    # Ranger shell color.
    typeset -g POWERLEVEL9K_RANGER_FOREGROUND=081
    # Custom icon.
    typeset -g POWERLEVEL9K_RANGER_VISUAL_IDENTIFIER_EXPANSION='rngr'

    ######################[ nnn: nnn shell (https://github.com/jarun/nnn) ]#######################
    # Nnn shell color.
    typeset -g POWERLEVEL9K_NNN_FOREGROUND=72
    # Custom icon.
    typeset -g POWERLEVEL9K_NNN_VISUAL_IDENTIFIER_EXPANSION='nnn'

    ###########################[ vim_shell: vim shell indicator (:sh) ]###########################
    # Vim shell indicator color.
    typeset -g POWERLEVEL9K_VIM_SHELL_FOREGROUND=28
    # Custom icon.
    typeset -g POWERLEVEL9K_VIM_SHELL_VISUAL_IDENTIFIER_EXPANSION='vim'

    ######[ midnight_commander: midnight commander shell (https://midnight-commander.org/) ]######
    # Midnight Commander shell color.
    typeset -g POWERLEVEL9K_MIDNIGHT_COMMANDER_FOREGROUND=230
    # Custom icon.
    typeset -g POWERLEVEL9K_MIDNIGHT_COMMANDER_VISUAL_IDENTIFIER_EXPANSION='mc'

    ##################################[ context: user@hostname ]##################################
    # Context color when running with privileges.
    typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=178
    # Context color in SSH without privileges.
    typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND=180
    # Default context color (no privileges, no SSH).
    typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=180

    # Context format when running with privileges: bold user@hostname.
    typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%B%n@%m'
    # Context format when in SSH without privileges: user@hostname.
    typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_TEMPLATE='%n@%m'
    # Default context format (no privileges, no SSH): user@hostname.
    typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'

    # Don't show context unless running with privileges or in SSH.
    # Tip: Remove the next line to always show context.
    typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=

    # Custom icon.
    # typeset -g POWERLEVEL9K_CONTEXT_VISUAL_IDENTIFIER_EXPANSION='⭐'
    # Custom prefix.
    # typeset -g POWERLEVEL9K_CONTEXT_PREFIX='%fwith '

    ###[ virtualenv: python virtual environment (https://docs.python.org/3/library/venv.html) ]###
    # Python virtual environment color.
    typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=37
    # Don't show Python version next to the virtual environment name.
    typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
    # If set to "false", won't show virtualenv if pyenv is already shown.
    # If set to "if-different", won't show virtualenv if it's the same as pyenv.
    typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV='if-different'
    # Separate environment name from Python version only with a space.
    typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=
    # Custom icon.
    # typeset -g POWERLEVEL9K_VIRTUALENV_VISUAL_IDENTIFIER_EXPANSION='⭐'

    ######################[ pyenv, rbenv, goenv, nodenv,plenv,luaenv,jenv ]#######################
    typeset -g POWERLEVEL9K_{PYENV,RBENV,GOENV,NODENV,PLENV,LUAENV,JENV}_FOREGROUND=37
    typeset -g POWERLEVEL9K_{PYENV,RBENV,GOENV,NODENV,PLENV,LUAENV,JENV}_PROMPT_ALWAYS_SHOW=false

    # Pyenv segment format. The following parameters are available within the expansion.
    #
    # - P9K_CONTENT                Current pyenv environment (pyenv version-name).
    # - P9K_PYENV_PYTHON_VERSION   Current python version (python --version).
    #
    # The default format has the following logic:
    #
    # 1. Display "$P9K_CONTENT $P9K_PYENV_PYTHON_VERSION" if $P9K_PYENV_PYTHON_VERSION is not
    #   empty and unequal to $P9K_CONTENT.
    # 2. Otherwise display just "$P9K_CONTENT".
    typeset -g POWERLEVEL9K_PYENV_CONTENT_EXPANSION='${P9K_CONTENT}${${P9K_PYENV_PYTHON_VERSION:#$P9K_CONTENT}:+ $P9K_PYENV_PYTHON_VERSION}'

    #############[ kubecontext: current kubernetes context (https://kubernetes.io/) ]#############
    # Show kubecontext only when the the command you are typing invokes one of these tools.
    # Tip: Remove the next line to always show kubecontext.
    typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito|k9s|helmfile|fluxctl|stern'

    ################[ terraform: terraform workspace (https://www.terraform.io) ]#################
    # Don't show terraform workspace if it's literally "default".
    typeset -g POWERLEVEL9K_TERRAFORM_SHOW_DEFAULT=false
    typeset -g POWERLEVEL9K_TERRAFORM_SHOW_ON_COMMAND='terraform|make'

    #[ aws: aws profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) ]#
    # Show aws only when the the command you are typing invokes one of these tools.
    typeset -g POWERLEVEL9K_AWS_SHOW_ON_COMMAND='aws|awless|terraform|pulumi|terragrunt|make'
    typeset -g POWERLEVEL9K_AWS_FOREGROUND=208

    # Transient prompt works similarly to the builtin transient_rprompt option. It trims down prompt
    # when accepting a command line. Supported values:
    #
    #   - off:      Don't change prompt when accepting a command line.
    #   - always:   Trim down prompt when accepting a command line.
    #   - same-dir: Trim down prompt when accepting a command line unless this is the first command
    #               typed after changing current working directory.
    typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=same-dir

    # Instant prompt mode.
    #
    #   - off:     Disable instant prompt. Choose this if you've tried instant prompt and found
    #              it incompatible with your zsh configuration files.
    #   - quiet:   Enable instant prompt and don't print warnings when detecting console output
    #              during zsh initialization. Choose this if you've read and understood
    #              https://github.com/romkatv/powerlevel10k/blob/master/README.md#instant-prompt.
    #   - verbose: Enable instant prompt and print a warning when detecting console output during
    #              zsh initialization. Choose this if you've never tried instant prompt, haven't
    #              seen the warning, or if you are unsure what this all means.
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

    # Hot reload allows you to change POWERLEVEL9K options after Powerlevel10k has been initialized.
    # For example, you can type POWERLEVEL9K_BACKGROUND=red and see your prompt turn red. Hot reload
    # can slow down prompt by 1-2 milliseconds, so it's better to keep it turned off unless you
    # really need it.
    typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true
}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
