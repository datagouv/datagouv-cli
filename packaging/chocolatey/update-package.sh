#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?Usage: update-package.sh <version> <package-dir>}"
PACKAGE_DIR="${2:?Usage: update-package.sh <version> <package-dir>}"

CLI_NAME="datagouv"
DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"
PACKAGE_PATH="chocolatey/${CLI_NAME}"
NUSPEC_FILE="${CLI_NAME}.nuspec"

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"

git fetch origin "${DEFAULT_BRANCH}"
git checkout "${DEFAULT_BRANCH}"

mkdir -p "${PACKAGE_PATH}/tools"
cp "${PACKAGE_DIR}/${NUSPEC_FILE}" "${PACKAGE_PATH}/${NUSPEC_FILE}"
cp "${PACKAGE_DIR}/tools/chocolateyInstall.ps1" "${PACKAGE_PATH}/tools/chocolateyInstall.ps1"

git add "${PACKAGE_PATH}/${NUSPEC_FILE}" "${PACKAGE_PATH}/tools/chocolateyInstall.ps1"
if git diff --cached --quiet; then
  echo "Chocolatey package unchanged."
  exit 0
fi

git commit -m "chore(chocolatey): bump ${CLI_NAME} to v${VERSION} [skip ci]"
git push origin "${DEFAULT_BRANCH}"

echo "Updated Chocolatey package on ${DEFAULT_BRANCH}"
