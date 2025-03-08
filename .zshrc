_dotsh_zsh_completion() {
  autoload -Uz compinit
  compinit
}

_dotsh_zsh_deps() {
  local p10k_path="$HOME/.local/opt/powerlevel10k/current"
  if [ ! -e "$p10k_path" ]; then
    mkdir -p "$(basename "$p10k_path")" && \
      git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
      "$p10k_path"
  fi
}

_dotsh_zsh_fpath() {
  export _DOTSH_ZSH_OLD_FPATH_VAR=(${_DOTSH_ZSH_OLD_FPATH_VAR:-$fpath})
  fpath=("$HOME/.local/share/zsh/site-functions"
         "$HOME/.nix-profile/share/zsh/site-functions"
         $_DOTSH_ZSH_OLD_FPATH_VAR)
}

_dotsh_zsh_history() {
  HISTFILE="$HOME/.zsh_history"
  HISTSIZE=10000
  SAVEHIST=10000
  setopt extended_history       # record timestamp of command in HISTFILE
  setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
  setopt hist_ignore_dups       # ignore duplicated commands history list
  setopt hist_ignore_space      # ignore commands that start with space
  setopt hist_verify            # show command with history expansion to user before running it
  setopt share_history          # share command history data
}

_dotsh_zsh_hooks() {
  ! command -v direnv >/dev/null || type _direnv_hook >/dev/null 2>&1 || \
    source <(direnv hook zsh)
  ! command -v fzf >/dev/null || type fzf-file-widget >/dev/null 2>&1 || \
    source <(fzf --zsh)
  ! command -v kubectl >/dev/null || type _kubectl >/dev/null 2>&1 || \
    source <(kubectl completion zsh)
  ! command -v brew >/dev/null || source <(brew shellenv)
}

_dotsh_zsh_prompt() {
  export _DOTSH_ZSH_OLD_PS1_VAR=${_DOTSH_ZSH_OLD_PS1_VAR:-$PS1}
  PS1="$_DOTSH_ZSH_OLD_PS1_VAR"
  local p10kinstant="${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  local p10ktheme="$HOME/.local/opt/powerlevel10k/current/powerlevel10k.zsh-theme"
  local p10kconfig="$DOTSH_SCRIPT_DIR/.p10k.zsh"
  # Powerlevel10k instant prompt should be loaded as early as possible.
  [ ! -e "$p10kinstant" ] || source "$p10kinstant"
  [ ! -e "$p10ktheme" ] || source "$p10ktheme"
  [ ! -e "$p10kconfig" ] || source "$p10kconfig"
  # This block is not needed when using a batteries-included prompt {
  # if ! type -f promptinit >/dev/null 2>&1; then
  #   autoload -U promptinit; promptinit
  # fi
  # if command -v direnv >/dev/null; then
  #   local prompt_fn=dotsh_direnv_prompt_prefix
  #   if $prompt_fn >/dev/null && [[ ! $PS1 =~ $prompt_fn ]]; then
  #     setopt PROMPT_SUBST
  #     PS1="\$($prompt_fn)$PS1"
  #   fi
  # fi
  # }
}

# Use ./.shrc as a base for .zshrc
emulate sh -c "source \"$DOTSH_SCRIPT_DIR/.shrc\""
bindkey -e # Set emacs binding if not zsh defaults to vi based on EDITOR
_dotsh_zsh_deps
_dotsh_zsh_fpath
_dotsh_zsh_prompt
_dotsh_zsh_completion
_dotsh_zsh_history
_dotsh_zsh_hooks
dotsh_unset_functions _dotsh_ "$DOTSH_SCRIPT_DIR/.zshrc"
