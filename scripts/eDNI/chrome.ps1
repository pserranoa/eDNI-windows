$source = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
Write-Output "Installing Chrome"

$workdir = "c:\installer\"
If ( !(Test-Path -Path $workdir -PathType Container))
    { New-Item -Path $workdir  -ItemType directory }


$destination = "$workdir\chrome_installer.exe"
Start-BitsTransfer -Source $source -Destination $destination -TransferType Download -Priority High
Start-Process -FilePath "$workdir\chrome_installer.exe" -ArgumentList "/silent /install" -Wait
Start-Sleep -s 30
rm -Force $workdir/chrome_installer*