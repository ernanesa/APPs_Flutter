#!/usr/bin/env pwsh
# FINAL BUILD & TEST SCRIPT - 5 APPS

cd C:\Users\Ernane\Personal\APPs_Flutter_2

Write-Host "`n=== BUILDING 5 APPS FOR PUBLICATION ===" -ForegroundColor Cyan
Write-Host ""

# App list
$apps = @(
    @{name="bmi_calculator"; path="apps/health/bmi_calculator"},
    @{name="pomodoro_timer"; path="apps/productivity/pomodoro_timer"},
    @{name="compound_interest_calculator"; path="apps/finance/compound_interest_calculator"},
    @{name="fasting_tracker"; path="apps/health/fasting_tracker"},
    @{name="white_noise"; path="apps/media/white_noise"}
)

$successCount = 0
$failCount = 0

# BUILD EACH APP
foreach ($app in $apps) {
    Write-Host "`nBuilding $($app.name)..." -ForegroundColor Yellow
    
    Set-Location $($app.path)
    
    # Prepare
    Write-Host "  Cleaning..." -NoNewline
    flutter clean 2>&1 | Out-Null
    Write-Host " done"
    
    Write-Host "  Getting deps..." -NoNewline
    flutter pub get 2>&1 | Out-Null
    Write-Host " done"
    
    Write-Host "  Generating l10n..." -NoNewline
    flutter gen-l10n 2>&1 | Out-Null
    Write-Host " done"
    
    # Build
    Write-Host "  Building AAB (5-10 min)..." -NoNewline
    
    $start = Get-Date
    flutter build appbundle --release 2>&1 | Out-Null
    $elapsed = [int]((Get-Date) - $start).TotalSeconds
    
    # Check result
    $aabFile = "build/app/outputs/bundle/release/app-release.aab"
    if (Test-Path $aabFile) {
        $sizeMB = [math]::Round((Get-Item $aabFile).Length / 1MB, 1)
        Write-Host " SUCCESS ($sizeMB MB, ${elapsed}s)"
        
        # Copy to DadosPublicacao
        $datosDir = "../../DadosPublicacao/$($app.name)"
        if (!(Test-Path $datosDir)) {
            New-Item -ItemType Directory -Path $datosDir -Force | Out-Null
        }
        Copy-Item $aabFile "$datosDir/" -Force
        Write-Host "  Saved to DadosPublicacao/$($app.name)"
        
        $successCount++
    } else {
        Write-Host " FAILED"
        $failCount++
    }
    
    cd C:\Users\Ernane\Personal\APPs_Flutter_2
}

# SUMMARY
Write-Host "`n=== BUILD SUMMARY ===" -ForegroundColor Green
Write-Host "Success: $successCount / $($apps.Count)"
Write-Host "Failed:  $failCount / $($apps.Count)"

if ($successCount -eq $apps.Count) {
    Write-Host "`n✅ All apps built successfully!" -ForegroundColor Green
    Write-Host "`nNEXT: Run device tests"
    Write-Host "  pwsh tools\test_apps_COMPLETE.ps1 -AppIds 'bmi_calculator,pomodoro_timer,compound_interest_calculator,fasting_tracker,white_noise' -ActionDelayMs 100"
} else {
    Write-Host "`n⚠️ Some builds failed. Check errors above." -ForegroundColor Yellow
}
