# Script para criar Feature Graphic do Pomodoro Timer
Add-Type -AssemblyName System.Drawing

$width = 1024
$height = 500
$bitmap = New-Object System.Drawing.Bitmap($width, $height)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias

# Background gradient vermelho (Tom Tomate Pomodoro)
$rect = New-Object System.Drawing.Rectangle(0, 0, $width, $height)
$brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $rect, 
    [System.Drawing.Color]::FromArgb(231, 76, 60),  # Vermelho claro
    [System.Drawing.Color]::FromArgb(192, 57, 43),  # Vermelho escuro
    45
)
$graphics.FillRectangle($brush, $rect)

# Fontes
$fontFamily = New-Object System.Drawing.FontFamily("Segoe UI")
$fontBold = New-Object System.Drawing.Font($fontFamily, 68, [System.Drawing.FontStyle]::Bold)
$fontRegular = New-Object System.Drawing.Font($fontFamily, 30, [System.Drawing.FontStyle]::Regular)
$whiteBrush = [System.Drawing.Brushes]::White

# Título "Pomodoro Timer"
$title = "Pomodoro Timer"
$titleSize = $graphics.MeasureString($title, $fontBold)
$titleX = ($width - $titleSize.Width) / 2
$titleY = 160
$graphics.DrawString($title, $fontBold, $whiteBrush, $titleX, $titleY)

# Subtítulo "Focus · Work · Achieve"
$subtitle = "Focus · Work · Achieve"
$subtitleSize = $graphics.MeasureString($subtitle, $fontRegular)
$subtitleX = ($width - $subtitleSize.Width) / 2
$subtitleY = 290
$graphics.DrawString($subtitle, $fontRegular, $whiteBrush, $subtitleX, $subtitleY)

# Salvar
$outputPath = "C:\Users\Ernane\Personal\APPs_Flutter\DadosPublicacao\pomodoro_timer\store_assets\feature_graphic.png"
$bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)

# Cleanup
$graphics.Dispose()
$bitmap.Dispose()
$fontBold.Dispose()
$fontRegular.Dispose()
$brush.Dispose()

Write-Host "✅ Feature Graphic criado: $outputPath ($width x $height)"
