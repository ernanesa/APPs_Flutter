# ========================================
# ANR FIX VALIDATION - Rebuild & Test
# ========================================
# Purpose: Rebuild APKs after ANR fix and reinstall on all AVDs
# Expected: No ANR dialogs, apps launch within 2 seconds

param(
    [switch]$SkipBuild
)

$ErrorActionPreference = "Continue"
$adb = "C:\Users\Ernane\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$flutter = "C:\Users\Ernane\flutter\sdk\bin\flutter.bat"
$baseDir = "C:\Users\Ernane\Personal\APPs_Flutter_2"

$apps = @(
    @{Name="bmi_calculator"; Path="apps/health/bmi_calculator"},
    @{Name="pomodoro_timer"; Path="apps/productivity/pomodoro_timer"},
    @{Name="compound_interest_calculator"; Path="apps/finance/compound_interest_calculator"}
)

$avds = & $adb devices | Select-String "emulator-\d+" | ForEach-Object { $_.Matches[0].Value }
$avdCount = $avds.Count

Write-Host "`n" "="*80 -ForegroundColor Cyan
Write-Host "  ANR FIX VALIDATION - Rebuild & Test" -ForegroundColor Cyan
Write-Host "="*80 -ForegroundColor Cyan
Write-Host "Apps:    $($apps.Count)" -ForegroundColor Gray
Write-Host "AVDs:    $avdCount ($($avds -join ', '))" -ForegroundColor Gray
Write-Host "="*80 "`n" -ForegroundColor Cyan

# ========================================
# PHASE 1: Rebuild APKs (Parallel)
# ========================================
if (-not $SkipBuild) {
    Write-Host "[PHASE 1] Building APKs (parallel)..." -ForegroundColor Yellow
    $buildJobs = @()
    
    foreach ($app in $apps) {
        $appPath = Join-Path $baseDir $app.Path
        $buildJobs += Start-Job -Name "Build_$($app.Name)" -ScriptBlock {
            param($flutter, $appPath, $appName)
            $ErrorActionPreference = "SilentlyContinue"
            
            Set-Location $appPath
            
            # Clean
            & $flutter clean | Out-Null
            
            # Get dependencies
            & $flutter pub get 2>&1 | Out-Null
            
            # Build debug APK
            $buildOutput = & $flutter build apk --debug 2>&1
            $apkPath = Join-Path $appPath "build\app\outputs\flutter-apk\app-debug.apk"
            
            if (Test-Path $apkPath) {
                $size = [math]::Round((Get-Item $apkPath).Length / 1MB, 2)
                return @{
                    Name = $appName
                    Success = $true
                    Size = $size
                    Path = $apkPath
                }
            } else {
                return @{
                    Name = $appName
                    Success = $false
                    Error = "APK not found"
                }
            }
        } -ArgumentList $flutter, $appPath, $app.Name
    }
    
    # Wait for builds with progress
    $completed = 0
    $total = $buildJobs.Count
    
    while ($buildJobs | Where-Object { $_.State -eq 'Running' }) {
        $running = ($buildJobs | Where-Object { $_.State -eq 'Running' }).Count
        $completed = $total - $running
        Write-Host "`r  Building... [$completed/$total completed]" -NoNewline -ForegroundColor Gray
        Start-Sleep -Milliseconds 500
    }
    Write-Host ""
    
    # Collect results
    $buildResults = @()
    foreach ($job in $buildJobs) {
        $result = Receive-Job -Job $job
        $buildResults += $result
        Remove-Job -Job $job
        
        if ($result.Success) {
            Write-Host "  ✅ $($result.Name): $($result.Size) MB" -ForegroundColor Green
        } else {
            Write-Host "  ❌ $($result.Name): $($result.Error)" -ForegroundColor Red
        }
    }
    
    $successfulBuilds = $buildResults | Where-Object { $_.Success }
    Write-Host "`n  Build Summary: $($successfulBuilds.Count)/$($buildResults.Count) succeeded" -ForegroundColor Cyan
    
    if ($successfulBuilds.Count -eq 0) {
        Write-Host "`n❌ No successful builds. Exiting." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "[PHASE 1] Skipping build (using existing APKs)..." -ForegroundColor Yellow
    $buildResults = $apps | ForEach-Object {
        $apkPath = Join-Path $baseDir "$($_.Path)\build\app\outputs\flutter-apk\app-debug.apk"
        @{
            Name = $_.Name
            Success = (Test-Path $apkPath)
            Size = if (Test-Path $apkPath) { [math]::Round((Get-Item $apkPath).Length / 1MB, 2) } else { 0 }
            Path = $apkPath
        }
    }
    $successfulBuilds = $buildResults | Where-Object { $_.Success }
}

# ========================================
# PHASE 2: Uninstall old versions
# ========================================
Write-Host "`n[PHASE 2] Uninstalling old versions..." -ForegroundColor Yellow

$uninstallJobs = @()
foreach ($app in $apps) {
    foreach ($avd in $avds) {
        $packageName = "sa.rezende.$($app.Name)"
        $uninstallJobs += Start-Job -ScriptBlock {
            param($adb, $avd, $package)
            & $adb -s $avd uninstall $package 2>&1 | Out-Null
            return @{AVD=$avd; Package=$package}
        } -ArgumentList $adb, $avd, $packageName
    }
}

$uninstallJobs | Wait-Job | Out-Null
$uninstallJobs | Remove-Job
Write-Host "  ✅ Uninstalled from $avdCount AVDs" -ForegroundColor Green

# ========================================
# PHASE 3: Install APKs (Parallel по AVD)
# ========================================
Write-Host "`n[PHASE 3] Installing APKs..." -ForegroundColor Yellow

$installJobs = @()
foreach ($app in $successfulBuilds) {
    foreach ($avd in $avds) {
        $installJobs += Start-Job -Name "Install_$($app.Name)_$avd" -ScriptBlock {
            param($adb, $avd, $apkPath, $appName)
            $ErrorActionPreference = "SilentlyContinue"
            
            $sw = [System.Diagnostics.Stopwatch]::StartNew()
            $output = & $adb -s $avd install -r $apkPath 2>&1
            $sw.Stop()
            
            $success = $output -match "Success"
            
            return @{
                AVD = $avd
                App = $appName
                Success = $success
                Time = [math]::Round($sw.Elapsed.TotalSeconds, 1)
            }
        } -ArgumentList $adb, $avd, $app.Path, $app.Name
    }
}

# Wait and show progress
$completed = 0
$total = $installJobs.Count

while ($installJobs | Where-Object { $_.State -eq 'Running' }) {
    $running = ($installJobs | Where-Object { $_.State -eq 'Running' }).Count
    $completed = $total - $running
    Write-Host "`r  Installing... [$completed/$total completed]" -NoNewline -ForegroundColor Gray
    Start-Sleep -Milliseconds 300
}
Write-Host ""

# Collect install results
$installResults = @()
foreach ($job in $installJobs) {
    $result = Receive-Job -Job $job
    $installResults += $result
    Remove-Job -Job $job
    
    $status = if ($result.Success) { "✅" } else { "❌" }
    Write-Host "  $status $($result.App) on $($result.AVD): $($result.Time)s" -ForegroundColor $(if ($result.Success) { "Green" } else { "Red" })
}

$successfulInstalls = $installResults | Where-Object { $_.Success }
Write-Host "`n  Install Summary: $($successfulInstalls.Count)/$($installResults.Count) succeeded" -ForegroundColor Cyan

# ========================================
# PHASE 4: Launch tests (Check for ANR)
# ========================================
Write-Host "`n[PHASE 4] Launch tests (ANR check)..." -ForegroundColor Yellow

$launchTests = @()
foreach ($app in $apps) {
    foreach ($avd in $avds) {
        $packageName = "sa.rezende.$($app.Name)"
        $launchTests += Start-Job -Name "Launch_$($app.Name)_$avd" -ScriptBlock {
            param($adb, $avd, $package, $appName)
            
            # Clear logcat
            & $adb -s $avd logcat -c 2>&1 | Out-Null
            
            # Launch app
            $sw = [System.Diagnostics.Stopwatch]::StartNew()
            & $adb -s $avd shell am start -n "$package/.MainActivity" 2>&1 | Out-Null
            
            # Wait 5 seconds and check for ANR
            Start-Sleep -Seconds 5
            $sw.Stop()
            
            # Check logcat for ANR
            $logcat = & $adb -s $avd logcat -d -v time | Select-String "ANR" | Select-String $package
            $hasANR = $logcat.Count -gt 0
            
            # Check if app is running
            $processes = & $adb -s $avd shell "ps | grep $package"
            $isRunning = $processes.Length -gt 0
            
            return @{
                AVD = $avd
                App = $appName
                LaunchTime = [math]::Round($sw.Elapsed.TotalSeconds, 1)
                HasANR = $hasANR
                IsRunning = $isRunning
                ANRDetails = if ($hasANR) { $logcat -join "`n" } else { "" }
            }
        } -ArgumentList $adb, $avd, $packageName, $app.Name
    }
}

# Wait and show progress
$completed = 0
$total = $launchTests.Count

while ($launchTests | Where-Object { $_.State -eq 'Running' }) {
    $running = ($launchTests | Where-Object { $_.State -eq 'Running' }).Count
    $completed = $total - $running
    Write-Host "`r  Testing... [$completed/$total completed]" -NoNewline -ForegroundColor Gray
    Start-Sleep -Milliseconds 500
}
Write-Host ""

# Collect results
$launchResults = @()
foreach ($job in $launchTests) {
    $result = Receive-Job -Job $job
    $launchResults += $result
    Remove-Job -Job $job
    
    if ($result.HasANR) {
        Write-Host "  ❌ $($result.App) on $($result.AVD): ANR detected!" -ForegroundColor Red
    } elseif (-not $result.IsRunning) {
        Write-Host "  ⚠️ $($result.App) on $($result.AVD): Not running (may have crashed)" -ForegroundColor Yellow
    } else {
        Write-Host "  ✅ $($result.App) on $($result.AVD): OK ($($result.LaunchTime)s)" -ForegroundColor Green
    }
}

# ========================================
# FINAL REPORT
# ========================================
Write-Host "`n" "="*80 -ForegroundColor Cyan
Write-Host "  FINAL REPORT" -ForegroundColor Cyan
Write-Host "="*80 -ForegroundColor Cyan

$totalTests = $launchResults.Count
$passedTests = ($launchResults | Where-Object { -not $_.HasANR -and $_.IsRunning }).Count
$anrCount = ($launchResults | Where-Object { $_.HasANR }).Count
$crashCount = ($launchResults | Where-Object { -not $_.IsRunning -and -not $_.HasANR }).Count

Write-Host "`nLaunch Tests: $passedTests/$totalTests passed" -ForegroundColor $(if ($passedTests -eq $totalTests) { "Green" } else { "Yellow" })
Write-Host "  - ANR detected: $anrCount" -ForegroundColor $(if ($anrCount -eq 0) { "Green" } else { "Red" })
Write-Host "  - Crashes: $crashCount" -ForegroundColor $(if ($crashCount -eq 0) { "Green" } else { "Yellow" })

if ($anrCount -gt 0) {
    Write-Host "`n⚠️ ANR DETAILS:" -ForegroundColor Red
    $launchResults | Where-Object { $_.HasANR } | ForEach-Object {
        Write-Host "  App: $($_.App), AVD: $($_.AVD)" -ForegroundColor Red
        Write-Host "  $($_.ANRDetails)" -ForegroundColor Gray
    }
}

if ($passedTests -eq $totalTests) {
    Write-Host "`n✅ ANR FIX VALIDATED: All apps launch successfully!" -ForegroundColor Green
} else {
    Write-Host "`n⚠️ Some issues remain. Check details above." -ForegroundColor Yellow
}

Write-Host "="*80 "`n" -ForegroundColor Cyan
