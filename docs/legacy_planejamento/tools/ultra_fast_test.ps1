# ========================================
# ULTRA FAST TEST - Parallel Execution
# ========================================
# Purpose: Test all apps on all AVDs simultaneously
# No delays, maximum speed, clear results

$ErrorActionPreference = "Continue"
$adb = "C:\Users\Ernane\AppData\Local\Android\Sdk\platform-tools\adb.exe"

$apps = @(
    @{Name="bmi_calculator"; Package="sa.rezende.bmi_calculator"},
    @{Name="pomodoro_timer"; Package="sa.rezende.pomodoro_timer"},
    @{Name="compound_interest_calculator"; Package="sa.rezende.compound_interest_calculator"}
)

$avds = & $adb devices | Select-String "emulator-\d+" | ForEach-Object { $_.Matches[0].Value }

Write-Host "`n🚀 ULTRA FAST TEST - Testing $($apps.Count) apps on $($avds.Count) AVDs in parallel...`n" -ForegroundColor Cyan

$jobs = @()
foreach ($app in $apps) {
    foreach ($avd in $avds) {
        $jobs += Start-Job -ScriptBlock {
            param($adb, $avd, $package, $appName)
            
            # Check installed
            $installed = & $adb -s $avd shell pm list packages | Select-String $package
            if (-not $installed) {
                return @{App=$appName; AVD=$avd; Status="Not installed"; ANR=$false; LaunchTime=0}
            }
            
            # Clear logcat
            & $adb -s $avd logcat -c 2>&1 | Out-Null
            
            # Launch
            $sw = [System.Diagnostics.Stopwatch]::StartNew()
            & $adb -s $avd shell am start -n "$package/.MainActivity" 2>&1 | Out-Null
            Start-Sleep -Seconds 3
            $sw.Stop()
            
            # Check ANR
            $anr = & $adb -s $avd logcat -d | Select-String "ANR" | Select-String $package
            $hasANR = $anr.Count -gt 0
            
            # Check running
            $running = & $adb -s $avd shell "ps | grep $package"
            $isRunning = $running.Length -gt 0
            
            $status = if ($hasANR) { "❌ ANR" } 
                     elseif (-not $isRunning) { "⚠️ Not running" }
                     else { "✅ OK" }
            
            return @{
                App = $appName
                AVD = $avd
                Status = $status
                ANR = $hasANR
                LaunchTime = [math]::Round($sw.Elapsed.TotalSeconds, 1)
            }
        } -ArgumentList $adb, $avd, $app.Package, $app.Name
    }
}

# Progress indicator
$total = $jobs.Count
Write-Host "Running $total tests..." -NoNewline -ForegroundColor Gray
while ($jobs | Where-Object { $_.State -eq 'Running' }) {
    Write-Host "." -NoNewline -ForegroundColor Gray
    Start-Sleep -Milliseconds 500
}
Write-Host " Done!`n" -ForegroundColor Green

# Collect results
$results = @()
foreach ($job in $jobs) {
    $results += Receive-Job -Job $job
    Remove-Job -Job $job
}

# Display results
Write-Host ("="*80) -ForegroundColor Cyan
Write-Host "RESULTS" -ForegroundColor Cyan
Write-Host ("="*80) -ForegroundColor Cyan

$results | Sort-Object App, AVD | ForEach-Object {
    $color = if ($_.Status -match "OK") { "Green" } 
             elseif ($_.Status -match "ANR") { "Red" }
             else { "Yellow" }
    
    Write-Host "$($_.Status.PadRight(20)) | " -NoNewline -ForegroundColor $color
    Write-Host "$($_.App.PadRight(30)) | " -NoNewline -ForegroundColor Gray
    Write-Host "$($_.AVD.PadRight(15)) | " -NoNewline -ForegroundColor Gray
    Write-Host "$($_.LaunchTime)s" -ForegroundColor Gray
}

Write-Host "`n" ("="*80) -ForegroundColor Cyan
$passed = ($results | Where-Object { $_.Status -match "OK" }).Count
$failed = ($results | Where-Object { $_.Status -match "ANR" }).Count
$warning = ($results | Where-Object { $_.Status -match "Not" }).Count

Write-Host "✅ Passed:  $passed" -ForegroundColor Green
Write-Host "❌ Failed:  $failed" -ForegroundColor $(if ($failed -gt 0) { "Red" } else { "Gray" })
Write-Host "⚠️ Warnings: $warning" -ForegroundColor $(if ($warning -gt 0) { "Yellow" } else { "Gray" })
Write-Host ("="*80) "`n" -ForegroundColor Cyan

if ($failed -eq 0) {
    Write-Host "🎉 ALL TESTS PASSED - No ANRs detected!`n" -ForegroundColor Green
} else {
    Write-Host "⚠️ ANRs detected. Check details above.`n" -ForegroundColor Red
}
