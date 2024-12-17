# Detect script directory in case it is not $HOME i.e. in a git project
DOTSH_SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
[ -e "$DOTSH_SCRIPT_DIR/.bash_profile" ] || DOTSH_SCRIPT_DIR="$HOME"

# Use ./.profile as a base for .bash_profile,
# then ensures bash sources ./.bashrc, not ./.shrc.
[ -z ${ENV+x} ] || DOTSH_ENV="$ENV"
source "$DOTSH_SCRIPT_DIR/.profile"
if [ -n ${DOTSH_ENV+x} ]; then
  ENV="$DOTSH_ENV"
  unset DOTSH_ENV
else
  unset ENV
fi

# Source ./.bashrc also for interactive login shell e.g. ssh console.
# This is similar to zsh built-in behavior.
case $- in
  *i*) source "$DOTSH_SCRIPT_DIR/.bashrc" ;;
esac
