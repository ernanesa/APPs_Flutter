#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Valida todos os requisitos de publicação antes de submeter ao Google Play Console.

.DESCRIPTION
    Script de validação pré-submissão que verifica:
    - AAB gerado e tamanho
    - Ícone 512x512 presente
    - Screenshots mínimos (2)
    - URL da política de privacidade acessível
    - Arquivos i18n completos (11 idiomas)
    - Feature graphic presente

.PARAMETER AppName
    Nome do app (pasta) a ser validado. Ex: bmi_calculator

.EXAMPLE
    .\validate_publication.ps1 -AppName "bmi_calculator"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$AppName
)

$baseDir = "C:\Users\Ernane\Personal\APPs_Flutter"
$appDir = "$baseDir\$AppName"
$pubDir = "$baseDir\DadosPublicacao\$AppName"
$errors = @()
$warnings = @()
$passed = 0
$total = 6

Write-Host "`n🔍 Validando $AppName para publicação...`n" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor DarkGray

# 1. Verificar AAB existe
Write-Host "`n1. Verificando AAB..." -NoNewline
if (Test-Path "$pubDir\app-release.aab") {
    $size = [math]::Round((Get-Item "$pubDir\app-release.aab").Length / 1MB, 2)
    Write-Host " ✅ ($size MB)" -ForegroundColor Green
    $passed++
    if ($size -gt 150) { $warnings += "⚠️ AAB > 150MB - pode ser rejeitado" }
} else { 
    Write-Host " ❌" -ForegroundColor Red
    $errors += "AAB não encontrado em $pubDir\app-release.aab" 
}

# 2. Verificar ícone 512x512
Write-Host "2. Verificando ícone 512x512..." -NoNewline
if (Test-Path "$pubDir\store_assets\icon_512.png") {
    Write-Host " ✅" -ForegroundColor Green
    $passed++
} else {
    Write-Host " ❌" -ForegroundColor Red
    $errors += "Ícone 512x512 não encontrado em $pubDir\store_assets\icon_512.png"
}

# 3. Verificar feature graphic
Write-Host "3. Verificando feature graphic..." -NoNewline
if (Test-Path "$pubDir\store_assets\feature_graphic.png") {
    Write-Host " ✅" -ForegroundColor Green
    $passed++
} else {
    Write-Host " ⚠️ (opcional)" -ForegroundColor Yellow
    $warnings += "Feature graphic não encontrado (recomendado)"
}

# 4. Verificar screenshots (mínimo 2)
Write-Host "4. Verificando screenshots..." -NoNewline
$screenshots = Get-ChildItem "$pubDir\store_assets\screenshots\*.png" -ErrorAction SilentlyContinue
if ($screenshots.Count -ge 2) {
    Write-Host " ✅ ($($screenshots.Count) encontrados)" -ForegroundColor Green
    $passed++
    
    # Verificar aspect ratio
    Add-Type -AssemblyName System.Drawing
    $badRatio = @()
    foreach ($ss in $screenshots) {
        try {
            $img = [System.Drawing.Image]::FromFile($ss.FullName)
            $ratio = [math]::Round($img.Width / $img.Height, 4)
            $expected = [math]::Round(9/16, 4)
            if ($ratio -ne $expected) {
                $badRatio += "$($ss.Name) ($($img.Width)x$($img.Height))"
            }
            $img.Dispose()
        } catch {}
    }
    if ($badRatio.Count -gt 0) {
        $warnings += "Screenshots com aspect ratio incorreto: $($badRatio -join ', ')"
    }
} else {
    Write-Host " ❌ ($($screenshots.Count)/2 mínimo)" -ForegroundColor Red
    $errors += "Mínimo 2 screenshots necessários"
}

# 5. Verificar política de privacidade URL
Write-Host "5. Verificando política de privacidade URL..." -NoNewline
$appNameForUrl = $AppName.Replace('_', '-')
$privacyUrl = "https://sites.google.com/view/sarezende-$appNameForUrl-privacy"
try {
    $response = Invoke-WebRequest -Uri $privacyUrl -Method Head -TimeoutSec 10 -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host " ✅" -ForegroundColor Green
        $passed++
    } else {
        Write-Host " ❌ (status $($response.StatusCode))" -ForegroundColor Red
        $errors += "Política de privacidade retornou status $($response.StatusCode)"
    }
} catch {
    Write-Host " ❌" -ForegroundColor Red
    $errors += "Política de privacidade inacessível: $privacyUrl"
}

# 6. Verificar i18n (11 idiomas)
Write-Host "6. Verificando traduções i18n..." -NoNewline
$arbFiles = Get-ChildItem "$appDir\lib\l10n\app_*.arb" -ErrorAction SilentlyContinue
if ($arbFiles.Count -ge 11) {
    Write-Host " ✅ ($($arbFiles.Count) idiomas)" -ForegroundColor Green
    $passed++
} elseif ($arbFiles.Count -gt 0) {
    Write-Host " ⚠️ ($($arbFiles.Count)/11 idiomas)" -ForegroundColor Yellow
    $warnings += "Apenas $($arbFiles.Count) idiomas configurados (recomendado: 11)"
} else {
    Write-Host " ❌ (nenhum arquivo .arb)" -ForegroundColor Red
    $errors += "Nenhum arquivo de tradução encontrado em $appDir\lib\l10n\"
}

# Resultado final
Write-Host "`n" + ("=" * 60) -ForegroundColor DarkGray
Write-Host "`n📊 RESULTADO: $passed/$total verificações passaram`n"

if ($errors.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host "✅ APROVADO: Pronto para publicação!" -ForegroundColor Green
    Write-Host "`nURL da política: $privacyUrl`n"
    exit 0
} elseif ($errors.Count -eq 0) {
    Write-Host "⚠️ APROVADO COM AVISOS:" -ForegroundColor Yellow
    $warnings | ForEach-Object { Write-Host "  $_" -ForegroundColor Yellow }
    Write-Host "`nURL da política: $privacyUrl`n"
    exit 0
} else {
    Write-Host "❌ BLOQUEADO: Corrija os erros antes de submeter:" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host "  ❌ $_" -ForegroundColor Red }
    if ($warnings.Count -gt 0) {
        Write-Host "`n  Avisos:" -ForegroundColor Yellow
        $warnings | ForEach-Object { Write-Host "  $_" -ForegroundColor Yellow }
    }
    Write-Host ""
    exit 1
}
