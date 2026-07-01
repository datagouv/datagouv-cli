#!/usr/bin/env bash
set -euo pipefail

BINARY="${1:-./dist/datagouv}"

if [[ ! -x "$BINARY" ]]; then
  echo "Binary not found or not executable: $BINARY" >&2
  exit 1
fi

echo "Running smoke test on: $BINARY"
"$BINARY" --help
"$BINARY" dataset --help
echo "Smoke test passed."
