$ErrorActionPreference = 'Stop'

$url = 'https://github.com/datagouv/datagouv-cli/releases/download/v0.4.1/datagouv-windows-amd64.zip'
$checksum = '818d52e2437274b8459ff714c8ef133f2061b69ccd3106cc06c6bd4455e129a3'
$checksumType = 'sha256'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$installDir = Join-Path $toolsDir 'datagouv'
$file = Join-Path $installDir 'datagouv.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Install-ChocolateyZipPackage @packageArgs
Install-BinFile -Path $file -Name 'datagouv'
