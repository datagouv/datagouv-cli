#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?Usage: update-tap.sh <version> <formula-dir>}"
FORMULA_DIR="${2:?Usage: update-tap.sh <version> <formula-dir>}"

TAP_REPO="${HOMEBREW_TAP_REPO:-datagouv/homebrew-tap}"
TAP_URL="https://github.com/${TAP_REPO}.git"

if [[ -z "${HOMEBREW_TAP_TOKEN:-}" ]]; then
  echo "HOMEBREW_TAP_TOKEN is not set; skipping Homebrew tap update." >&2
  echo "Generated formulas are available in ${FORMULA_DIR} for manual upload." >&2
  exit 0
fi

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

git clone "https://x-access-token:${HOMEBREW_TAP_TOKEN}@github.com/${TAP_REPO}.git" "${WORK_DIR}/tap"
mkdir -p "${WORK_DIR}/tap/Formula"
cp "${FORMULA_DIR}/datagouv.rb" "${WORK_DIR}/tap/Formula/datagouv.rb"

pushd "${WORK_DIR}/tap" > /dev/null
git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
git add Formula/datagouv.rb
if git diff --cached --quiet; then
  echo "Homebrew formula unchanged."
else
  git commit -m "chore(formula): bump datagouv to v${VERSION}"
  git push origin HEAD
fi
popd > /dev/null

echo "Updated Homebrew tap ${TAP_REPO}"
