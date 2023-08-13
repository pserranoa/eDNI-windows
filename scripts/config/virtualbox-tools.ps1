Write-Output "Installing Virtualbox addons"
if (Test-Path "C:\Users\vagrant\VBoxGuestAdditions.iso") {
  Move-Item -Force C:\Users\vagrant\VBoxGuestAdditions.iso C:\Windows\Temp
}

if (!(Test-Path "C:\Windows\Temp\VBoxGuestAdditions.iso")) {
  Try {
    $pageContentLinks = (Invoke-WebRequest('https://download.virtualbox.org/virtualbox') -UseBasicParsing).Links | where-object { $_.href -Match "[0-9]" } | Select-Object href |  where-object { $_.href -NotMatch "BETA" } |  where-object { $_.href -NotMatch "RC" } |   where-object { $_.href -Match "[0-9]\.[0-9]" } | ForEach-Object { $_.href.Trim('/') }
    $versionObject = $pageContentLinks | ForEach-Object { new-object System.Version ($_) } | sort-object -Descending | select-object -First 1 -Property:Major, Minor, Build
    $newestVersion = $versionObject.Major.ToString() + "." + $versionObject.Minor.ToString() + "." + $versionObject.Build.ToString() | out-string
    $newestVersion = $newestVersion.TrimEnd("`r?`n")

    $nextURISubdirectoryObject = (Invoke-WebRequest("https://download.virtualbox.org/virtualbox/$newestVersion/") -UseBasicParsing).Links | Select-Object href | where-object { $_.href -Match "GuestAdditions" }
    $nextUriSubdirectory = $nextURISubdirectoryObject.href | Out-String
    $nextUriSubdirectory = $nextUriSubdirectory.TrimEnd("`r?`n")
    $newestVboxToolsURL = "https://download.virtualbox.org/virtualbox/$newestVersion/$nextUriSubdirectory"
    Write-Output "The latest version of VirtualBox tools has been determined to be downloadable from $newestVboxToolsURL"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile("$newestVboxToolsURL", 'C:\Windows\Temp\VBoxGuestAdditions.iso')
  }
  Catch {
    Write-Output "Unable to determine the latest version of VBox tools. Falling back to hardcoded URL."
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://download.virtualbox.org/virtualbox/6.1.38/VBoxGuestAdditions_6.1.38.iso', 'C:\Windows\Temp\VBoxGuestAdditions.iso')
  }
}

Mount-DiskImage -ImagePath "C:\Windows\Temp\VBoxGuestAdditions.iso"
$ISODrive = (Get-DiskImage -ImagePath "C:\Windows\Temp\VBoxGuestAdditions.iso" | Get-Volume).DriveLetter
$Binary = $ISODrive + ":\VBoxWindowsAdditions.exe"
$Arguments = "/S"
Start-Process $Binary -ArgumentList $Arguments -Wait

