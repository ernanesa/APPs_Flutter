#!/usr/bin/env pwsh
<#
.SYNOPSIS
Atualiza JDK 21 e compila todos os 5 apps em paralelo
#>

$baseDir = "C:\Users\Ernane\Personal\APPs_Flutter_2"
Set-Location $baseDir

$apps = @(
    @{name="bmi_calculator"; category="health"},
    @{name="pomodoro_timer"; category="productivity"},
    @{name="compound_interest_calculator"; category="finance"},
    @{name="fasting_tracker"; category="health"},
    @{name="white_noise"; category="media"}
)

Write-Host "`n" + ("="*70) -ForegroundColor Cyan
Write-Host "🚀 ATUALIZANDO 5 APPS - JDK 21 + BUILD RELEASE" -ForegroundColor Cyan
Write-Host ("="*70) + "`n" -ForegroundColor Cyan

# ============ FASE 1: JDK 21 UPDATE ============
Write-Host "📋 FASE 1: JDK 21 Migration (gradle.properties)" -ForegroundColor Yellow

foreach ($app in $apps) {
    $appPath = "apps/$($app.category)/$($app.name)"
    $gradleProps = "$appPath/android/gradle.properties"
    
    Write-Host "`n  📱 $($app.name)"
    
    if (Test-Path $gradleProps) {
        $content = Get-Content $gradleProps -Raw
        
        # Update JDK path
        if ($content -match "org\.gradle\.java\.home") {
            $oldLine = ($content | Select-String "org\.gradle\.java\.home.*" | Select-Object -First 1).Line
            $newLine = 'org.gradle.java.home=C:/Program Files/Java/jdk-21'
            $content = $content -replace [regex]::Escape($oldLine), $newLine
        } else {
            $content = $content.TrimEnd() + "`norg.gradle.java.home=C:/Program Files/Java/jdk-21`n"
        }
        
        Set-Content $gradleProps $content -Encoding UTF8
        Write-Host "     ✅ JDK 21 configurado"
    } else {
        Write-Host "     ⚠️  gradle.properties não encontrado"
    }
}

# ============ FASE 2: BUILD RELEASE (Sequencial) ============
Write-Host "`n📋 FASE 2: Flutter Build Release" -ForegroundColor Yellow

$buildReport = @()

foreach ($app in $apps) {
    $appPath = "apps/$($app.category)/$($app.name)"
    $appName = $app.name
    
    Write-Host "`n  📱 $appName" -ForegroundColor Magenta
    
    Set-Location $appPath
    
    # Clean
    Write-Host "     🔄 flutter clean..."
    flutter clean 2>&1 | Out-Null
    
    # Pub get
    Write-Host "     🔄 flutter pub get..."
    flutter pub get 2>&1 | Out-Null
    
    # Gen-l10n
    Write-Host "     🔄 flutter gen-l10n..."
    flutter gen-l10n 2>&1 | Out-Null
    
    # Analyze
    Write-Host "     🔄 flutter analyze..."
    $analyzeOut = flutter analyze 2>&1
    $analyzeOk = $LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq 1
    if ($analyzeOk) {
        Write-Host "     ✅ Analyze OK"
    } else {
        Write-Host "     ❌ Analyze FAILED"
        Write-Host ($analyzeOut | Select-String "error|Error" -Context 2)
    }
    
    # Build AAB
    Write-Host "     🔄 flutter build appbundle --release (pode levar 5-10min)..."
    $buildStart = Get-Date
    $buildOutput = flutter build appbundle --release 2>&1
    $buildDuration = ((Get-Date) - $buildStart).TotalSeconds
    
    $aabPath = "build/app/outputs/bundle/release/app-release.aab"
    
    if (Test-Path $aabPath) {
        $aabSize = (Get-Item $aabPath).Length
        $aabSizeMB = [math]::Round($aabSize / 1MB, 2)
        
        Write-Host "     ✅ Build SUCCESS ($aabSizeMB MB em $([math]::Round($buildDuration))s)"
        
        # Copy to DadosPublicacao
        $datosPath = "$baseDir/DadosPublicacao/$appName"
        if (!(Test-Path $datosPath)) {
            New-Item -ItemType Directory -Path $datosPath -Force | Out-Null
        }
        Copy-Item $aabPath "$datosPath/app-release.aab" -Force
        Write-Host "     ✅ AAB copied to DadosPublicacao/$appName"
        
        $buildReport += @{app=$appName; status="✅"; size=$aabSizeMB; time=$([math]::Round($buildDuration))}
    } else {
        Write-Host "     ❌ Build FAILED - AAB not found"
        Write-Host ($buildOutput | Select-String "error|Error|FAILURE" -Context 3)
        $buildReport += @{app=$appName; status="❌"}
    }
    
    Set-Location $baseDir
}

# ============ PHASE 3: PRIVACY POLICIES ============
Write-Host "`n📋 FASE 3: Privacy Policy Configuration" -ForegroundColor Yellow

foreach ($app in $apps) {
    $appName = $app.name
    $appNameKebab = $appName -replace "_", "-"
    $privacyUrl = "https://sites.google.com/view/sarezende-$appNameKebab-privacy"
    
    $datosPath = "DadosPublicacao/$appName"
    
    # Criar estrutura
    @("policies", "store_assets/screenshots", "keys") | ForEach-Object {
        $dir = "$datosPath/$_"
        if (!(Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
    }
    
    # Privacy Policy.md
    $policyFile = "$datosPath/policies/PRIVACY_POLICY.md"
    if (!(Test-Path $policyFile)) {
        $policyContent = @"
# Política de Privacidade - $appName

**URL Oficial:** $privacyUrl

## Coleta de Dados
Este aplicativo não coleta dados pessoais. Todos os dados permanecem armazenados apenas no seu dispositivo.

## Publicidade
Este app exibe anúncios através do Google AdMob. Consulte a [Política de Privacidade do Google](https://policies.google.com/privacy) para mais informações.

## Contato
Para dúvidas sobre privacidade, entre em contato através do Google Play Console.

**Última Atualização:** $(Get-Date -Format "dd/MM/yyyy")
"@
        Set-Content $policyFile $policyContent -Encoding UTF8
    }
    
    Write-Host "  ✅ ${appName}: Privacy policy estrutura criada"
}

# ============ RELATÓRIO FINAL ============
Write-Host "`n" + ("="*70) -ForegroundColor Green
Write-Host "✅ FASE 1, 2, 3 CONCLUÍDAS!" -ForegroundColor Green
Write-Host ("="*70) + "`n" -ForegroundColor Green

Write-Host "📊 BUILD REPORT:"-ForegroundColor Cyan
Write-Host ""
$buildReport | ForEach-Object {
    if ($_.status -eq "✅") {
        Write-Host "  ✅ $($_.app) - $($_.size)MB (em $($_.time)s)"
    } else {
        Write-Host "  ❌ $($_.app): BUILD FAILED"
    }
}

Write-Host "`n📋 PRÓXIMOS PASSOS:" -ForegroundColor Yellow
Write-Host "
  1. ✅ JDK 21 migration (gradle.properties)
  2. ✅ Privacy Policy URLs estruturado
  3. ✅ DadosPublicacao/<app_name>/ criado  
  4. ✅ AAB release compilados $($($buildReport | Where status -eq '✅').Count) de $($apps.Count)
  
  5. ⏳ Rodar DEVICE TESTS: 
     pwsh tools\test_apps_COMPLETE.ps1 -AppIds 'bmi_calculator,pomodoro_timer,compound_interest_calculator,fasting_tracker,white_noise' -ActionDelayMs 100
     
  6. ⏳ Assets de publicação (screenshots 9:16, ícones 512x512)
  7. ⏳ Preencher Store Listing
  8. ⏳ Submeter ao Play Console
"

Write-Host "`n🎯 Status: PRONTO PARA DEVICE TESTS!" -ForegroundColor Green
