#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?Usage: generate-formula.sh <version> <artifacts-dir> <output-dir>}"
ARTIFACTS_DIR="${2:?Usage: generate-formula.sh <version> <artifacts-dir> <output-dir>}"
OUTPUT_DIR="${3:?Usage: generate-formula.sh <version> <artifacts-dir> <output-dir>}"

REPO="${GITHUB_REPOSITORY:-datagouv/datagouv-cli}"
BASE_URL="https://github.com/${REPO}/releases/download/v${VERSION}"
CLI_NAME="datagouv"

mkdir -p "${OUTPUT_DIR}"

generate_formula() {
  local class_suffix="$1"
  local binary_suffix="$2"
  local output_file="${OUTPUT_DIR}/${CLI_NAME}${class_suffix}.rb"
  local archive_path="${ARTIFACTS_DIR}/${CLI_NAME}-${binary_suffix}.tar.gz"
  local sha256_path="${archive_path}.sha256"

  if [[ ! -f "${archive_path}" || ! -f "${sha256_path}" ]]; then
    echo "Missing macOS artifact for ${binary_suffix}" >&2
    exit 1
  fi

  local sha256
  sha256="$(awk '{print $1}' "${sha256_path}")"

  cat > "${output_file}" <<EOF
class Datagouv${class_suffix} < Formula
  desc "CLI for data.gouv.fr"
  homepage "https://github.com/${REPO}"
  url "${BASE_URL}/${CLI_NAME}-${binary_suffix}.tar.gz"
  version "${VERSION}"
  sha256 "${sha256}"
  license "MIT"

  def install
    libexec.install "${CLI_NAME}"
    bin.install_symlink libexec/"${CLI_NAME}/${CLI_NAME}" => "${CLI_NAME}"
  end

  test do
    assert_match "${CLI_NAME}", shell_output("#{bin}/${CLI_NAME} --help")
  end
end
EOF
}

generate_formula "" "macos-arm64"
generate_formula "Intel" "macos-amd64"

cat > "${OUTPUT_DIR}/${CLI_NAME}.rb" <<EOF
class Datagouv < Formula
  desc "CLI for data.gouv.fr"
  homepage "https://github.com/${REPO}"

  on_macos do
    if Hardware::CPU.arm?
      url "${BASE_URL}/${CLI_NAME}-macos-arm64.tar.gz"
      sha256 "$(awk '{print $1}' "${ARTIFACTS_DIR}/${CLI_NAME}-macos-arm64.tar.gz.sha256")"
    else
      url "${BASE_URL}/${CLI_NAME}-macos-amd64.tar.gz"
      sha256 "$(awk '{print $1}' "${ARTIFACTS_DIR}/${CLI_NAME}-macos-amd64.tar.gz.sha256")"
    end
  end

  version "${VERSION}"
  license "MIT"

  def install
    libexec.install "${CLI_NAME}"
    bin.install_symlink libexec/"${CLI_NAME}/${CLI_NAME}" => "${CLI_NAME}"
  end

  test do
    assert_match "${CLI_NAME}", shell_output("#{bin}/${CLI_NAME} --help")
  end
end
EOF

echo "Generated Homebrew formulas in ${OUTPUT_DIR}"
