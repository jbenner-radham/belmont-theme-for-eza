#!/usr/bin/env sh

# Reference:
#   - https://unix.stackexchange.com/questions/65803/why-is-printf-better-than-echo
#   - https://www.baeldung.com/linux/posix-shell-array
#   - https://steinbaugh.com/posts/posix.html

printf "\n"

# Taken from: https://github.com/Homebrew/install/blob/efda6e8a4623dd9a3046faf4991cbfb40bea8d17/install.sh#L9-L12
abort() {
  printf "%s\n" "$@" >&2
  exit 1
}

if [ -n "$LS_COLORS" ]; then
  abort "The $(tput bold)\$LS_COLORS$(tput sgr0) environment variable is set. This will override any theme file installation. Please unset it and try again."
fi

if [ -n "$EXA_COLORS" ]; then
  abort "The $(tput bold)\$EXA_COLORS$(tput sgr0) environment variable is set. This will override any theme file installation. Please unset it and try again."
fi

if [ -n "$EZA_COLORS" ]; then
  abort "The $(tput bold)\$EZA_COLORS$(tput sgr0) environment variable is set. This will override any theme file installation. Please unset it and try again."
fi

if ! command -v git > /dev/null; then
  abort "Git cannot be found. Please install it or add it to your system path and retry."
fi

BELMONT_REPO_NAME="belmont-theme-for-eza"

if [ ! -d "${XDG_DATA_HOME:-$HOME/.local/share}" ]; then
  set -- "${XDG_DATA_HOME:-$HOME/.local/share}" "${XDG_DATA_HOME:-$HOME/.local/share}/${BELMONT_REPO_NAME}"
elif [ ! -d "${XDG_DATA_HOME:-$HOME/.local/share}/${BELMONT_REPO_NAME}" ]; then
  set -- "${XDG_DATA_HOME:-$HOME/.local/share}/${BELMONT_REPO_NAME}"
fi

if [ -n "${EZA_CONFIG_DIR}" ] && [ ! -d "${EZA_CONFIG_DIR}" ]; then
  set -- "$@" "${EZA_CONFIG_DIR}" "${EZA_CONFIG_DIR}/${BELMONT_REPO_NAME}"
elif [ "$(uname)" = "Darwin" ] && [ ! -d "${HOME}/Library/Application Support/eza" ]; then
  set -- "$@" "${HOME}/Library/Application Support/eza"
elif [ "$(uname)" = "Linux" ] && [ -d "${XDG_DATA_HOME:-$HOME/.local/share}" ]; then
  if [ ! -d "${XDG_DATA_HOME:-$HOME/.local/share}/${BELMONT_REPO_NAME}" ]; then
    set -- "$@" "${XDG_DATA_HOME:-$HOME/.local/share}/${BELMONT_REPO_NAME}"
  fi
elif [ "$(uname)" = "Linux" ]; then
  set -- "$@" "${XDG_DATA_HOME:-$HOME/.local/share}" "${XDG_DATA_HOME:-$HOME/.local/share}/${BELMONT_REPO_NAME}"
fi

BELMONT_SYMLINK_TARGET=""

if [ -n "${EZA_CONFIG_DIR}" ]; then
  BELMONT_SYMLINK_TARGET="${EZA_CONFIG_DIR}/theme.yml"
elif [ "$(uname)" = "Darwin" ]; then
  BELMONT_SYMLINK_TARGET="${HOME}/Library/Application Support/eza/theme.yml"
elif [ "$(uname)" = "Linux" ]; then
  BELMONT_SYMLINK_TARGET="${XDG_CONFIG_HOME:-$HOME/.config}/eza/theme.yml"
fi

if [ -z "$BELMONT_SYMLINK_TARGET" ]; then
  abort "Cannot detect a valid installation scenario to process."
fi

if [ -f "$BELMONT_SYMLINK_TARGET" ]; then
  abort "An eza theme is already installed at $(tput bold)${BELMONT_SYMLINK_TARGET}$(tput sgr0). If desired, please remove it and try again."
fi

if [ -n "$*" ]; then
  printf "The following new directory (or directories) will be created:\n"

  for dir in "$@"; do
    printf "  %s\n" "${dir}"
  done

  printf "\n"
fi

if [ -n "$BELMONT_SYMLINK_TARGET" ]; then
  printf "The following new symlink will be created:\n"
  printf "  %s\n" "${BELMONT_SYMLINK_TARGET}"
fi

printf "Do you wish to proceed? [y/N]: "
read -r REPLY
printf "\n"

if [ ! "$REPLY" = Y ] && [ ! "$REPLY" = y ]; then
  exit 0
fi

mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}"
git clone --quiet https://github.com/jbenner-radham/belmont-theme-for-eza.git "${XDG_DATA_HOME:-$HOME/.local/share}/${BELMONT_REPO_NAME}"

if [ -n "${EZA_CONFIG_DIR}" ]; then
  mkdir -p "${EZA_CONFIG_DIR}"
  ln -s "${XDG_DATA_HOME:-$HOME/.local/share}/${BELMONT_REPO_NAME}/theme.yml" "${BELMONT_SYMLINK_TARGET}"
elif [ "$(uname)" = "Darwin" ]; then
  mkdir -p "${HOME}/Library/Application Support/eza"
  ln -s "${XDG_DATA_HOME:-$HOME/.local/share}/${BELMONT_REPO_NAME}/theme.yml" "${BELMONT_SYMLINK_TARGET}"
elif [ "$(uname)" = "Linux" ]; then
  mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/eza"
  ln -s "${XDG_DATA_HOME:-$HOME/.local/share}/${BELMONT_REPO_NAME}/theme.yml" "${BELMONT_SYMLINK_TARGET}"
fi

printf "Belmont for eza installed successfully!\n"
