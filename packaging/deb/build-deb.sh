#!/usr/bin/env bash
set -euo pipefail

DIST_DIR="${1:?Usage: build-deb.sh <onedir-dist> <version> <deb-arch>}"
VERSION="${2:?Usage: build-deb.sh <onedir-dist> <version> <deb-arch>}"
DEB_ARCH="${3:?Usage: build-deb.sh <onedir-dist> <version> <deb-arch>}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}"
PACKAGE_NAME="datagouv"
OUTPUT_FILE="${OUTPUT_DIR}/${PACKAGE_NAME}_${VERSION}_${DEB_ARCH}.deb"
STAGING_DIR="$(mktemp -d)"

if [[ ! -d "${DIST_DIR}" ]]; then
  echo "Distribution directory not found: ${DIST_DIR}" >&2
  exit 1
fi

if [[ ! -x "${DIST_DIR}/datagouv" ]]; then
  echo "Executable not found: ${DIST_DIR}/datagouv" >&2
  exit 1
fi

cleanup() {
  rm -rf "${STAGING_DIR}"
}
trap cleanup EXIT

mkdir -p "${STAGING_DIR}/usr/lib" "${STAGING_DIR}/usr/bin"
cp -a "${DIST_DIR}" "${STAGING_DIR}/usr/lib/datagouv"
ln -s /usr/lib/datagouv/datagouv "${STAGING_DIR}/usr/bin/datagouv"

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
  "${STAGING_DIR}/"=/

rm -f "${CONTROL_FILE}"

sha256sum "${OUTPUT_FILE}" > "${OUTPUT_FILE}.sha256"
echo "Built ${OUTPUT_FILE}"
