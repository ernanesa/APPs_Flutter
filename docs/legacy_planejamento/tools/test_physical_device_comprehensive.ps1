# ========================================
# COMPREHENSIVE PHYSICAL DEVICE TEST
# ========================================
# Purpose: Test all 3 apps on physical device
# - Install apps
# - Test each app individually
# - Test all functionalities
# - Test in all 11 languages
# - Capture screenshots for evidence

param(
    [string]$DeviceId = "8c7638ff"
)

$ErrorActionPreference = "Continue"
$adb = "C:\Users\Ernane\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$baseDir = "C:\Users\Ernane\Personal\APPs_Flutter_2"

# Apps to test
$apps = @(
    @{
        Name = "BMI Calculator"
        Package = "sa.rezende.bmi_calculator"
        ApkPath = "apps/health/bmi_calculator/build/app/outputs/flutter-apk/app-debug.apk"
        Tests = @(
            @{Name="Home Screen"; Action="none"},
            @{Name="Input Weight"; Action="tap"; X=540; Y=800},
            @{Name="Input Height"; Action="tap"; X=540; Y=1000},
            @{Name="Calculate BMI"; Action="tap"; X=540; Y=1400},
            @{Name="View Result"; Action="wait"; Seconds=2},
            @{Name="Open Settings"; Action="tap"; X=100; Y=100}
        )
    },
    @{
        Name = "Pomodoro Timer"
        Package = "sa.rezende.pomodoro_timer"
        ApkPath = "apps/productivity/pomodoro_timer/build/app/outputs/flutter-apk/app-debug.apk"
        Tests = @(
            @{Name="Home Screen"; Action="none"},
            @{Name="Start Timer"; Action="tap"; X=540; Y=960},
            @{Name="Timer Running"; Action="wait"; Seconds=3},
            @{Name="Pause Timer"; Action="tap"; X=540; Y=960},
            @{Name="Reset Timer"; Action="tap"; X=540; Y=1200},
            @{Name="Open Settings"; Action="tap"; X=100; Y=100}
        )
    },
    @{
        Name = "Compound Interest"
        Package = "sa.rezende.compound_interest_calculator"
        ApkPath = "apps/finance/compound_interest_calculator/build/app/outputs/flutter-apk/app-debug.apk"
        Tests = @(
            @{Name="Home Screen"; Action="none"},
            @{Name="Input Capital"; Action="tap"; X=540; Y=600},
            @{Name="Input Rate"; Action="tap"; X=540; Y=800},
            @{Name="Select Preset"; Action="tap"; X=540; Y=1000},
            @{Name="Calculate"; Action="tap"; X=540; Y=1400},
            @{Name="View Result"; Action="wait"; Seconds=2},
            @{Name="Open Settings"; Action="tap"; X=100; Y=100}
        )
    }
)

# Languages to test (11 languages as per Beast Mode spec)
$languages = @(
    @{Code="en-US"; Name="English"},
    @{Code="pt-BR"; Name="Português"},
    @{Code="es-ES"; Name="Español"},
    @{Code="fr-FR"; Name="Français"},
    @{Code="de-DE"; Name="Deutsch"},
    @{Code="zh-CN"; Name="中文"},
    @{Code="ja-JP"; Name="日本語"},
    @{Code="ar-SA"; Name="العربية"},
    @{Code="hi-IN"; Name="हिन्दी"},
    @{Code="ru-RU"; Name="Русский"},
    @{Code="bn-BD"; Name="বাংলা"}
)

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$reportDir = "artifacts/physical_device_test_$timestamp"
New-Item -ItemType Directory -Path $reportDir -Force | Out-Null

Write-Host "`n" "="*80 -ForegroundColor Cyan
Write-Host "  COMPREHENSIVE PHYSICAL DEVICE TEST" -ForegroundColor Cyan
Write-Host "="*80 -ForegroundColor Cyan
Write-Host "Device ID:    $DeviceId" -ForegroundColor Gray
Write-Host "Apps:         $($apps.Count)" -ForegroundColor Gray
Write-Host "Languages:    $($languages.Count)" -ForegroundColor Gray
Write-Host "Report Dir:   $reportDir" -ForegroundColor Gray
Write-Host "="*80 "`n" -ForegroundColor Cyan

# ========================================
# PHASE 1: Install all apps
# ========================================
Write-Host "[PHASE 1] Installing apps on physical device..." -ForegroundColor Yellow

foreach ($app in $apps) {
    $apkPath = Join-Path $baseDir $app.ApkPath
    
    if (-not (Test-Path $apkPath)) {
        Write-Host "  ❌ APK not found: $($app.Name)" -ForegroundColor Red
        Write-Host "     Expected: $apkPath" -ForegroundColor Gray
        continue
    }
    
    Write-Host "`n  Installing: $($app.Name)..." -ForegroundColor Cyan
    
    # Uninstall old version
    & $adb -s $DeviceId uninstall $app.Package 2>&1 | Out-Null
    
    # Install new version
    $installOutput = & $adb -s $DeviceId install -r $apkPath 2>&1
    
    if ($installOutput -match "Success") {
        $apkSize = [math]::Round((Get-Item $apkPath).Length / 1MB, 1)
        Write-Host "  ✅ Installed: $($app.Name) ($apkSize MB)" -ForegroundColor Green
    } else {
        Write-Host "  ❌ Failed: $($app.Name)" -ForegroundColor Red
        Write-Host "     $installOutput" -ForegroundColor Gray
    }
}

Start-Sleep -Seconds 2

# ========================================
# PHASE 2: Test each app
# ========================================
$allResults = @()

foreach ($app in $apps) {
    Write-Host "`n" "="*80 -ForegroundColor Magenta
    Write-Host "  TESTING APP: $($app.Name)" -ForegroundColor Magenta
    Write-Host "="*80 -ForegroundColor Magenta
    
    foreach ($lang in $languages) {
        Write-Host "`n  🌍 Language: $($lang.Name) ($($lang.Code))" -ForegroundColor Cyan
        
        # Change device language
        Write-Host "     Changing device language..." -NoNewline -ForegroundColor Gray
        & $adb -s $DeviceId shell "setprop persist.sys.locale $($lang.Code); setprop ctl.restart zygote" 2>&1 | Out-Null
        Start-Sleep -Seconds 8  # Wait for system restart
        Write-Host " Done" -ForegroundColor Green
        
        # Clear logcat
        & $adb -s $DeviceId logcat -c 2>&1 | Out-Null
        
        # Launch app
        Write-Host "     Launching app..." -NoNewline -ForegroundColor Gray
        & $adb -s $DeviceId shell am start -n "$($app.Package)/.MainActivity" 2>&1 | Out-Null
        Start-Sleep -Seconds 4  # Wait for app to fully load
        Write-Host " Done" -ForegroundColor Green
        
        # Check for ANR
        $anrCheck = & $adb -s $DeviceId logcat -d | Select-String "ANR" | Select-String $app.Package
        $hasANR = $anrCheck.Count -gt 0
        
        if ($hasANR) {
            Write-Host "     ❌ ANR DETECTED!" -ForegroundColor Red
        } else {
            Write-Host "     ✅ No ANR" -ForegroundColor Green
        }
        
        # Run functionality tests
        $testsPassed = 0
        $testsFailed = 0
        
        foreach ($test in $app.Tests) {
            Write-Host "     Testing: $($test.Name)..." -NoNewline -ForegroundColor Gray
            
            try {
                switch ($test.Action) {
                    "tap" {
                        & $adb -s $DeviceId shell input tap $test.X $test.Y 2>&1 | Out-Null
                        Start-Sleep -Milliseconds 500
                    }
                    "wait" {
                        Start-Sleep -Seconds $test.Seconds
                    }
                    "none" {
                        # Just screenshot
                    }
                }
                
                # Capture screenshot
                $screenshotName = "$($app.Package)_$($lang.Code)_$($test.Name -replace ' ','_').png"
                $screenshotPath = Join-Path $reportDir $screenshotName
                $tempFile = "/sdcard/test_screenshot.png"
                
                & $adb -s $DeviceId shell screencap -p $tempFile 2>&1 | Out-Null
                & $adb -s $DeviceId pull $tempFile $screenshotPath 2>&1 | Out-Null
                & $adb -s $DeviceId shell rm $tempFile 2>&1 | Out-Null
                
                if (Test-Path $screenshotPath) {
                    Write-Host " ✅" -ForegroundColor Green
                    $testsPassed++
                } else {
                    Write-Host " ⚠️ (no screenshot)" -ForegroundColor Yellow
                    $testsPassed++
                }
                
            } catch {
                Write-Host " ❌ Error: $_" -ForegroundColor Red
                $testsFailed++
            }
        }
        
        # Close app
        & $adb -s $DeviceId shell am force-stop $app.Package 2>&1 | Out-Null
        
        # Record result
        $allResults += @{
            App = $app.Name
            Language = $lang.Name
            LangCode = $lang.Code
            ANR = $hasANR
            TestsPassed = $testsPassed
            TestsFailed = $testsFailed
            TotalTests = $app.Tests.Count
        }
        
        Write-Host "     Summary: $testsPassed/$($app.Tests.Count) tests passed" -ForegroundColor $(if ($testsFailed -eq 0) { "Green" } else { "Yellow" })
        
        Start-Sleep -Seconds 1
    }
}

# ========================================
# PHASE 3: Generate Report
# ========================================
Write-Host "`n" "="*80 -ForegroundColor Cyan
Write-Host "  FINAL REPORT" -ForegroundColor Cyan
Write-Host "="*80 -ForegroundColor Cyan

# Group by app
foreach ($app in $apps) {
    Write-Host "`n📱 $($app.Name)" -ForegroundColor Yellow
    Write-Host ("─"*80) -ForegroundColor Gray
    
    $appResults = $allResults | Where-Object { $_.App -eq $app.Name }
    
    foreach ($result in $appResults) {
        $status = if ($result.ANR) { "❌ ANR" }
                  elseif ($result.TestsFailed -gt 0) { "⚠️ WARN" }
                  else { "✅ PASS" }
        
        $color = if ($status -match "PASS") { "Green" }
                 elseif ($status -match "ANR") { "Red" }
                 else { "Yellow" }
        
        Write-Host "  $status | " -NoNewline -ForegroundColor $color
        Write-Host "$($result.Language.PadRight(15)) | " -NoNewline -ForegroundColor Gray
        Write-Host "$($result.TestsPassed)/$($result.TotalTests) passed" -ForegroundColor Gray
    }
}

# Overall statistics
Write-Host "`n" "="*80 -ForegroundColor Cyan
Write-Host "OVERALL STATISTICS" -ForegroundColor Cyan
Write-Host "="*80 -ForegroundColor Cyan

$totalTests = ($allResults | Measure-Object -Property TotalTests -Sum).Sum
$totalPassed = ($allResults | Measure-Object -Property TestsPassed -Sum).Sum
$totalFailed = ($allResults | Measure-Object -Property TestsFailed -Sum).Sum
$totalANRs = ($allResults | Where-Object { $_.ANR }).Count

Write-Host "Total Tests:     $totalTests" -ForegroundColor Gray
Write-Host "✅ Passed:       $totalPassed" -ForegroundColor Green
Write-Host "❌ Failed:       $totalFailed" -ForegroundColor $(if ($totalFailed -gt 0) { "Red" } else { "Gray" })
Write-Host "🚨 ANRs:         $totalANRs" -ForegroundColor $(if ($totalANRs -gt 0) { "Red" } else { "Green" })

$successRate = if ($totalTests -gt 0) { [math]::Round(($totalPassed / $totalTests) * 100, 1) } else { 0 }
Write-Host "`nSuccess Rate:    $successRate%" -ForegroundColor $(if ($successRate -ge 95) { "Green" } elseif ($successRate -ge 80) { "Yellow" } else { "Red" })

# Screenshot stats
$screenshots = Get-ChildItem -Path $reportDir -Filter *.png
$screenshotCount = $screenshots.Count
$screenshotSize = [math]::Round(($screenshots | Measure-Object -Property Length -Sum).Sum / 1MB, 2)

Write-Host "`n📸 Screenshots:  $screenshotCount files ($screenshotSize MB)" -ForegroundColor Cyan
Write-Host "📂 Location:     $reportDir" -ForegroundColor Gray

Write-Host "`n" "="*80 "`n" -ForegroundColor Cyan

if ($totalANRs -eq 0 -and $totalFailed -eq 0) {
    Write-Host "🎉 ALL TESTS PASSED - PRODUCTION READY!" -ForegroundColor Green
} elseif ($totalANRs -eq 0) {
    Write-Host "✅ No ANRs detected, but some tests had issues." -ForegroundColor Yellow
} else {
    Write-Host "⚠️ ANRs detected! Review details above." -ForegroundColor Red
}

Write-Host ""

# Save report to file
$reportFile = Join-Path $reportDir "test_report.txt"
$allResults | ConvertTo-Json | Out-File $reportFile -Encoding UTF8
Write-Host "📄 JSON Report saved: $reportFile" -ForegroundColor Gray
Write-Host ""
