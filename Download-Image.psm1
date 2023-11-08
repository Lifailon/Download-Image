function Download-Image {
param (
    [Parameter(Mandatory = $True)]$url
)
    $folder = $url -replace "^.+://" -replace "www." -replace "/","-" -replace "-$" # replace www
    $path = "$home\Pictures\$folder"
    if (Test-Path $path) {
        Remove-Item $path -Recurse -Force
        New-Item -ItemType Directory $path > $null
    } else {
        New-Item -ItemType Directory $path > $null
    }
    $irm = Invoke-WebRequest -Uri $url
    foreach ($img in $irm.Images.src) {
        if ($img -match "jpeg") { # filter images by jpeg format
            $name = $img -replace ".+/" -replace "\?.+$" # replace ".jpeg.+",".jpeg"
            Start-Job {
                Invoke-WebRequest $using:img -OutFile "$using:path\$using:name"
            } > $null
        } else {
        $count_skip += 1 # skip counter
        }
    }
    while ($True){
        $status_job = (Get-Job).State[-1]
        if ($status_job -like "Completed"){
        Get-Job | Remove-Job -Force
        break
    }}
    $count_all = $irm.Images.src.Count
    $count_down = (Get-Item $path\*).count
    "Downloaded $count_down of $count_all (skip $count_skip) files to $path"
}
