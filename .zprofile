# Detect script directory in case it is not $HOME i.e. in a git project
DOTSH_SCRIPT_DIR="$0:a:h"
[ -e "$DOTSH_SCRIPT_DIR/.zprofile" ] || DOTSH_SCRIPT_DIR="$HOME"

# Use ./.profile as a base for .zprofile,
# then ensures zsh sources ./.zshrc, not ./.shrc.
[ ! -v ENV ] || DOTSH_ENV="$ENV"
emulate sh -c "source \"$DOTSH_SCRIPT_DIR/.profile\""
[ -v DOTSH_ENV ] && ENV="$DOTSH_ENV" && unset DOTSH_ENV || unset ENV

# Test only existence so we get errors if it is not executable
[ -e '/opt/homebrew/bin/brew' ] && \
  eval "$(/opt/homebrew/bin/brew shellenv)"
