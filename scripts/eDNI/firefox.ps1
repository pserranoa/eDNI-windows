$source = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=es-ES"
Write-Output "Installing Firefox"

$workdir = "c:\installer\"
If ( !(Test-Path -Path $workdir -PathType Container))
    { New-Item -Path $workdir  -ItemType directory }


$destination = "$workdir\firefox.exe"
Start-BitsTransfer -Source $source -Destination $destination -TransferType Download -Priority High
Start-Process -FilePath "$workdir\firefox.exe" -ArgumentList "/S" -Wait
Start-Sleep -s 30
rm -Force $workdir/firefox*