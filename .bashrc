_dotsh_bash_history() {
  # Append history, don't overwrite
  shopt -s histappend
  HISTCONTROL=ignoreboth
  HISTFILESIZE=10000
  HISTIGNORE="clear:history:[bf]g:exit:date:* --help"
  HISTSIZE=10000
  PROMPT_COMMAND="history -a; history -n"
}

_dotsh_bash_hooks() {
  local bash_completion="$HOME/.nix-profile/etc/profile.d/bash_completion.sh"
  [ ! -e "$bash_completion" ] || source "$bash_completion"
  ! command -v direnv >/dev/null || type _direnv_hook >/dev/null 2>&1 || \
    source <(direnv hook bash)
  ! command -v fzf >/dev/null || type fzf-file-widget >/dev/null 2>&1 || \
    source <(fzf --bash)
  ! command -v kubectl >/dev/null || type __start_kubectl >/dev/null 2>&1 || \
    source <(kubectl completion bash)
}

_dotsh_bash_prompt() {
  export _DOTSH_BASH_OLD_PS1_VAR=${_DOTSH_BASH_OLD_PS1_VAR:-$PS1}
  PS1="$_DOTSH_BASH_OLD_PS1_VAR"
  if command -v direnv >/dev/null; then
    local prompt_fn=dotsh_direnv_prompt_prefix
    if $prompt_fn >/dev/null && [[ ! $PS1 =~ $prompt_fn ]]; then
      export -f $prompt_fn
      PS1="\$($prompt_fn)$PS1"
    fi
  fi
}

# Use ./.shrc as a base for .bashrc
source "$DOTSH_SCRIPT_DIR/.shrc"
# Update LINES and COLUMNS after each command like zsh
shopt -s checkwinsize
# Enable matching '**' to zero or more directories
shopt -s globstar
_dotsh_bash_prompt
_dotsh_bash_history
_dotsh_bash_hooks
dotsh_unset_functions _dotsh_ "$DOTSH_SCRIPT_DIR/.bashrc"
