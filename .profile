#!/usr/bin/env sh
# Detect script directory in case it is not $HOME i.e. in a git project
export DOTSH_SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

# Save uname result in variable
DOTSH_OS_NAME="$(uname -s)"
if [ "$DOTSH_OS_NAME" = 'Darwin' ]; then
  export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"
fi

# Set UTF-8 locale to support double width characters
export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Set ENV to source ./.shrc for interactive login shell e.g. ssh console.
# This is similar to zsh built-in behavior.
case $- in
  *i*) export ENV="${ENV:-$DOTSH_SCRIPT_DIR/.shrc}" ;;
esac
