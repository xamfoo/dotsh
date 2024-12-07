# Use ./.profile as a base for .zprofile,
# then ensures zsh sources ./.zshrc, not ./.shrc.
[ ! -v ENV ] || DOTSH_ENV="$ENV"
emulate sh -c "source \"$0:a:h/.profile\""
[ -v DOTSH_ENV ] && ENV="$DOTSH_ENV" && unset DOTSH_ENV || unset ENV

# Test only existence so we get errors if it is not executable
[ -e '/opt/homebrew/bin/brew' ] && \
  eval "$(/opt/homebrew/bin/brew shellenv)"
