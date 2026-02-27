# Script para atualizar IDs do AdMob do Compound Interest Calculator
# Execute este script após obter os IDs no AdMob
# 
# Uso: .\tools\update_compound_admob_ids.ps1

param(
    [Parameter(Mandatory=$true)]
    [string]$AppId,
    
    [Parameter(Mandatory=$true)]
    [string]$BannerId,
    
    [Parameter(Mandatory=$true)]
    [string]$InterstitialId,
    
    [Parameter(Mandatory=$true)]
    [string]$AppOpenId
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Atualizando IDs do AdMob" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "App ID: $AppId" -ForegroundColor Yellow
Write-Host "Banner ID: $BannerId" -ForegroundColor Yellow
Write-Host "Interstitial ID: $InterstitialId" -ForegroundColor Yellow
Write-Host "App Open ID: $AppOpenId" -ForegroundColor Yellow
Write-Host ""

$basePath = "apps\finance\compound_interest_calculator"
$adServicePath = "$basePath\lib\services\ad_service.dart"
$manifestPath = "$basePath\android\app\src\main\AndroidManifest.xml"

# Verificar se arquivos existem
if (-not (Test-Path $adServicePath)) {
    Write-Host "ERRO: Arquivo ad_service.dart não encontrado!" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $manifestPath)) {
    Write-Host "ERRO: Arquivo AndroidManifest.xml não encontrado!" -ForegroundColor Red
    exit 1
}

Write-Host "Atualizando ad_service.dart..." -ForegroundColor Green

# Ler conteúdo do arquivo
$content = Get-Content $adServicePath -Raw

# Substituir App ID
$content = $content -replace "return 'ca-app-pub-XXXXXXX~YYYYYYY'; // TODO: Replace with real ID", "return '$AppId'; // Production"

# Substituir IDs das unidades de anúncio
$content = $content -replace "return 'ca-app-pub-XXXXXXX/ZZZZZZ'; // TODO: Replace with real ID", "return '$BannerId'; // Production Banner"

# Como há múltiplas ocorrências, fazer substituições mais específicas
$lines = $content -split "`n"
$updated = @()
$bannerDone = $false
$interstitialDone = $false
$appOpenDone = $false

foreach ($line in $lines) {
    if ($line -match "bannerAdUnitId" -and -not $bannerDone) {
        # Próximas linhas vão ter o ID
        $updated += $line
        continue
    }
    
    if ($line -match "return 'ca-app-pub-XXXXXXX/ZZZZZZ';" -and $line -match "TODO" -and -not $bannerDone) {
        $updated += "    return '$BannerId'; // Production Banner"
        $bannerDone = $true
        continue
    }
    
    if ($line -match "interstitialAdUnitId" -and -not $interstitialDone) {
        $updated += $line
        continue
    }
    
    if ($line -match "return 'ca-app-pub-XXXXXXX/ZZZZZZ';" -and $line -match "TODO" -and -not $interstitialDone -and $bannerDone) {
        $updated += "    return '$InterstitialId'; // Production Interstitial"
        $interstitialDone = $true
        continue
    }
    
    if ($line -match "appOpenAdUnitId" -and -not $appOpenDone) {
        $updated += $line
        continue
    }
    
    if ($line -match "return 'ca-app-pub-XXXXXXX/ZZZZZZ';" -and $line -match "TODO" -and -not $appOpenDone -and $interstitialDone) {
        $updated += "    return '$AppOpenId'; // Production App Open"
        $appOpenDone = $true
        continue
    }
    
    $updated += $line
}

# Salvar arquivo
$updated -join "`n" | Set-Content $adServicePath -NoNewline

Write-Host "✓ ad_service.dart atualizado!" -ForegroundColor Green
Write-Host ""
Write-Host "Atualizando AndroidManifest.xml..." -ForegroundColor Green

# Atualizar AndroidManifest
$manifestContent = Get-Content $manifestPath -Raw
$manifestContent = $manifestContent -replace 'android:value="ca-app-pub-3940256099942544~3347511713"', "android:value=`"$AppId`""
$manifestContent | Set-Content $manifestPath -NoNewline

Write-Host "✓ AndroidManifest.xml atualizado!" -ForegroundColor Green
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "CONCLUÍDO COM SUCESSO!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor Yellow
Write-Host "1. Revisar as mudanças: git diff" -ForegroundColor White
Write-Host "2. Testar o app: cd $basePath && flutter run" -ForegroundColor White
Write-Host "3. Fazer build de release: flutter build apk --release" -ForegroundColor White
Write-Host ""
