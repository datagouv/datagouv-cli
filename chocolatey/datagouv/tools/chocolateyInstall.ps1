$ErrorActionPreference = 'Stop'

$url = 'https://github.com/datagouv/datagouv-cli/releases/download/v0.4.2/datagouv-windows-amd64.zip'
$checksum = 'eb20352b4bbf1badcbae145c877b92ad52ada79dd1915c20528cf16a64f005f6'
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
