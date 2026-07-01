param(
    [string]$DistDir = "./dist/datagouv",
    [string]$Output = "./dist/datagouv-windows-amd64.zip"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $DistDir -PathType Container)) {
    Write-Error "Distribution directory not found: $DistDir"
    exit 1
}

if (Test-Path -LiteralPath $Output) {
    Remove-Item -LiteralPath $Output -Force
}

Compress-Archive -Path $DistDir -DestinationPath $Output

$hash = (Get-FileHash -LiteralPath $Output -Algorithm SHA256).Hash.ToLower()
Set-Content -Path "${Output}.sha256" -Value $hash -NoNewline
Write-Host "Packaged $Output"
