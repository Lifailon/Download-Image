# Install module from GitHub repository
$path = $(($env:PSModulePath -split ";")[0]) + "\Download-Image"
if (Test-Path $path) {
    Remove-Item $path -Force -Recurse
    New-Item -ItemType Directory -Path $path
} else {
    New-Item -ItemType Directory -Path $path
}
Invoke-RestMethod https://raw.githubusercontent.com/Lifailon/Download-Image/main/Download-Image.psm1 -OutFile "$path\Download-Image.psm1"
Import-Module Download-Image

# Get array from url links
$url = "https://www.starwars.com/search?q=mandalorian+art"
$links = (Invoke-WebRequest -Uri $url).Links.href -match "chapter" | Sort-Object -Unique

# Download images
foreach ($link in $links) {
    Download-Image -url $link
}

# Check number of of downloaded albums and images
$folders = Get-ChildItem $home\Pictures | Where-Object Name -match "starwars"
$count_image = 0
foreach ($folder in $folders.FullName) {
    $count_image += (Get-ChildItem $folder).Count
}
Write-Host "Number of downloaded images $count_image in $($folders.Count) folders"

# Rename albums
foreach ($folder in $folders) {
    $num = $folder.name -replace "\D"
    Rename-Item -Path $folder.FullName -NewName "Mandalorian-Episode-$num"
}
(Get-ChildItem $home\Pictures | Where-Object Name -match "Mandalorian-Episode").Name |
Sort-Object {[int]($_ -replace '.*-')}