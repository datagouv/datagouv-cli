#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?Usage: generate-formula.sh <version> <artifacts-dir> <output-dir>}"
ARTIFACTS_DIR="${2:?Usage: generate-formula.sh <version> <artifacts-dir> <output-dir>}"
OUTPUT_DIR="${3:?Usage: generate-formula.sh <version> <artifacts-dir> <output-dir>}"

REPO="${GITHUB_REPOSITORY:-datagouv/datagouv_cli}"
BASE_URL="https://github.com/${REPO}/releases/download/v${VERSION}"

mkdir -p "${OUTPUT_DIR}"

generate_formula() {
  local class_suffix="$1"
  local binary_suffix="$2"
  local output_file="${OUTPUT_DIR}/datagouv${class_suffix}.rb"
  local binary_path="${ARTIFACTS_DIR}/datagouv-${binary_suffix}"
  local sha256_path="${binary_path}.sha256"

  if [[ ! -f "${binary_path}" || ! -f "${sha256_path}" ]]; then
    echo "Missing macOS artifact for ${binary_suffix}" >&2
    exit 1
  fi

  local sha256
  sha256="$(awk '{print $1}' "${sha256_path}")"

  cat > "${output_file}" <<EOF
class Datagouv${class_suffix} < Formula
  desc "CLI for data.gouv.fr"
  homepage "https://github.com/${REPO}"
  url "${BASE_URL}/datagouv-${binary_suffix}"
  version "${VERSION}"
  sha256 "${sha256}"
  license "MIT"

  def install
    bin.install "datagouv-${binary_suffix}" => "datagouv"
  end

  test do
    assert_match "datagouv", shell_output("#{bin}/datagouv --help")
  end
end
EOF
}

generate_formula "" "macos-arm64"
generate_formula "Intel" "macos-amd64"

cat > "${OUTPUT_DIR}/datagouv.rb" <<EOF
class Datagouv < Formula
  desc "CLI for data.gouv.fr"
  homepage "https://github.com/${REPO}"

  on_macos do
    if Hardware::CPU.arm?
      url "${BASE_URL}/datagouv-macos-arm64"
      sha256 "$(awk '{print $1}' "${ARTIFACTS_DIR}/datagouv-macos-arm64.sha256")"
    else
      url "${BASE_URL}/datagouv-macos-amd64"
      sha256 "$(awk '{print $1}' "${ARTIFACTS_DIR}/datagouv-macos-amd64.sha256")"
    end
  end

  version "${VERSION}"
  license "MIT"

  def install
    if Hardware::CPU.arm?
      bin.install "datagouv-macos-arm64" => "datagouv"
    else
      bin.install "datagouv-macos-amd64" => "datagouv"
    end
  end

  test do
    assert_match "datagouv", shell_output("#{bin}/datagouv --help")
  end
end
EOF

echo "Generated Homebrew formulas in ${OUTPUT_DIR}"
