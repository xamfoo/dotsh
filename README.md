# dotsh

## Install

WARNING: This will replace the following initialization files in your home
directory. Any existing files will be renamed as `*.bkup` files.

- `.profile`
- `.shrc`
- `.bash_profile`
- `.bashrc`
- `.zprofile`
- `.zshrc`

```bash
mkdir -p ~/.config
git clone https://github.com/xamfoo/dotsh ~/.config/sh
cd ~
find ~/.config/sh -path ~/.config/sh/.git -prune -o -name '.*' \
  -exec bash -c "mv -f \"\$HOME/\$(basename \"{}\")\" \
  \"\$HOME/\$(basename \"{}\").\$(date +'%s').bkup\"; ln -s \"{}\" ." \;
```

## Initialization Order

### Dash Initialization Order

1. `/etc/profile` and `/etc/profile.d/*` for login shell
2. `~/.profile` for login shell
3. Value of `ENV` for interactive shell

### Zsh Initialization Order

1.  `/etc/zshenv`
2.  `~/.zshenv`
4.  `/etc/zprofile` for login shell
5.  `~/.zprofile` for login shell
6.  `/etc/zshrc` for interactive shell
7.  `~/.zshrc` for interactive shell
8.  `/etc/zlogin` for login shell
9.  `~/.zlogin` for login shell
10. `/etc/zlogout` for login shell
11. `~/.zlogout` for login shell

### Bash Initialization Order

1. `/etc/profile` and `/etc/profile.d/*` for login shell
2. `~/.bash_profile` or `~/.bash_login` or `~/.profile` for login shell
3. `/etc/bash.bashrc` in some distros for interactive non-login shell
4. `~/.bashrc` for interactive non-login shell
5. `/etc/bash.bash_logout` in some distros for login shell
6. `~/.bash_logout` for login shell
