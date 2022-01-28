# Config
Set-PSReadlineOption -BellStyle None
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Prompt
function prompt {
    $currentDirectory = $(Get-Location)
    $UncRoot = $currentDirectory.Drive.DisplayRoot
    write-host " $UncRoot" -ForegroundColor Gray
    # Convert-Path needed for pure UNC-locations
    write-host "PS $(Convert-Path $currentDirectory)"
    return "> "
}

# Aliaces
Set-Alias ~ $HOME
Set-Alias open Invoke-Item
