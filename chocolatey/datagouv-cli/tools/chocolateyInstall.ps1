$ErrorActionPreference = 'Stop'

$url = 'https://github.com/datagouv/datagouv-cli/releases/download/v0.3.0/datagouv-cli-windows-amd64.exe'
$checksum = '3cf504e5f9a13f55f34da0fa9236b5285e1d9092041add66b298a84134bfb401'
$checksumType = 'sha256'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$file = Join-Path $toolsDir 'datagouv-cli.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileFullPath  = $file
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Get-ChocolateyWebFile @packageArgs
Install-BinFile -Path $file -Name 'datagouv-cli'
