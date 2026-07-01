#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?Usage: update-tap.sh <version> <formula-dir>}"
FORMULA_DIR="${2:?Usage: update-tap.sh <version> <formula-dir>}"

CLI_NAME="datagouv"
DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"
FORMULA_PATH="Formula/${CLI_NAME}.rb"

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"

git fetch origin "${DEFAULT_BRANCH}"
git checkout "${DEFAULT_BRANCH}"

mkdir -p Formula
cp "${FORMULA_DIR}/${CLI_NAME}.rb" "${FORMULA_PATH}"

git add "${FORMULA_PATH}"
if git diff --cached --quiet; then
  echo "Homebrew formula unchanged."
  exit 0
fi

git commit -m "chore(formula): bump ${CLI_NAME} to v${VERSION} [skip ci]"
git push origin "${DEFAULT_BRANCH}"

echo "Updated Homebrew formula on ${DEFAULT_BRANCH}"
