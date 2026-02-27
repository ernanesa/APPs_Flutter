# ========================================
# VISUAL TEST - Interactive (with delays)
# ========================================
# Purpose: Test all apps with human-observable delays
# Shows what's happening step by step

param(
    [int]$DelaySeconds = 3
)

$ErrorActionPreference = "Continue"
$adb = "C:\Users\Ernane\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$baseDir = "C:\Users\Ernane\Personal\APPs_Flutter_2"

$apps = @(
    @{Name="bmi_calculator"; Package="sa.rezende.bmi_calculator"; DisplayName="BMI Calculator"},
    @{Name="pomodoro_timer"; Package="sa.rezende.pomodoro_timer"; DisplayName="Pomodoro Timer"},
    @{Name="compound_interest_calculator"; Package="sa.rezende.compound_interest_calculator"; DisplayName="Compound Interest"}
)

# Get online AVDs
$avds = & $adb devices | Select-String "emulator-\d+" | ForEach-Object { $_.Matches[0].Value }
$avdCount = $avds.Count

if ($avdCount -eq 0) {
    Write-Host "`n❌ No AVDs online. Start emulators first." -ForegroundColor Red
    exit 1
}

Write-Host "`n" "="*80 -ForegroundColor Cyan
Write-Host "  VISUAL TEST - Interactive Mode" -ForegroundColor Cyan
Write-Host "="*80 -ForegroundColor Cyan
Write-Host "Apps:         $($apps.Count)" -ForegroundColor Gray
Write-Host "AVDs Online:  $avdCount ($($avds -join ', '))" -ForegroundColor Gray
Write-Host "Delay:        ${DelaySeconds}s between actions" -ForegroundColor Gray
Write-Host "="*80 "`n" -ForegroundColor Cyan

$testResults = @()
$screenshotDir = "artifacts/visual_test_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $screenshotDir -Force | Out-Null

foreach ($app in $apps) {
    Write-Host "`n" "─"*80 -ForegroundColor Yellow
    Write-Host "  Testing: $($app.DisplayName)" -ForegroundColor Yellow
    Write-Host "─"*80 -ForegroundColor Yellow
    
    foreach ($avd in $avds) {
        Write-Host "`n📱 Device: $avd" -ForegroundColor Cyan
        
        # ========================================
        # STEP 1: Check if installed
        # ========================================
        Write-Host "`n[1/5] Checking installation..." -ForegroundColor Gray
        $installed = & $adb -s $avd shell pm list packages | Select-String $app.Package
        
        if (-not $installed) {
            Write-Host "  ⚠️ App not installed. Skipping..." -ForegroundColor Yellow
            $testResults += @{
                App = $app.DisplayName
                AVD = $avd
                Status = "Skipped"
                Reason = "Not installed"
            }
            continue
        }
        
        Write-Host "  ✅ App installed" -ForegroundColor Green
        Start-Sleep -Seconds 1
        
        # ========================================
        # STEP 2: Clear logcat
        # ========================================
        Write-Host "`n[2/5] Clearing logcat..." -ForegroundColor Gray
        & $adb -s $avd logcat -c 2>&1 | Out-Null
        Write-Host "  ✅ Logcat cleared" -ForegroundColor Green
        Start-Sleep -Seconds 1
        
        # ========================================
        # STEP 3: Launch app
        # ========================================
        Write-Host "`n[3/5] Launching app..." -ForegroundColor Gray
        Write-Host "  🚀 Starting: $($app.Package)" -ForegroundColor Cyan
        
        $launchSw = [System.Diagnostics.Stopwatch]::StartNew()
        & $adb -s $avd shell am start -n "$($app.Package)/.MainActivity" 2>&1 | Out-Null
        
        # Wait and show countdown
        Write-Host "  ⏳ Waiting for app to load..." -ForegroundColor Gray
        for ($i = $DelaySeconds; $i -gt 0; $i--) {
            Write-Host "`r     ${i}s... " -NoNewline -ForegroundColor Gray
            Start-Sleep -Seconds 1
        }
        $launchSw.Stop()
        Write-Host "`r  ✅ App launched ($([math]::Round($launchSw.Elapsed.TotalSeconds, 1))s)" -ForegroundColor Green
        
        # ========================================
        # STEP 4: Check for ANR
        # ========================================
        Write-Host "`n[4/5] Checking for ANR..." -ForegroundColor Gray
        $anrLines = & $adb -s $avd logcat -d -v time | Select-String "ANR" | Select-String $app.Package
        $hasANR = $anrLines.Count -gt 0
        
        if ($hasANR) {
            Write-Host "  ❌ ANR DETECTED!" -ForegroundColor Red
            Write-Host "     $($anrLines[0])" -ForegroundColor Red
        } else {
            Write-Host "  ✅ No ANR detected" -ForegroundColor Green
        }
        Start-Sleep -Seconds 1
        
        # ========================================
        # STEP 5: Capture screenshot
        # ========================================
        Write-Host "`n[5/5] Capturing screenshot..." -ForegroundColor Gray
        $screenshotFile = "$screenshotDir/$($app.Name)_$($avd)_$(Get-Date -Format 'HHmmss').png"
        $tempFile = "/sdcard/screenshot_temp.png"
        
        & $adb -s $avd shell screencap -p $tempFile 2>&1 | Out-Null
        & $adb -s $avd pull $tempFile $screenshotFile 2>&1 | Out-Null
        & $adb -s $avd shell rm $tempFile 2>&1 | Out-Null
        
        if (Test-Path $screenshotFile) {
            $fileSize = [math]::Round((Get-Item $screenshotFile).Length / 1KB, 1)
            Write-Host "  ✅ Screenshot saved: $fileSize KB" -ForegroundColor Green
            $screenshotOk = $true
        } else {
            Write-Host "  ❌ Screenshot failed" -ForegroundColor Red
            $screenshotOk = $false
        }
        
        # ========================================
        # Test interaction (tap on screen center)
        # ========================================
        Write-Host "`n[BONUS] Testing interaction..." -ForegroundColor Gray
        
        # Get screen size
        $screenSize = & $adb -s $avd shell wm size | Select-String "Physical size: (\d+)x(\d+)"
        if ($screenSize) {
            $width = [int]$screenSize.Matches.Groups[1].Value
            $height = [int]$screenSize.Matches.Groups[2].Value
            $centerX = [int]($width / 2)
            $centerY = [int]($height / 2)
            
            Write-Host "  👆 Tapping screen center (${centerX}, ${centerY})..." -ForegroundColor Cyan
            & $adb -s $avd shell input tap $centerX $centerY 2>&1 | Out-Null
            Start-Sleep -Seconds 2
            
            # Screenshot after interaction
            $screenshotFile2 = "$screenshotDir/$($app.Name)_$($avd)_after_tap_$(Get-Date -Format 'HHmmss').png"
            & $adb -s $avd shell screencap -p $tempFile 2>&1 | Out-Null
            & $adb -s $avd pull $tempFile $screenshotFile2 2>&1 | Out-Null
            & $adb -s $avd shell rm $tempFile 2>&1 | Out-Null
            
            if (Test-Path $screenshotFile2) {
                $fileSize2 = [math]::Round((Get-Item $screenshotFile2).Length / 1KB, 1)
                Write-Host "  ✅ After-tap screenshot: $fileSize2 KB" -ForegroundColor Green
            }
        }
        
        # ========================================
        # Summary for this test
        # ========================================
        $status = if (-not $hasANR -and $screenshotOk) { "✅ PASS" } 
                  elseif ($hasANR) { "❌ FAIL (ANR)" }
                  else { "⚠️ WARN (No screenshot)" }
        
        Write-Host "`n  Result: $status" -ForegroundColor $(if ($status -match "PASS") { "Green" } elseif ($status -match "FAIL") { "Red" } else { "Yellow" })
        
        $testResults += @{
            App = $app.DisplayName
            AVD = $avd
            LaunchTime = [math]::Round($launchSw.Elapsed.TotalSeconds, 1)
            ANR = $hasANR
            Screenshot = $screenshotOk
            Status = $status
        }
        
        # Delay before next test
        Write-Host "`n  ⏸️ Pausing ${DelaySeconds}s before next test..." -ForegroundColor Gray
        Start-Sleep -Seconds $DelaySeconds
    }
}

# ========================================
# FINAL REPORT
# ========================================
Write-Host "`n`n" "="*80 -ForegroundColor Cyan
Write-Host "  FINAL REPORT" -ForegroundColor Cyan
Write-Host "="*80 -ForegroundColor Cyan

Write-Host "`nTest Results:" -ForegroundColor Yellow
Write-Host ("─"*80) -ForegroundColor Gray

$totalTests = $testResults.Count
$passedTests = ($testResults | Where-Object { $_.Status -match "PASS" }).Count
$failedTests = ($testResults | Where-Object { $_.Status -match "FAIL" }).Count
$warnTests = ($testResults | Where-Object { $_.Status -match "WARN" }).Count

foreach ($result in $testResults) {
    $statusColor = if ($result.Status -match "PASS") { "Green" } 
                   elseif ($result.Status -match "FAIL") { "Red" } 
                   else { "Yellow" }
    
    $anrIcon = if ($result.ANR) { "❌" } else { "✅" }
    $screenshotIcon = if ($result.Screenshot) { "✅" } else { "❌" }
    
    Write-Host "  $($result.Status.PadRight(15)) | " -NoNewline -ForegroundColor $statusColor
    Write-Host "$($result.App.PadRight(20)) | " -NoNewline -ForegroundColor Gray
    Write-Host "$($result.AVD.PadRight(15)) | " -NoNewline -ForegroundColor Gray
    Write-Host "Launch: $($result.LaunchTime)s | " -NoNewline -ForegroundColor Gray
    Write-Host "ANR: $anrIcon | " -NoNewline
    Write-Host "Screenshot: $screenshotIcon" -ForegroundColor Gray
}

Write-Host "`n" ("─"*80) -ForegroundColor Gray
Write-Host "Summary:" -ForegroundColor Yellow
Write-Host "  Total Tests:  $totalTests" -ForegroundColor Gray
Write-Host "  ✅ Passed:    $passedTests" -ForegroundColor Green
Write-Host "  ❌ Failed:    $failedTests" -ForegroundColor $(if ($failedTests -gt 0) { "Red" } else { "Gray" })
Write-Host "  ⚠️ Warnings:  $warnTests" -ForegroundColor $(if ($warnTests -gt 0) { "Yellow" } else { "Gray" })

$successRate = if ($totalTests -gt 0) { [math]::Round(($passedTests / $totalTests) * 100, 1) } else { 0 }
Write-Host "`n  Success Rate: $successRate%" -ForegroundColor $(if ($successRate -ge 80) { "Green" } elseif ($successRate -ge 50) { "Yellow" } else { "Red" })

Write-Host "`n📂 Screenshots saved to: $screenshotDir" -ForegroundColor Cyan
$screenshotCount = (Get-ChildItem $screenshotDir -Filter *.png).Count
$totalSize = [math]::Round((Get-ChildItem $screenshotDir -Filter *.png | Measure-Object -Property Length -Sum).Sum / 1MB, 2)
Write-Host "   Files: $screenshotCount screenshots ($totalSize MB)" -ForegroundColor Gray

Write-Host "`n" "="*80 "`n" -ForegroundColor Cyan

if ($failedTests -eq 0 -and $warnTests -eq 0) {
    Write-Host "🎉 ALL TESTS PASSED!" -ForegroundColor Green
} elseif ($failedTests -eq 0) {
    Write-Host "✅ No failures, but some warnings." -ForegroundColor Yellow
} else {
    Write-Host "⚠️ Some tests failed. Review details above." -ForegroundColor Red
}

Write-Host ""
