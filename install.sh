#!/usr/bin/env shell

mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}"
git clone https://github.com/jbenner-radham/belmont-theme-for-eza.git "${XDG_DATA_HOME:-$HOME/.local/share}/belmont-theme-for-eza"

if [ -n "${EZA_CONFIG_DIR}" ]; then
  mkdir -p "${EZA_CONFIG_DIR}"
  ln -s "${XDG_DATA_HOME:-$HOME/.local/share}/belmont-theme-for-eza/theme.yml" "${EZA_CONFIG_DIR}/theme.yml"
elif [ "$(uname)" = "Darwin" ]; then
  mkdir -p "${HOME}/Library/Application Support/eza"
  ln -s "${XDG_DATA_HOME:-$HOME/.local/share}/belmont-theme-for-eza/theme.yml" "${HOME}/Library/Application Support/eza/theme.yml"
elif [ "$(uname)" = "Linux" ]; then
  mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/eza"
  ln -s "${XDG_DATA_HOME:-$HOME/.local/share}/belmont-theme-for-eza/theme.yml" "${XDG_CONFIG_HOME:-$HOME/.config}/eza/theme.yml"
fi
