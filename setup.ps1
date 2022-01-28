#Requires -RunAsAdministrator

<#
.SYNOPSIS
My personalized script to migrate to a new Windows PC.

.DESCRIPTION
:)

.NOTES
I don'tt migrate fron PC's often, o this script might get updated or be incomplete.
#>

# Befor this runs, winget should be installed
if ($null -eq (Get-Command "winget" -ErrorAction SilentlyContinue)) {
    Write-Output "Winget wasn't found"
    exit 1
}

if (@(winget --version)-le "v1.1") {
    Write-Output "Winget was found, but the version is older that spected"
    exit 2
}

# Fisrts lets debloat windows
Import-Module .\utils\Debloater.ps1

UnincstallOneDrive
DebloatBlacklist


# Load the config file
$config = Get-Content .\config.json | ConvertFrom-Json;

# Create directories
foreach ($dir in $config.dirsToCreate) {
    New-Item -Path $dir -ItemType Directory -ErrorAction Ignore
}

# Setup default paths
Import-Module  .\utils\KnownFolderPath.psm1
foreach ($category in $config.defaultPaths.PSObject.Properties) {
    Set-KnownFolderPath -KnownFolder $category.Name -Path $category.Value
}

# Install programs with winget
foreach ($category in $config.programs.PSObject.Properties) {
    $value = $category.Value
    if ($value -is [System.Object[]]) {
        foreach ($id in $value) {
            Install-Program $id $id
        }
    }
    elseif ($value -is [System.Management.Automation.PSCustomObject]) {
        foreach ($element in $value.PSObject.Properties) {
            Install-Program $element.Value $element.Name
        }
    }
}

# Aditional userfull configuration found online
# from https://github.com/Sycnex/Windows10Debloater

# Disable search on the web on the start menu
$WebSearch = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" BingSearchEnabled -Value 0
If (!(Test-Path $WebSearch)) {
    New-Item $WebSearch
}
Set-ItemProperty $WebSearch DisableWebSearch -Value 1

#Stops Cortana from being used as part of your Windows Search Function
$Search = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
If (Test-Path $Search) {
    Set-ItemProperty $Search AllowCortana -Value 0
}


# Run the SSH agent automatically
Get-Service -Name ssh-agent | Set-Service -StartupType Automatic
