belmont-theme-for-eza
=====================

An [eza](https://eza.rocks/) theme inspired by [Dracula](https://github.com/eza-community/eza-themes/).

![Example of the Belmont theme for eza.](images/example.png)

Install
-------

### Linux

If you have `git` installed you can run the following command to install the theme:

```shell
bash -c "$(curl -fsSl https://raw.githubusercontent.com/jbenner-radham/belmont-theme-for-eza/refs/heads/main/install.sh)"
```

> [!NOTE]
> Using `bash` in the above command should be fine for most users. But, if needed you can change it to the shell of your choice. Please note however, that the install script requires a POSIX compatible shell.

Alternatively, if you would like to inspect the install script before running it you can perform the following:

```shell
test -f "install.sh" && echo "An \"install.sh\" file is already present in this directory. The file being downloaded will now be named either \"install.sh.1\" or some variant thereof."
curl -lO --no-clobber https://raw.githubusercontent.com/jbenner-radham/belmont-theme-for-eza/refs/heads/install-script-test/install.sh
```

Then inspect the downloaded `install.sh` file and resume with the following (assuming your file is `install.sh` and not `install.sh.1` or some variant thereof):

```shell
chmod u+x install.sh
./install.sh
```

If you prefer to install your theme manually, `eza` will look for a theme using the steps below in the following order:

1. If `$EZA_CONFIG_DIR` is set then `$EZA_CONFIG_DIR/theme.yml` will be loaded if it exists.
2. If `$EZA_CONFIG_DIR` is set then `$EZA_CONFIG_DIR/theme.yaml` will be loaded if it exists.
3. If `$XDG_CONFIG_HOME` is set then `$XDG_CONFIG_HOME/eza/theme.yml` will be loaded if it exists.
4. If `$XDG_CONFIG_HOME` is set then `$XDG_CONFIG_HOME/eza/theme.yaml` will be loaded if it exists.
5. If `$HOME/.config/eza/theme.yml` exists then it will be loaded.
6. If `$HOME/.config/eza/theme.yaml` exists then it will be loaded.

Choose your destination from the above and then copy or symlink `theme.yml` into the desired location.

### macOS

If you have `git` installed you can run the following command to install the theme:

```shell
zsh -c "$(curl -fsSl https://raw.githubusercontent.com/jbenner-radham/belmont-theme-for-eza/refs/heads/main/install.sh)"
```

> [!NOTE]
> Using `zsh` in the above command should be fine for most users. But, if needed you can change it to the shell of your choice. Please note however, that the install script requires a POSIX compatible shell.

Alternatively, if you would like to inspect the install script before running it you can perform the following:

```shell
test -f "install.sh" && echo "An \"install.sh\" file is already present in this directory. The file being downloaded will now be named either \"install.sh.1\" or some variant thereof."
curl -lO --no-clobber https://raw.githubusercontent.com/jbenner-radham/belmont-theme-for-eza/refs/heads/install-script-test/install.sh
```

Then inspect the downloaded `install.sh` file and resume with the following (assuming your file is `install.sh` and not `install.sh.1` or some variant thereof):

```shell
chmod u+x install.sh
./install.sh
```

If you prefer to install your theme manually, `eza` will look for a theme using the steps below in the following order:

1. If `$EZA_CONFIG_DIR` is set then `$EZA_CONFIG_DIR/theme.yml` will be loaded if it exists.
2. If `$EZA_CONFIG_DIR` is set then `$EZA_CONFIG_DIR/theme.yaml` will be loaded if it exists.
3. If `$HOME/Library/Application Support/eza/theme.yml` exists then it will be loaded.
4. If `$HOME/Library/Application Support/eza/theme.yaml` exists then it will be loaded.

Choose your destination from the above and then copy or symlink `theme.yml` into the desired location.

### Windows

> [!CAUTION]
> I haven't been able to verify the Windows install steps. This information has been gleaned
> from reading `eza`'s documentation and source code. If someone would care to confirm or deny
> the validity of these steps via an issue it would be much appreciated.

`eza` will look for a theme using the steps below in the following order:

1. If `%EZA_CONFIG_DIR%` is set then `%EZA_CONFIG_DIR%\theme.yml` will be loaded if it exists.
2. If `%EZA_CONFIG_DIR%` is set then `%EZA_CONFIG_DIR%\theme.yaml` will be loaded if it exists.
3. If `%AppData%\eza\theme.yml` exists then it will be loaded.
4. If `%AppData%\eza\theme.yaml` exists then it will be loaded.

Choose your destination from the above and then copy or symlink `theme.yml` into the desired location.
