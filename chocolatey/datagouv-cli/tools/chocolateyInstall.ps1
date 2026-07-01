$ErrorActionPreference = 'Stop'

$url = 'https://github.com/datagouv/datagouv-cli/releases/download/v0.2.1/datagouv-cli-windows-amd64.exe'
$checksum = '0000000000000000000000000000000000000000000000000000000000000000'
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
