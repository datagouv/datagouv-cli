#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?Usage: publish-repo.sh <version>}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="${SCRIPT_DIR}/reprepro"
GH_PAGES_DIR="${SCRIPT_DIR}/gh-pages"
DEB_DIR="${SCRIPT_DIR}/../deb"

mkdir -p "${REPO_DIR}/conf"
cp "${SCRIPT_DIR}/distributions" "${REPO_DIR}/conf/distributions"

if [[ -z "${APT_GPG_PRIVATE_KEY:-}" ]]; then
  echo "APT_GPG_PRIVATE_KEY is not set; exporting unsigned APT repository." >&2
  sed -i '/^SignWith:/d' "${REPO_DIR}/conf/distributions"
fi

for deb_file in "${DEB_DIR}"/datagouv_"${VERSION}"_*.deb; do
  if [[ ! -f "${deb_file}" ]]; then
    echo "Missing Debian package: ${deb_file}" >&2
    exit 1
  fi
  reprepro -Vb "${REPO_DIR}" includedeb stable "${deb_file}"
done

rm -rf "${GH_PAGES_DIR}"
mkdir -p "${GH_PAGES_DIR}"

if [[ -d "${REPO_DIR}/dists" ]]; then
  cp -a "${REPO_DIR}/dists" "${GH_PAGES_DIR}/"
fi

if [[ -d "${REPO_DIR}/pool" ]]; then
  cp -a "${REPO_DIR}/pool" "${GH_PAGES_DIR}/"
fi

if [[ -n "${APT_GPG_PRIVATE_KEY:-}" ]]; then
  gpg --armor --export > "${GH_PAGES_DIR}/datagouv.gpg"
else
  echo "Skipping datagouv.gpg export because APT repository is unsigned." >&2
fi

echo "APT repository exported to ${GH_PAGES_DIR}"
