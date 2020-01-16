# Enable powerlevel10k prompt
source "${ZDOTDIR}/plugins/powerlevel10k/powerlevel10k.zsh-theme"

# Losely based on results from `p10k configure`

# Temporarily change options
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
    emulate -L zsh
    setopt no_unset extended_glob

    unset -m 'POWERLEVEL9K_*'

    # Load env wrapper indicator
    typeset -g POWERLEVEL9K_CUSTOM_MANY_ENV="_p10k_indicate_env"
    typeset -g POWERLEVEL9K_CUSTOM_MANY_ENV_FOREGROUND="green"
    typeset -g POWERLEVEL9K_CUSTOM_MANY_ENV_BACKGROUND=none

    # Configure left prompt
    typeset -ga POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
        midnight_commander
        nnn
        ranger
        vim_shell
        context
        dir_writable
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

    typeset -g POWERLEVEL9K_BACKGROUND=                            # transparent background
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=  # no surrounding whitespace
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '  # separate segments with a space
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=        # no end-of-line symbol

    typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=76
    typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=196
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_{VIINS,VICMD,VIVIS,VIOWR}_CONTENT_EXPANSION='%#'
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
    typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''

    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
    typeset -g POWERLEVEL9K_WHITESPACE_BETWEEN_{LEFT,RIGHT}_SEGMENTS=

    typeset -g POWERLEVEL9K_DIR_{ETC,DEFAULT}_FOREGROUND=209
    typeset -g POWERLEVEL9K_DIR_{HOME,HOME_SUBFOLDER}_FOREGROUND=039
    typeset -g POWERLEVEL9K_{ETC,FOLDER,HOME,HOME_SUB}_ICON=
    typeset -g POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_VISUAL_IDENTIFIER_COLOR=003
    typeset -g POWERLEVEL9K_LOCK_ICON='#'

    #####################################[ vcs: git status ]######################################
    # Branch icon.
    typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=
    POWERLEVEL9K_VCS_BRANCH_ICON=${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}

    # Untracked files icon.
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
    POWERLEVEL9K_VCS_UNTRACKED_ICON=${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}

    # Formatter for Git status.
    #
    # Example output: master ⇣42⇡42 *42 merge ~42 +42 !42 ?42.
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
        local where  # branch or tag
        if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
            res+="${clean}${POWERLEVEL9K_VCS_BRANCH_ICON}"
            where=${(V)VCS_STATUS_LOCAL_BRANCH}
        elif [[ -n $VCS_STATUS_TAG ]]; then
            res+="${meta}#"
            where=${(V)VCS_STATUS_TAG}
        fi

        # If local branch name or tag is at most 32 characters long, show it in full.
        # Otherwise show the first 12 … the last 12.
        (( $#where > 32 )) && where[13,-13]="…"
        res+="${clean}${where//\%/%%}"  # escape %

        # Display the current Git commit if there is no branch or tag.
        [[ -z $where ]] && res+="${meta}@${clean}${VCS_STATUS_COMMIT[1,8]}"

        # Show tracking branch name if it differs from local branch.
        if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
            res+="${meta}:${clean}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"  # escape %
        fi

        # Show the git commit
        # res+=" (${VCS_STATUS_COMMIT:0:5})"

        # ⇣42 if behind the remote.
        (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}"
        # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
        (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
        (( VCS_STATUS_COMMITS_AHEAD  )) && res+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"
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
        # ?42 if have untracked files.
        (( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}${POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}"

        typeset -g my_git_format=$res
    }
    functions -M my_git_formatter 2>/dev/null

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

    # Show status of repositories of these types. You can add svn and/or hg if you are
    # using them. If you do, your prompt may become slow even when your current directory
    # isn't in an svn or hg reposotiry.
    typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)

    # These settings are used for respositories other than Git or when gitstatusd fails and
    # Powerlevel10k has to fall back to using vcs_info.
    typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=76
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=76
    typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=178
    ##############################################################################################

    typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
    typeset -g POWERLEVEL9K_STATUS_OK=false
    typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
    typeset -g POWERLEVEL9K_STATUS_ERROR=false
    typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=009
    typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
    typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=009
    typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=true
    typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
    typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=009
    typeset -g POWERLEVEL9K_CARRIAGE_RETURN_ICON=

    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=101
    typeset -g POWERLEVEL9K_EXECUTION_TIME_ICON=

    typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
    typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_COLOR=002
    typeset -g POWERLEVEL9K_BACKGROUND_JOBS_ICON='☰'

    typeset -g POWERLEVEL9K_VIM_SHELL_FOREGROUND=028
    typeset -g POWERLEVEL9K_MIDNIGHT_COMMANDER_FOREGROUND=230
    typeset -g POWERLEVEL9K_RANGER_FOREGROUND=081
    typeset -g POWERLEVEL9K_RANGER_VISUAL_IDENTIFIER_EXPANSION='rngr'

    typeset -g POWERLEVEL9K_{VIRTUALENV,ANACONDA}_FOREGROUND=37
    typeset -g POWERLEVEL9K_{VIRTUALENV,ANACONDA}_SHOW_PYTHON_VERSION=false
    typeset -g POWERLEVEL9K_{VIRTUALENV,ANACONDA}_{LEFT,RIGHT}_DELIMITER=

    typeset -g POWERLEVEL9K_{PYENV,RBENV,GOENV,NODENV,PLENV,LUAENV,JENV}_FOREGROUND=37
    typeset -g POWERLEVEL9K_{PYENV,RBENV,GOENV,NODENV,PLENV,LUAENV,JENV}_PROMPT_ALWAYS_SHOW=false

    typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,REMOTE_SUDO,REMOTE,SUDO}_FOREGROUND=244
    typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=011
    typeset -g POWERLEVEL9K_CONTEXT_ROOT_CONTENT_EXPANSION='%7F%n%f%242F@%m%f'
    typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_CONTENT_EXPANSION='%242F%n@%m%f'
    typeset -g POWERLEVEL9K_CONTEXT_CONTENT_EXPANSION=
    typeset -g POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true

    typeset -g POWERLEVEL9K_AWS_FOREGROUND=208
    typeset -g POWERLEVEL9K_AWS_SHOW_ON_COMMAND='aws|awless|terraform|pulumi'

    typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|hemlfile|kubens|kubectx'

    typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
    typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true
}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
