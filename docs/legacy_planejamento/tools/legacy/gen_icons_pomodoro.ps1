
Add-Type -AssemblyName System.Drawing

$storeAssetsDir = "C:\Users\Ernane\Personal\APPs_Flutter\DadosPublicacao\pomodoro_timer\store_assets"
if (-not (Test-Path $storeAssetsDir)) { New-Item -ItemType Directory -Path $storeAssetsDir -Force | Out-Null }

$iconPath = "$storeAssetsDir\icon_512.png"

# Cores
$purpleColor = [System.Drawing.Color]::FromArgb(255, 107, 79, 160)
$greenColor = [System.Drawing.Color]::FromArgb(255, 102, 187, 106)
$whiteColor = [System.Drawing.Color]::White

# Setup Canvas
$bitmap = New-Object System.Drawing.Bitmap(512, 512)
$g = [System.Drawing.Graphics]::FromImage($bitmap)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

# Design: Ring style
$purplePen = New-Object System.Drawing.Pen($purpleColor, 60)
$g.DrawEllipse($purplePen, 50, 50, 412, 412)

# Green Accent Arc (Top)
$greenPen = New-Object System.Drawing.Pen($greenColor, 60)
$greenPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$greenPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$g.DrawArc($greenPen, 50, 50, 412, 412, -90, 45)

# Hands
$handPen = New-Object System.Drawing.Pen($purpleColor, 40)
$handPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$handPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round

# Hour hand (Up)
$g.DrawLine($handPen, 256, 256, 256, 150)
# Minute hand (Right)
$g.DrawLine($handPen, 256, 256, 360, 256)

# Center Dot
$centerBrush = New-Object System.Drawing.SolidBrush($purpleColor)
$g.FillEllipse($centerBrush, 236, 236, 40, 40)

$bitmap.Save($iconPath, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bitmap.Dispose()

Write-Host "✅ Created icon_512.png at $iconPath"

# Mipmaps
$appPath = "C:\Users\Ernane\Personal\APPs_Flutter\pomodoro_timer"
$sourceImage = [System.Drawing.Image]::FromFile($iconPath)
$densities = @{ "mdpi"=48; "hdpi"=72; "xhdpi"=96; "xxhdpi"=144; "xxxhdpi"=192 }

foreach ($d in $densities.GetEnumerator()) {
    $tPath = "$appPath\android\app\src\main\res\mipmap-$($d.Key)\ic_launcher.png"
    # Ensure dir exists
    $dir = Split-Path $tPath -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

    $bm = New-Object System.Drawing.Bitmap($d.Value, $d.Value)
    $gr = [System.Drawing.Graphics]::FromImage($bm)
    $gr.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $gr.DrawImage($sourceImage, 0, 0, $d.Value, $d.Value)
    $bm.Save($tPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $gr.Dispose(); $bm.Dispose()
    Write-Host "✅ Created mipmap-$($d.Key)"
}
$sourceImage.Dispose()
