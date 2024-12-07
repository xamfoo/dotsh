_dotsh_zsh_cleanup() {
  unset _dotsh_zsh_completion
  unset _dotsh_zsh_history
  unset _dotsh_zsh_hooks
  unset _dotsh_zsh_cleanup # self-destruct last
}

_dotsh_zsh_completion() {
  autoload -Uz compinit
  compinit
}

_dotsh_zsh_history() {
  HISTFILE="$HOME/.zsh_history"
  HISTSIZE=50000
  SAVEHIST=10000
  setopt extended_history       # record timestamp of command in HISTFILE
  setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
  setopt hist_ignore_dups       # ignore duplicated commands history list
  setopt hist_ignore_space      # ignore commands that start with space
  setopt hist_verify            # show command with history expansion to user before running it
  setopt share_history          # share command history data
}

_dotsh_zsh_hooks() {
  command -v direnv >/dev/null && source <(direnv hook zsh)
  command -v fzf >/dev/null && source <(fzf --zsh)
}

_dotsh_zsh_prompt() {
  command -v direnv >/dev/null || return 0
  setopt PROMPT_SUBST
  PS1='$(dotsh_direnv_prompt_prefix)'"$PS1"
}

# Use ./.shrc as a base for .zshrc
emulate sh -c "source \"$DOTSH_SCRIPT_DIR/.shrc\""
bindkey -e # Set emacs binding if not zsh defaults to vi based on EDITOR
# Nix did not add to fpath ~/.nix-profile/share/zsh/site-functions
# Maybe check home-manager docs?
fpath=("$HOME/.nix-profile/share/zsh/site-functions" $fpath)
_dotsh_zsh_completion
_dotsh_zsh_prompt
_dotsh_zsh_history
_dotsh_zsh_hooks
_dotsh_zsh_cleanup
