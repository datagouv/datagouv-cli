$ErrorActionPreference = 'Stop'

$url = 'https://github.com/datagouv/datagouv-cli/releases/download/v0.4.0/datagouv-windows-amd64.exe'
$checksum = 'd13fbac37789cd1af4ac70ae27b1fcc8ea3cdaa4d8e9ce05c5b28054f912c398'
$checksumType = 'sha256'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$file = Join-Path $toolsDir 'datagouv.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileFullPath  = $file
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Get-ChocolateyWebFile @packageArgs
Install-BinFile -Path $file -Name 'datagouv'
