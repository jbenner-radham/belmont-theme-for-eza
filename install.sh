#!/usr/bin/env sh
set -o errexit
set -o noglob
set -o nounset

# Enable this to assist with debugging errors.
# set -o xtrace

# Reference:
#   - https://unix.stackexchange.com/questions/65803/why-is-printf-better-than-echo
#   - https://www.baeldung.com/linux/posix-shell-array
#   - https://steinbaugh.com/posts/posix.html
#   - https://github.com/SixArm/unix-shell-script-tactics/tree/main#readme
#   - https://no-color.org/

printf '\n'

# Taken from: https://github.com/Homebrew/install/blob/efda6e8a4623dd9a3046faf4991cbfb40bea8d17/install.sh#L9-L12
abort() {
  printf '%s\n' "${*}" >&2
  exit 1
}

has_command() {
  command -v "${*}" >/dev/null 2>&1
}

BOLD=
RESET=

# Enable text styling only if the following conditions are met:
#   1. Standard output (file descriptor 1) is connected to the terminal.
#   2. `NO_COLOR` is either unset or a zero-length string.
#   3. `TERM` is not set to "dumb".
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ] && [ "${TERM:-}" != 'dumb' ]; then
  BOLD='[1m'
  RESET='[0m'
fi

if [ -n "${LS_COLORS:-}" ]; then
  abort "The ${BOLD}\$LS_COLORS${RESET} environment variable is set. This" \
    "will override any theme file installation. Please unset it and try again."
fi

if [ -n "${EXA_COLORS:-}" ]; then
  abort "The ${BOLD}\$EXA_COLORS${RESET} environment variable is set. This" \
    "will override any theme file installation. Please unset it and try again."
fi

if [ -n "${EZA_COLORS:-}" ]; then
  abort "The ${BOLD}\$EZA_COLORS${RESET} environment variable is set. This" \
    "will override any theme file installation. Please unset it and try again."
fi

if ! has_command 'git'; then
  abort "The ${BOLD}git${RESET} command cannot be found. Please install it or" \
    "add it to your system path and retry."
fi

readonly APPLICATION_SUPPORT="${HOME}/Library/Application Support"
readonly BELMONT_REPO_NAME='belmont-theme-for-eza'
readonly BELMONT_SOURCE_FILE='theme.yaml'
readonly CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
readonly DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

if [ ! -d "${DATA_HOME}" ]; then
  set -- "${DATA_HOME}" "${DATA_HOME}/${BELMONT_REPO_NAME}"
elif [ ! -d "${DATA_HOME}/${BELMONT_REPO_NAME}" ]; then
  set -- "${DATA_HOME}/${BELMONT_REPO_NAME}"
fi

if [ -n "${EZA_CONFIG_DIR:-}" ] && [ ! -d "${EZA_CONFIG_DIR}" ]; then
  set -- "${@}" "${EZA_CONFIG_DIR}"
elif [ "$(uname)" = 'Darwin' ] && [ ! -d "${APPLICATION_SUPPORT}/eza" ]; then
  set -- "${@}" "${APPLICATION_SUPPORT}/eza"
elif [ "$(uname)" = 'Linux' ] && [ ! -d "${CONFIG_HOME}" ]; then
  set -- "${@}" "${CONFIG_HOME}" "${CONFIG_HOME}/eza"
elif [ "$(uname)" = 'Linux' ] && [ ! -d "${CONFIG_HOME}/eza" ]; then
  set -- "${@}" "${CONFIG_HOME}/eza"
fi

BELMONT_SYMLINK_TARGET=

if [ -n "${EZA_CONFIG_DIR:-}" ]; then
  BELMONT_SYMLINK_TARGET="${EZA_CONFIG_DIR}/theme.yml"
elif [ "$(uname)" = 'Darwin' ]; then
  BELMONT_SYMLINK_TARGET="${APPLICATION_SUPPORT}/eza/theme.yml"
elif [ "$(uname)" = 'Linux' ]; then
  BELMONT_SYMLINK_TARGET="${CONFIG_HOME}/eza/theme.yml"
fi

if [ -z "${BELMONT_SYMLINK_TARGET}" ]; then
  abort 'Cannot detect a valid installation scenario to process.'
fi

if [ -f "${BELMONT_SYMLINK_TARGET}" ]; then
  abort "An eza theme is already installed at" \
    "${BOLD}${BELMONT_SYMLINK_TARGET}${RESET}. If desired, please remove it" \
    "and try again."
fi

if [ -n "${*}" ]; then
  printf 'The following new directory (or directories) will be created:\n'

  for dir in "${@}"; do
    printf '  %s%s%s\n' "${BOLD}" "${dir}" "${RESET}"
  done

  printf '\n'
fi

if [ -n "${BELMONT_SYMLINK_TARGET}" ]; then
  printf 'The following new symlink will be created:\n'
  printf '  %s%s%s\n' "${BOLD}" "${BELMONT_SYMLINK_TARGET}" "${RESET}"
  printf '\n'
fi

printf 'Do you wish to proceed? (y/N): '
read -r REPLY
printf '\n'

if [ ! "${REPLY}" = Y ] && [ ! "${REPLY}" = y ]; then
  exit 0
fi

mkdir -p "${DATA_HOME}"

if [ ! -d "${DATA_HOME}/${BELMONT_REPO_NAME}" ]; then
  # Reference: https://stackoverflow.com/questions/1125476/retrieve-a-single-file-from-a-repository#answer-67409497
  git clone --depth=1 --no-checkout --no-tags --quiet \
    https://github.com/jbenner-radham/belmont-theme-for-eza.git \
    "${DATA_HOME}/${BELMONT_REPO_NAME}"
  (cd "${DATA_HOME}/${BELMONT_REPO_NAME}" && \
    git restore --staged "${BELMONT_SOURCE_FILE}" && \
    git checkout --quiet -- "${BELMONT_SOURCE_FILE}")
fi

if [ -n "${EZA_CONFIG_DIR:-}" ] || [ "$(uname)" = 'Darwin' ] ||
  [ "$(uname)" = 'Linux' ]
then
  mkdir -p "$(dirname "${BELMONT_SYMLINK_TARGET}")"
  ln -s "${DATA_HOME}/${BELMONT_REPO_NAME}/${BELMONT_SOURCE_FILE}" \
    "${BELMONT_SYMLINK_TARGET}"
fi

printf '%sBelmont for eza installed successfully!%s\n' \
  "${BOLD}" \
  "${RESET}"

