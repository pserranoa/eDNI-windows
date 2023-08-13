$source = "https://estaticos.redsara.es/comunes/autofirma/currentversion/AutoFirma64MSI.zip"
Write-Output 'Installing AutoFirma'

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

$workdir = "c:\installer\"
If ( !(Test-Path -Path $workdir -PathType Container))
    { New-Item -Path $workdir  -ItemType directory }

$destination = "$workdir\AutoFirma64MSI.zip"
Start-BitsTransfer -Source $source -Destination $destination  -TransferType Download -Priority High
Unzip $destination $workdir
$executable = Get-ChildItem -Path $workdir -Filter "AutoFirma*.msi" | %{$_.FullName}
Start-Process -FilePath $executable -ArgumentList "/quiet FIREFOX_SECURITY_ROOTS=true" -Wait
Start-Sleep -s 30
rm -Force $workdir/AutoFirma*.msi
rm -Force $workdir\AutoFirma64MSI.zip
