<#
.SYNOPSIS
My personalized script to migrate to a new Windows PC.

.DESCRIPTION
:)

.NOTES
I don'tt migrate fron PC's often, o this script might get updated or be incomplete.
#>

begin {
    # befor this runs, winget should be installed
    if ($null -eq (Get-Command "winget" -ErrorAction SilentlyContinue)) {
        Write-Output "Winget wasn't found"
        exit 1
    } 

    if (@(winget --version)-le "v1.1") {
        Write-Output "Winget was found, but the version is older that spected"
        exit 2
    }

    # start
    $config = Get-Content .\config.json | ConvertFrom-Json;

    # Create directories
    foreach ($dir in $config.dirsToCreate) {
        New-Item -Path $dir -ItemType Directory -ErrorAction Ignore
    }

    # Setup default paths
    . .\utils\KnownFolderPath.ps1
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
}
