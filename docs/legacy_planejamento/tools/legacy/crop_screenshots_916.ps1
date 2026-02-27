param(
    [Parameter(Mandatory=$true)]
    [string]$ScreenshotsDir
)

Add-Type -AssemblyName System.Drawing

$screenshots = Get-ChildItem "$ScreenshotsDir\*.png"
$count = 0
$targetRatio = 9.0 / 16.0  # 0.5625

Write-Host "🔧 Corrigindo aspect ratio de screenshots para 9:16..." -ForegroundColor Cyan
Write-Host ""

foreach ($file in $screenshots) {
    $original = [System.Drawing.Image]::FromFile($file.FullName)
    $currentRatio = $original.Width / $original.Height
    
    if ([math]::Round($currentRatio, 4) -ne [math]::Round($targetRatio, 4)) {
        # Crop vertical (remover topo/base)
        $newHeight = [int]($original.Width / $targetRatio)
        $cropY = [int](($original.Height - $newHeight) / 2)
        $cropRect = [System.Drawing.Rectangle]::new(0, $cropY, $original.Width, $newHeight)
        
        $bitmap = New-Object System.Drawing.Bitmap($original)
        $cropped = $bitmap.Clone($cropRect, $bitmap.PixelFormat)
        
        # Fechar original antes de salvar
        $original.Dispose()
        
        # Salvar arquivo corrigido
        $tempPath = "$($file.FullName).tmp"
        $cropped.Save($tempPath, [System.Drawing.Imaging.ImageFormat]::Png)
        $cropped.Dispose()
        $bitmap.Dispose()
        
        # Substituir original
        Remove-Item $file.FullName -Force
        Move-Item $tempPath $file.FullName
        
        Write-Host "✅ $($file.Name)" -ForegroundColor Green
        Write-Host "   1080x2280 → 1080x1920" -ForegroundColor Gray
        
        $count++
    } else {
        Write-Host "⏭️  $($file.Name) - Já está correto (9:16)" -ForegroundColor Yellow
        $original.Dispose()
    }
}

Write-Host ""
Write-Host "🎯 Total de screenshots corrigidos: $count" -ForegroundColor Green
