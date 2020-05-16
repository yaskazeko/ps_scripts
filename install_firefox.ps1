# Silent Install Firefox 
# Download URL: https://www.mozilla.org/en-US/firefox/all/

# Path for the workdir
$workdir = "c:\installer\"

# Check if work directory exists if not create it

If (Test-Path -Path $workdir -PathType Container){
    Write-Host "$workdir already exists" -ForegroundColor Red
}
ELSE { 
    New-Item -Path $workdir  -ItemType directory
}

# get the installed version of firefox

$FFInstalled = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Mozilla\Mozilla Firefox' | Select 'CurrentVersion').CurrentVersion

# get the latest version of firefox

$FFLatest = ( Invoke-WebRequest  "https://product-details.mozilla.org/1.0/firefox_versions.json" -UseBasicParsing | ConvertFrom-Json ).LATEST_FIREFOX_VERSION


If ($FFInstalled -match $FFLatest){
    Write-Host "Installed - $FFInstalled, Latest - $FFLatest" -ForegroundColor Green    
} 
Else {

    # Download the installer

    $source = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"
    $destination = "$workdir\firefox.exe"

    # Check if Invoke-Webrequest exists otherwise execute WebClient

    if (Get-Command 'Invoke-Webrequest'){
         Invoke-WebRequest $source -OutFile $destination
    }
    else{
        $WebClient = New-Object System.Net.WebClient
        $webclient.DownloadFile($source, $destination)
    }

    # Start the installation

    Start-Process -FilePath "$workdir\firefox.exe" -ArgumentList "/S"

    # Wait XX Seconds for the installation to finish

    Start-Sleep -s 35

    # Remove the installer

    Remove-Item $workdir -Force
}