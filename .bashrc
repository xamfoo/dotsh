_dotsh_bash_cleanup() {
  unset _dotsh_bash_history
  unset _dotsh_bash_hooks
  unset _dotsh_bash_prompt
  unset _dotsh_bash_cleanup # self-destruct last
}

_dotsh_bash_history() {
  # Append history, don't overwrite
  shopt -s histappend
  HISTCONTROL=ignoreboth
  HISTFILESIZE=50000
  HISTIGNORE="clear:history:[bf]g:exit:date:* --help"
  HISTSIZE=50000
  PROMPT_COMMAND="history -a; history -n"
}

_dotsh_bash_hooks() {
  command -v direnv >/dev/null && eval "$(direnv hook bash)"
  command -v fzf >/dev/null && eval "$(fzf --bash)"
  command -v nnn >/dev/null && \
    [ -e "$HOME/.nix-profile/share/bash-completion/completions/nnn.bash" ] && \
    source "$HOME/.nix-profile/share/bash-completion/completions/nnn.bash"
  if ! type '__start_kubectl' 2>/dev/null; then
    command -v kubectl /dev/null && source <(kubectl completion bash)
  fi
}

_dotsh_bash_prompt() {
  command -v direnv >/dev/null || return 0
  export -f dotsh_direnv_prompt_prefix
  PS1='$(dotsh_direnv_prompt_prefix)'"$PS1"
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
_dotsh_bash_cleanup
