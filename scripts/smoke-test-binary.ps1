param(
    [string]$Binary = "./dist/datagouv-cli.exe"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $Binary)) {
    Write-Error "Binary not found: $Binary"
    exit 1
}

Write-Host "Running smoke test on: $Binary"
& $Binary --help
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

& $Binary dataset --help
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Smoke test passed."
