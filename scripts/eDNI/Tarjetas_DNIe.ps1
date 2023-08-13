$source = "https://www.dnielectronico.es/descargas/Apps/Instalador_DNIeRemote_x64.exe"
$workdir = "c:\installer\"
If ( !(Test-Path -Path $workdir -PathType Container))
    { New-Item -Path $workdir  -ItemType directory }

$destination = "$workdir\Instalador_Tarjetas_DNIe_x64.exe"
Start-BitsTransfer -Source $source -Destination $destination -TransferType Download -Priority High
Start-Process -FilePath "$workdir\Instalador_Tarjetas_DNIe_x64.exe" -ArgumentList "/silent" -Wait
Start-Sleep -s 30
rm -Force $workdir/Instalador_Tarjetas_DNIe*