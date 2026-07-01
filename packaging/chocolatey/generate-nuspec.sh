#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?Usage: generate-nuspec.sh <version> <artifacts-dir> <output-dir>}"
ARTIFACTS_DIR="${2:?Usage: generate-nuspec.sh <version> <artifacts-dir> <output-dir>}"
OUTPUT_DIR="${3:?Usage: generate-nuspec.sh <version> <artifacts-dir> <output-dir>}"

REPO="${GITHUB_REPOSITORY:-datagouv/datagouv-cli}"
BASE_URL="https://github.com/${REPO}/releases/download/v${VERSION}"
CLI_NAME="datagouv"
BINARY_SUFFIX="windows-amd64"
BINARY="${CLI_NAME}-${BINARY_SUFFIX}.exe"
BINARY_PATH="${ARTIFACTS_DIR}/${BINARY}"
SHA256_PATH="${BINARY_PATH}.sha256"

if [[ ! -f "${BINARY_PATH}" || ! -f "${SHA256_PATH}" ]]; then
  echo "Missing Windows artifact: ${BINARY_PATH} or ${SHA256_PATH}" >&2
  exit 1
fi

SHA256="$(awk '{print $1}' "${SHA256_PATH}" | tr '[:upper:]' '[:lower:]')"

mkdir -p "${OUTPUT_DIR}/tools"

cat > "${OUTPUT_DIR}/${CLI_NAME}.nuspec" <<EOF
<?xml version="1.0" encoding="utf-8"?>
<package xmlns="http://schemas.microsoft.com/packaging/2015/06/nuspec.xsd">
  <metadata>
    <id>${CLI_NAME}</id>
    <version>${VERSION}</version>
    <title>datagouv</title>
    <authors>data.gouv.fr</authors>
    <projectUrl>https://github.com/${REPO}</projectUrl>
    <licenseUrl>https://opensource.org/licenses/MIT</licenseUrl>
    <requireLicenseAcceptance>false</requireLicenseAcceptance>
    <description>CLI for data.gouv.fr</description>
    <summary>Work with datasets, organizations, resources, and topics from your terminal.</summary>
    <tags>datagouv cli data.gouv.fr</tags>
  </metadata>
</package>
EOF

cat > "${OUTPUT_DIR}/tools/chocolateyInstall.ps1" <<EOF
\$ErrorActionPreference = 'Stop'

\$url = '${BASE_URL}/${BINARY}'
\$checksum = '${SHA256}'
\$checksumType = 'sha256'

\$toolsDir = Split-Path -Parent \$MyInvocation.MyCommand.Definition
\$file = Join-Path \$toolsDir '${CLI_NAME}.exe'

\$packageArgs = @{
  packageName   = \$env:ChocolateyPackageName
  fileFullPath  = \$file
  url           = \$url
  checksum      = \$checksum
  checksumType  = \$checksumType
}

Get-ChocolateyWebFile @packageArgs
Install-BinFile -Path \$file -Name '${CLI_NAME}'
EOF

echo "Generated Chocolatey package metadata in ${OUTPUT_DIR}"
