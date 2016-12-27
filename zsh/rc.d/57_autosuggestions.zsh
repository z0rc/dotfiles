# Autosuggestions plugin
source "$ZSHDIR/plugins/autosuggestions/zsh-autosuggestions.zsh"
# Hack to init zsh-asug only once
# https://github.com/zsh-users/zsh-autosuggestions/issues/136#issuecomment-196640897
_zsh_autosuggest_start () {
    add-zsh-hook -d precmd _zsh_autosuggest_start
    _zsh_autosuggest_check_deprecated_config
    _zsh_autosuggest_bind_widgets
}
