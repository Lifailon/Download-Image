## Download-Mandalorian-Art

PowerShell script for download all albums Mandalorian Art use module **Download-Image** (download images via url using jobs).

Source art: **[StarWars](https://www.starwars.com/search?q=mandalorian+art)**

## Description of all script steps with result output:

### 1. Install module from GitHub repository

```PowerShell
$path = $(($env:PSModulePath -split ";")[0]) + "\Download-Image"
if (Test-Path $path) {
    Remove-Item $path -Force -Recurse
    New-Item -ItemType Directory -Path $path
} else {
    New-Item -ItemType Directory -Path $path
}
Invoke-RestMethod https://raw.githubusercontent.com/Lifailon/Download-Image/main/Download-Image.psm1 -OutFile "$path\Download-Image.psm1"
Import-Module Download-Image
```

### 2. Get array from url links

Parsing the url of the pages that contain illustrations of all the seasons of the show

```PowerShell
$url = "https://www.starwars.com/search?q=mandalorian+art"
$links = (Invoke-WebRequest -Uri $url).Links.href -match "chapter" | Sort-Object -Unique
$links.Count
```

Output: **23** of 24 (there was one episode that didn't have any artwork).

### 3. Download images

Filter all images of the obtained array by **jpeg format** inside the function.

```PowerShell
foreach ($link in $links) {
    Download-Image -url $link
}

Downloaded 10 of 16 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-chapter-10-concept-art-gallery
Downloaded 11 of 17 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-chapter-11-concept-art-gallery
Downloaded 11 of 17 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-chapter-12-concept-art-gallery
Downloaded 10 of 16 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-chapter-13-concept-art-gallery
Downloaded 11 of 17 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-chapter-14-concept-art-gallery
Downloaded 11 of 17 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-chapter-15-concept-art-gallery
Downloaded 12 of 18 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-chapter-18-concept-art-gallery
Downloaded 12 of 18 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-chapter-19-concept-art-gallery
Downloaded 12 of 18 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-chapter-20-concept-art-gallery
Downloaded 12 of 18 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-chapter-21-concept-art-gallery
Downloaded 12 of 18 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-chapter-22-concept-art-gallery
Downloaded 12 of 18 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-chapter-23-concept-art-gallery
Downloaded 9 of 15 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-chapter-4-concept-art-gallery
Downloaded 11 of 17 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-chapter-7-concept-art-gallery
Downloaded 11 of 17 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-chapter-8-concept-art-gallery
Downloaded 12 of 17 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-chapter-9-concept-art-gallery
Downloaded 11 of 17 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-series-the-mandalorian-chapter-1-concept-art-gallery
Downloaded 13 of 18 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-series-the-mandalorian-chapter-17-concept-art-gallery
Downloaded 9 of 15 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-series-the-mandalorian-chapter-2-concept-art-gallery
Downloaded 10 of 16 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-series-the-mandalorian-chapter-3-concept-art-gallery
Downloaded 10 of 16 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-series-the-mandalorian-chapter-5-concept-art-gallery
Downloaded 12 of 18 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-series-the-mandalorian-chapter-6-concept-art-gallery
Downloaded 12 of 18 (skip 5) files to C:\Users\lifailon\Pictures\starwars.com-the-mandalorian-chapter-24-concept-art-gallery

PS C:\Users\lifailon> (Get-History)[-1].Duration.TotalSeconds
98,028722
```

**It took 98 seconds to download 256 images**

### Check number of of downloaded albums and images:

```PowerShell
$folders = Get-ChildItem $home\Pictures | Where-Object Name -match "starwars"
$count_image = 0
foreach ($folder in $folders.FullName) {
    $count_image += (Get-ChildItem $folder).Count
}
Write-Host "Number of downloaded images $count_image in $($folders.Count) folders"

Number of downloaded images 256 in 23 folders
```

### 4. Rename albums

Change the name of the uploaded catalogs to album format and output the result:

```PowerShell
foreach ($folder in $folders) {
    $num = $folder.name -replace "\D"
    Rename-Item -Path $folder.FullName -NewName "Mandalorian-Episode-$num"
}

(Get-ChildItem $home\Pictures | Where-Object Name -match "Mandalorian-Episode").Name |
Sort-Object {[int]($_ -replace '.*-')}

Mandalorian-Episode-1
Mandalorian-Episode-2
Mandalorian-Episode-3
Mandalorian-Episode-4
Mandalorian-Episode-5
Mandalorian-Episode-6
Mandalorian-Episode-7
Mandalorian-Episode-8
Mandalorian-Episode-9
Mandalorian-Episode-10
Mandalorian-Episode-11
Mandalorian-Episode-12
Mandalorian-Episode-13
Mandalorian-Episode-14
Mandalorian-Episode-15
Mandalorian-Episode-17
Mandalorian-Episode-18
Mandalorian-Episode-19
Mandalorian-Episode-20
Mandalorian-Episode-21
Mandalorian-Episode-22
Mandalorian-Episode-23
Mandalorian-Episode-24
```

### Result

![Image alt](https://github.com/Lifailon/Download-Image/blob/main/albums.jpg)
