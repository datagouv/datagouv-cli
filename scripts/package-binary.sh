#!/usr/bin/env bash
set -euo pipefail

DIST_DIR="${1:?Usage: package-binary.sh <onedir-dist> <output-archive>}"
OUTPUT="${2:?Usage: package-binary.sh <onedir-dist> <output-archive>}"

if [[ ! -d "${DIST_DIR}" ]]; then
  echo "Distribution directory not found: ${DIST_DIR}" >&2
  exit 1
fi

PARENT="$(dirname "${DIST_DIR}")"
NAME="$(basename "${DIST_DIR}")"

tar -czf "${OUTPUT}" -C "${PARENT}" "${NAME}"
sha256sum "${OUTPUT}" > "${OUTPUT}.sha256"
echo "Packaged ${OUTPUT}"
