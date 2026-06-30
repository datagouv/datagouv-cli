#!/usr/bin/env bash
set -euo pipefail

BINARY="${1:?Usage: build-deb.sh <binary> <version> <deb-arch>}"
VERSION="${2:?Usage: build-deb.sh <binary> <version> <deb-arch>}"
DEB_ARCH="${3:?Usage: build-deb.sh <binary> <version> <deb-arch>}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}"
PACKAGE_NAME="datagouv-cli"
OUTPUT_FILE="${OUTPUT_DIR}/${PACKAGE_NAME}_${VERSION}_${DEB_ARCH}.deb"

if [[ ! -f "${BINARY}" ]]; then
  echo "Binary not found: ${BINARY}" >&2
  exit 1
fi

CONTROL_FILE="$(mktemp)"
sed \
  -e "s/@VERSION@/${VERSION}/g" \
  -e "s/@ARCH@/${DEB_ARCH}/g" \
  "${SCRIPT_DIR}/control.template" > "${CONTROL_FILE}"

fpm \
  --input-type dir \
  --output-type deb \
  --name "${PACKAGE_NAME}" \
  --version "${VERSION}" \
  --architecture "${DEB_ARCH}" \
  --maintainer "data.gouv.fr <opendatateam@data.gouv.fr>" \
  --description "CLI for data.gouv.fr" \
  --url "https://github.com/datagouv/datagouv-cli" \
  --license MIT \
  --category utils \
  --deb-no-default-config-files \
  --package "${OUTPUT_FILE}" \
  "${BINARY}=/usr/local/bin/datagouv-cli"

rm -f "${CONTROL_FILE}"

sha256sum "${OUTPUT_FILE}" > "${OUTPUT_FILE}.sha256"
echo "Built ${OUTPUT_FILE}"
