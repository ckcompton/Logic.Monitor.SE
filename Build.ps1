$Global:ErrorActionPreference = 'Stop'
$Global:VerbosePreference = 'SilentlyContinue'

$buildVersion = $env:BUILD_VERSION
$manifestPath = "./Logic.Monitor.SE.psd1"
$publicFuncFolderPath = './Public'

$ps1xmlFiles = Get-ChildItem -Path ./ -Filter *.ps1xml
foreach ($ps1xml in $ps1xmlFiles) {
  [xml]$xml = Get-Content -Path $ps1xml.FullName
  $null = $xml.Schemas.Add($null, 'https://raw.githubusercontent.com/PowerShell/PowerShell/master/src/Schemas/Format.xsd')
  $null = $xml.Schemas.Add($null, 'https://raw.githubusercontent.com/PowerShell/PowerShell/master/src/Schemas/Types.xsd')
  $xml.Validate( { throw "File '$($ps1xml.Name)' schema error: $($_.Message)" })
}

if (!(Get-PackageProvider | Where-Object { $_.Name -eq 'NuGet' })) {
    Install-PackageProvider -Name NuGet -force | Out-Null
}
Import-PackageProvider -Name NuGet -force | Out-Null

if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne 'Trusted') {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

if(!(Get-Module Logic.Monitor -ListAvailable)){
    Install-Module Logic.Monitor -Force -Confirm:$false
}
if(!(Get-Module PSWriteHTML -ListAvailable)){
    Install-Module PSWriteHTML -Force -Confirm:$false
}
if(!(Get-Module Pode -ListAvailable)){
    Install-Module Pode -Force -Confirm:$false
}

$manifestContent = (Get-Content -Path $manifestPath -Raw) -replace '<ModuleVersion>', $buildVersion

if ((Test-Path -Path $publicFuncFolderPath) -and ($publicFunctionNames = Get-ChildItem -Path $publicFuncFolderPath -Filter '*.ps1' | Select-Object -ExpandProperty BaseName)) {
    $funcStrings = "'$($publicFunctionNames -join "','")'"
} else {
    $funcStrings = $null
}

$manifestContent = $manifestContent -replace "'<FunctionsToExport>'", $funcStrings
$manifestContent | Set-Content -Path $manifestPath
