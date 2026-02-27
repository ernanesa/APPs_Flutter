$sourcePath = 'c:\Users\Ernane\Personal\APPs_Flutter_2\apps\productivity\pomodoro_timer\publishing\store_assets\icon_512.png'
$baseDir = 'c:\Users\Ernane\Personal\APPs_Flutter_2\apps\productivity\pomodoro_timer\android\app\src\main\res'

$sizes = @{
    'mipmap-mdpi' = 48
    'mipmap-hdpi' = 72
    'mipmap-xhdpi' = 96
    'mipmap-xxhdpi' = 144
    'mipmap-xxxhdpi' = 192
}

Add-Type -AssemblyName System.Drawing

function Resize-Icon {
    param([string]$Source, [string]$Dest, [int]$Size)
    $sourceImage = [System.Drawing.Image]::FromFile($Source)
    $bitmap = New-Object System.Drawing.Bitmap($Size, $Size)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.DrawImage($sourceImage, 0, 0, $Size, $Size)
    
    if (Test-Path $Dest) {
        # Force removal to avoid access issues
        Remove-Item $Dest -Force
    }
    
    $bitmap.Save($Dest, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bitmap.Dispose()
    $sourceImage.Dispose()
}

foreach ($folder in $sizes.Keys) {
    $targetDir = Join-Path $baseDir $folder
    $size = $sizes[$folder]
    
    if (Test-Path $targetDir) {
        # Replace ic_launcher.png
        $targetFile = Join-Path $targetDir "ic_launcher.png"
        Write-Host "Resizing $size x $size -> $targetFile"
        Resize-Icon -Source $sourcePath -Dest $targetFile -Size $size
        
        # Replace ic_launcher_round.png if it exists
        $roundFile = Join-Path $targetDir "ic_launcher_round.png"
        if (Test-Path $roundFile) {
            Write-Host "Resizing Round $size x $size -> $roundFile"
            Resize-Icon -Source $sourcePath -Dest $roundFile -Size $size
        }
    } else {
        Write-Warning "Directory $targetDir not found."
    }
}

Write-Host "Icon replacement completed successfully."
