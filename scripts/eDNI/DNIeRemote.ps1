$source = "https://www.dnielectronico.es/descargas/Apps/Instalador_DNIeRemote_x64.exe"
Write-Output "Installing DNIeRemote"
# download with firefox to avoid the "This program might not have installed correctly" message
Start-Process firefox -ArgumentList "$source"
$theFile = "c:\Users\vagrant\Downloads\Instalador_DNIeRemote_x64.exe"
while(!(Test-Path $theFile)) {
  Write-Output "Waiting for $theFile"
  Start-Sleep -s 5;
}
Start-Process -FilePath $theFile -ArgumentList "/silent" -Wait
Start-Sleep -s 30
rm -Force $theFile
# close firefox
taskkill /F /IM firefox.exe /T