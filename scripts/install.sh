#!/usr/bin/env bash
set -euo pipefail

REPO="${DATAGOUV_CLI_REPO:-datagouv/datagouv-cli}"
APT_BASE_URL="${DATAGOUV_APT_BASE_URL:-https://datagouv.github.io/datagouv-cli}"
BREW_TAP="${DATAGOUV_BREW_TAP:-datagouv/datagouv-cli}"
BREW_TAP_URL="${DATAGOUV_BREW_TAP_URL:-https://github.com/${REPO}.git}"
CLI_NAME="datagouv-cli"

log() {
  echo "[${CLI_NAME}] $*"
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Required command not found: $1" >&2
    exit 1
  fi
}

install_via_apt() {
  require_command curl
  require_command gpg
  require_command sudo

  log "Configuring APT repository..."
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL "${APT_BASE_URL}/${CLI_NAME}.gpg" | sudo gpg --dearmor -o "/etc/apt/keyrings/${CLI_NAME}.gpg"
  echo "deb [signed-by=/etc/apt/keyrings/${CLI_NAME}.gpg] ${APT_BASE_URL} stable main" \
    | sudo tee "/etc/apt/sources.list.d/${CLI_NAME}.list" > /dev/null
  sudo apt-get update
  sudo apt-get install -y "${CLI_NAME}"
}

install_via_brew() {
  require_command brew
  if ! brew tap | grep -q "^${BREW_TAP}$"; then
    log "Adding Homebrew tap ${BREW_TAP}..."
    if ! brew tap "${BREW_TAP}" "${BREW_TAP_URL}"; then
      log "Homebrew tap unavailable; falling back to binary install..."
      install_via_binary
      return
    fi
  fi
  if ! brew install "${CLI_NAME}"; then
    log "Homebrew install failed; falling back to binary install..."
    install_via_binary
  fi
}

install_via_binary() {
  require_command curl
  require_command uname

  local os arch suffix version asset url tmpdir
  os="$(uname -s | tr '[:upper:]' '[:lower:]')"
  arch="$(uname -m)"

  case "${os}:${arch}" in
    linux:x86_64) suffix="linux-amd64" ;;
    linux:aarch64|linux:arm64) suffix="linux-arm64" ;;
    darwin:arm64) suffix="macos-arm64" ;;
    darwin:x86_64) suffix="macos-amd64" ;;
    *)
      echo "Unsupported platform: ${os} ${arch}" >&2
      exit 1
      ;;
  esac

  version="${DATAGOUV_CLI_VERSION:-}"
  if [[ -z "${version}" ]]; then
    require_command jq
    version="$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | jq -r '.tag_name' | sed 's/^v//')"
  fi

  asset="${CLI_NAME}-${suffix}"
  url="https://github.com/${REPO}/releases/download/v${version}/${asset}"
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "${tmpdir}"' EXIT

  log "Downloading ${url}..."
  curl -fsSL "${url}" -o "${tmpdir}/${asset}"
  curl -fsSL "${url}.sha256" -o "${tmpdir}/${asset}.sha256"

  if command -v sha256sum >/dev/null 2>&1; then
    (cd "${tmpdir}" && sha256sum -c "${asset}.sha256")
  elif command -v shasum >/dev/null 2>&1; then
    expected="$(awk '{print $1}' "${tmpdir}/${asset}.sha256")"
    actual="$(shasum -a 256 "${tmpdir}/${asset}" | awk '{print $1}')"
    [[ "${expected}" == "${actual}" ]] || {
      echo "Checksum mismatch" >&2
      exit 1
    }
  fi

  chmod +x "${tmpdir}/${asset}"
  sudo install -m 0755 "${tmpdir}/${asset}" "/usr/local/bin/${CLI_NAME}"
  log "Installed ${CLI_NAME} to /usr/local/bin/${CLI_NAME}"
}

main() {
  local method="${1:-auto}"

  case "${method}" in
    apt)
      install_via_apt
      ;;
    brew)
      install_via_brew
      ;;
    binary)
      install_via_binary
      ;;
    auto)
      if [[ "$(uname -s)" == "Linux" ]] && command -v apt-get >/dev/null 2>&1; then
        install_via_apt
      elif [[ "$(uname -s)" == "Darwin" ]] && command -v brew >/dev/null 2>&1; then
        install_via_brew
      else
        install_via_binary
      fi
      ;;
    *)
      echo "Usage: $0 [auto|apt|brew|binary]" >&2
      exit 1
      ;;
  esac

  "${CLI_NAME}" --help
}

main "$@"
