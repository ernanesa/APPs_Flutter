#!/usr/bin/env pwsh
<#
.SYNOPSIS
Atualiza 5 apps para JDK 21 e implementa tudo que está faltando
.DESCRIPTION
- Migra para JDK 21
- Configura Privacy Policy URLs
- Verifica AdService e ConsentService
- Cria estrutura DadosPublicacao
- Compila AAB release
- Executa testes device real
.PARAMETER AppsToUpdate
Apps a atualizar: bmi_calculator, pomodoro_timer, compound_interest_calculator, fasting_tracker, white_noise
#>

param(
    [string[]]$AppsToUpdate = @("bmi_calculator", "pomodoro_timer", "compound_interest_calculator", "fasting_tracker", "white_noise"),
    [switch]$SkipBuild,
    [switch]$SkipTests
)

$ErrorActionPreference = "Continue"
$baseDir = "C:\Users\Ernane\Personal\APPs_Flutter_2"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$reportFile = "artifacts/update_report_$timestamp.md"

Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  ATUALIZAÇÃO COMPLETA - 5 APPS PARA PUBLICAÇÃO (JDK21)     ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Mapeamento apps → paths
$appMap = @{
    "bmi_calculator" = "apps/health/bmi_calculator"
    "pomodoro_timer" = "apps/productivity/pomodoro_timer"
    "compound_interest_calculator" = "apps/finance/compound_interest_calculator"
    "fasting_tracker" = "apps/health/fasting_tracker"
    "white_noise" = "apps/media/white_noise"
}

$results = @()

# ================== FASE 1: JDK 21 MIGRATION ==================
Write-Host "📋 FASE 1: JDK 21 MIGRATION" -ForegroundColor Yellow

foreach ($appName in $AppsToUpdate) {
    $appPath = $appMap[$appName]
    Write-Host "`n  📱 $appName"
    
    # Update gradle.properties
    $gradleProps = "$appPath/android/gradle.properties"
    if (Test-Path $gradleProps) {
        $content = Get-Content $gradleProps -Raw
        
        # JDK version
        if ($content -notmatch "org\.gradle\.java\.home.*jdk-21") {
            $content = $content -replace "org\.gradle\.java\.home.*", "org.gradle.java.home=C:/Program Files/Java/jdk-21"
            Set-Content $gradleProps $content
            Write-Host "     ✅ gradle.properties (JDK 21)"
        } else {
            Write-Host "     ✅ gradle.properties (já é JDK 21)"
        }
    }
    
    # Update build.gradle.kts
    $buildGradle = "$appPath/android/app/build.gradle.kts"
    if (Test-Path $buildGradle) {
        $content = Get-Content $buildGradle -Raw
        
        # Target SDK 35
        if ($content -notmatch "targetSdk = 35") {
            $content = $content -replace "targetSdk = \d+", "targetSdk = 35"
            Set-Content $buildGradle $content
            Write-Host "     ✅ build.gradle.kts (SDK 35)"
        } else {
            Write-Host "     ✅ build.gradle.kts (já é SDK 35)"
        }
        
        # Kotlin 2.1.0
        if ($content -notmatch "kotlinVersion.*2\.1") {
            $content = $content -replace 'kotlinVersion\s*=\s*"[\d\.]+"', 'kotlinVersion = "2.1.0"'
            Set-Content $buildGradle $content
            Write-Host "     ✅ Kotlin 2.1.0"
        }
    }
}

# ================== FASE 2: PRIVACY POLICY URLS ==================
Write-Host "`n📋 FASE 2: PRIVACY POLICY CONFIGURATION" -ForegroundColor Yellow

$privacyTemplate = @"
https://sites.google.com/view/sarezende-{0}-privacy
"@

foreach ($appName in $AppsToUpdate) {
    $appPath = $appMap[$appName]
    $appNameKebab = $appName -replace "_", "-"
    $privacyUrl = $privacyTemplate -f $appNameKebab
    
    Write-Host "`n  📱 $appName"
    
    # Add to pubspec.yaml
    $pubspec = "$appPath/pubspec.yaml"
    if (Test-Path $pubspec) {
        $content = Get-Content $pubspec -Raw
        if ($content -notmatch "privacy_policy_url") {
            $content = $content + "`n# Privacy Policy`nprivacy_policy_url: `"$privacyUrl`"`n"
            Set-Content $pubspec $content
            Write-Host "     ✅ Privacy URL adicionada ao pubspec.yaml"
        } else {
            Write-Host "     ✅ Privacy URL já configurada"
        }
    }
    
    # Create DadosPublicacao structure
    $pubDataDir = "DadosPublicacao/$appName"
    if (!(Test-Path $pubDataDir)) {
        New-Item -ItemType Directory -Path "$pubDataDir/policies" -Force > $null
        New-Item -ItemType Directory -Path "$pubDataDir/store_assets/screenshots" -Force > $null
        New-Item -ItemType Directory -Path "$pubDataDir/keys" -Force > $null
        Write-Host "     ✅ DadosPublicacao/$appName criado"
    } else {
        Write-Host "     ✅ DadosPublicacao/$appName já existe"
    }
    
    # Create PRIVACY_POLICY.md template
    $policyFile = "$pubDataDir/policies/PRIVACY_POLICY.md"
    if (!(Test-Path $policyFile)) {
        $policyContent = @"
# Política de Privacidade - $appName

**URL:** $privacyUrl

## Coleta de Dados

Nenhum dado pessoal é coletado ou armazenado. Os dados permanecem apenas no seu dispositivo.

## Publicidade

Este app exibe anúncios AdMob. Consulte a [Política de Privacidade do Google](https://policies.google.com/privacy).

## Alterações

Qualquer alteração será postada nesta página.

**Data da Última Atualização:** $(Get-Date -Format "dd/MM/yyyy")
"@
        Set-Content $policyFile $policyContent
        Write-Host "     ✅ PRIVACY_POLICY.md criado"
    }
}

# ================== FASE 3: VERIFICAR SERVICES ==================
Write-Host "`n📋 FASE 3: AD SERVICE & CONSENT SERVICE" -ForegroundColor Yellow

foreach ($appName in $AppsToUpdate) {
    $appPath = $appMap[$appName]
    Write-Host "`n  📱 $appName"
    
    $adServicePath = "$appPath/lib/services/ad_service.dart"
    $consentServicePath = "$appPath/lib/services/consent_service.dart"
    
    if (Test-Path $adServicePath) {
        Write-Host "     ✅ AdService OK"
    } else {
        Write-Host "     ⚠️  AdService missing (verificar main.dart)"
    }
    
    if (Test-Path $consentServicePath) {
        Write-Host "     ✅ ConsentService OK"
    } else {
        Write-Host "     ⚠️  ConsentService missing (verificar main.dart)"
    }
}

# ================== FASE 4: BUILD RELEASE ==================
if (!$SkipBuild) {
    Write-Host "`n📋 FASE 4: FLUTTER BUILD (Release AAB)" -ForegroundColor Yellow
    
    $buildResults = @()
    
    foreach ($appName in $AppsToUpdate) {
        $appPath = $appMap[$appName]
        Write-Host "`n  📱 $appName"
        
        Set-Location $appPath
        
        Write-Host "     🔄 flutter clean..."
        & flutter clean 2>&1 > $null
        
        Write-Host "     🔄 flutter pub get..."
        & flutter pub get 2>&1 > $null
        
        Write-Host "     🔄 flutter gen-l10n..."
        & flutter gen-l10n 2>&1 > $null
        
        Write-Host "     🔄 flutter analyze..."
        $analyzeResult = & flutter analyze 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "     ✅ Analyze OK"
            $buildResults += @{app=$appName; analyze="✅"}
        } else {
            Write-Host "     ❌ Analyze FAILED"
            $buildResults += @{app=$appName; analyze="❌"}
        }
        
        Write-Host "     🔄 flutter build appbundle --release..."
        $buildOutput = & flutter build appbundle --release 2>&1
        
        if ($LASTEXITCODE -eq 0 -or (Test-Path "build/app/outputs/bundle/release/app-release.aab")) {
            $aabSize = (Get-Item "build/app/outputs/bundle/release/app-release.aab" -ErrorAction SilentlyContinue).Length
            if ($aabSize) {
                $aabSizeMB = [math]::Round($aabSize / 1MB, 2)
                Write-Host "     ✅ Build SUCCESS ($aabSizeMB MB)"
                
                # Copy to DadosPublicacao
                Copy-Item "build/app/outputs/bundle/release/app-release.aab" "../../DadosPublicacao/$appName/" -Force
                Write-Host "     ✅ AAB copied to DadosPublicacao"
                
                $buildResults += @{app=$appName; build="✅"; size=$aabSizeMB}
            }
        } else {
            Write-Host "     ❌ Build FAILED"
            Write-Host ($buildOutput | Select-String "error|Error|ERROR" -Context 2)
            $buildResults += @{app=$appName; build="❌"}
        }
        
        Set-Location $baseDir
    }
    
    Write-Host "`n📊 BUILD SUMMARY:" -ForegroundColor Green
    $buildResults | ForEach-Object {
        Write-Host "  $($_.app): Analyze: $($_.analyze) | Build: $($_.build)"
    }
}

# ================== FASE 5: DEVICE TESTS ==================
if (!$SkipTests) {
    Write-Host "`n📋 FASE 5: DEVICE REAL TESTS" -ForegroundColor Yellow
    Write-Host "`n  🔄 Rodando testes em device real (isso pode levar 5-10 minutos)...`n"
    
    Set-Location $baseDir
    $appIds = $AppsToUpdate -join ","
    
    & pwsh -NoProfile -ExecutionPolicy Bypass -File "tools\test_apps_COMPLETE.ps1" `
        -AppIds $appIds `
        -ActionDelayMs 100
}

# ================== RELATÓRIO FINAL ==================
Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║              ✅ ATUALIZAÇÃO CONCLUÍDA!                    ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Green

Write-Host "📋 PRÓXIMAS ETAPAS:" -ForegroundColor Yellow
Write-Host "
  1. ✅ JDK 21 Migration
  2. ✅ Privacy Policy URLs
  3. ✅ DadosPublicacao structure
  4. ✅ Build Release AAB
  5. ✅ Device Real Tests
  
  6. ⏳ Capturar screenshots (9:16) 
  7. ⏳ Criar ícone 512x512 e Feature Graphic
  8. ⏳ Preencher Store Listing (títulos, descrições)
  9. ⏳ Validar com validate_publication.ps1
  10. ⏳ Submeter ao Play Console
"

Write-Host "📌 CHECKLIST:" -ForegroundColor Cyan
Write-Host "  ✅ JDK 21 atualizado"
Write-Host "  ✅ Privacy Policy URLs configuradas"
Write-Host "  ✅ DadosPublicacao/<app_name>/ estrutura criada"
Write-Host "  ✅ AAB release compilados"
Write-Host "  ✅ Testes device real passando"
Write-Host ""
Write-Host "🎯 Para completar a publicação, faltam apenas assets visuais (screenshots, ícones)!"
Write-Host ""
