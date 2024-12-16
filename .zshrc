_dotsh_zsh_completion() {
  autoload -Uz compinit
  compinit
}

_dotsh_zsh_deps() {
  local site_functions="$HOME/.local/share/zsh/site-functions"
  local tmpdir
  [ -e "$site_functions" ] || mkdir -p "$site_functions"
  if [ ! -e "$site_functions/pure.zsh" ]; then
    tmpdir=$(mktemp -d 2>/dev/null || mktemp -d -t 'dotsh_zsh_deps_pure')
    tarball="$tmpdir/pure.tar.gz"
    (
      cd "$tmpdir" &&
      curl -sfLo "$tarball" \
        'https://github.com/sindresorhus/pure/archive/refs/tags/v1.23.0.tar.gz' && \
      echo "b316fe5aa25be2c2ef895dcad150248a43e12c4ac1476500e1539e2d67877921  $tarball" | \
      shasum -a 256 --check --status && \
      tar xf "$tarball" --strip-components=1 && \
      mv pure.zsh "$site_functions/prompt_pure_setup" && \
      mv async.zsh "$site_functions/async"
    ) || \
    >&2 echo 'ERROR: Failed to install zsh pure prompt'
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
}

_dotsh_zsh_prompt() {
  export _DOTSH_ZSH_OLD_PS1_VAR=${_DOTSH_ZSH_OLD_PS1_VAR:-$PS1}
  PS1="$_DOTSH_ZSH_OLD_PS1_VAR"
  if ! type -f promptinit >/dev/null 2>&1; then
    autoload -U promptinit; promptinit
  fi
  prompt pure
  # Below block is not needed due to using pure prompt
  # if command -v direnv >/dev/null; then
  #   local prompt_fn=dotsh_direnv_prompt_prefix
  #   if $prompt_fn >/dev/null && [[ ! $PS1 =~ $prompt_fn ]]; then
  #     setopt PROMPT_SUBST
  #     PS1="\$($prompt_fn)$PS1"
  #   fi
  # fi
}

# Use ./.shrc as a base for .zshrc
emulate sh -c "source \"$DOTSH_SCRIPT_DIR/.shrc\""
bindkey -e # Set emacs binding if not zsh defaults to vi based on EDITOR
_dotsh_zsh_deps
_dotsh_zsh_fpath
_dotsh_zsh_completion
_dotsh_zsh_prompt
_dotsh_zsh_history
_dotsh_zsh_hooks
dotsh_unset_functions _dotsh_ "$DOTSH_SCRIPT_DIR/.zshrc"
