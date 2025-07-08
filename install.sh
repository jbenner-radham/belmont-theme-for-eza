#!/usr/bin/env sh

echo

if [ -n "$LS_COLORS" ]; then
  echo "The \$LS_COLORS environment variable is set. This will override any theme file installation. Please unset it and try again." >&2
  exit 1
fi

if [ -n "$EXA_COLORS" ]; then
  echo "The \$EXA_COLORS environment variable is set. This will override any theme file installation. Please unset it and try again." >&2
  exit 1
fi

if [ -n "$EZA_COLORS" ]; then
  echo "The \$EZA_COLORS environment variable is set. This will override any theme file installation. Please unset it and try again." >&2
  exit 1
fi

if ! command -v git > /dev/null; then
  echo "Git cannot be found. Please install it or add it to your system path and retry." >&2
  exit 1
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
  echo "Cannot detect a valid installation scenario to process." >&2
  exit 1
fi

if [ -f "$BELMONT_SYMLINK_TARGET" ]; then
  echo "An eza theme is already installed (${BELMONT_SYMLINK_TARGET}). If desired, please remove it and try again." >&2
  exit 1
fi

if [ -n "$*" ]; then
  echo "The following new directory (or directories) will be created:"

  for dir in "$@"; do
    echo "  ${dir}"
  done

  echo
fi

if [ -n "$BELMONT_SYMLINK_TARGET" ]; then
  echo "The following new symlink will be created:"
  echo "  ${BELMONT_SYMLINK_TARGET}"
  echo
fi

printf "Do you wish to proceed? (y/n): "
read -r REPLY
echo

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

echo "Belmont for eza installed successfully!"
