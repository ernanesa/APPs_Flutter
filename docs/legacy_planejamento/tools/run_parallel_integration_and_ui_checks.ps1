$map = @(
  @{ AppPath = 'apps/health/bmi_calculator'; Device = 'emulator-5554'; Package='sa.rezende.bmi_calculator' },
  @{ AppPath = 'apps/productivity/pomodoro_timer'; Device = 'emulator-5556'; Package='sa.rezende.pomodoro_timer' },
  @{ AppPath = 'apps/finance/compound_interest_calculator'; Device = 'emulator-5558'; Package='sa.rezende.compound_interest_calculator' }
)

$jobs = @()
foreach ($m in $map) {
  $jobs += Start-Job -ScriptBlock {
    param($appPath, $dev, $pkg)

    $result = @{ App = $appPath; Device = $dev; Package = $pkg; Install = $false; Integration = $false; UI = @(); ScreenshotPaths = @(); Output = '' }

    # Build & install debug APK
    Write-Host "Building debug APK for $appPath" -ForegroundColor Cyan
    Push-Location $appPath
    $buildOut = flutter build apk --debug 2>&1 | Out-String
    Pop-Location
    $result.Output += "BUILD_OUTPUT:`n$buildOut`n"

    $apkPath = Join-Path $appPath "build/app/outputs/flutter-apk/app-debug.apk"
    if (Test-Path $apkPath) {
      Write-Host "Installing $apkPath to $dev" -ForegroundColor Cyan
      $installOut = & adb -s $dev install -r $apkPath 2>&1 | Out-String
      $result.Output += "INSTALL_OUTPUT:`n$installOut`n"
      if ($installOut -match "Success") { $result.Install = $true }
    } else {
      $result.Output += "APK_NOT_FOUND: $apkPath`n"
    }

    # Launch app
    Write-Host "Launching $pkg on $dev" -ForegroundColor Cyan
    & adb -s $dev shell monkey -p $pkg -c android.intent.category.LAUNCHER 1 | Out-Null
    Start-Sleep -Seconds 2

    # UI interactions (generic): tap primary button if exists, capture screenshot and ui dump
    $uiDumpPath = "/sdcard/ui_check_" + ($pkg -replace '[^a-zA-Z0-9]','_') + ".xml"
    & adb -s $dev shell uiautomator dump $uiDumpPath | Out-String | Out-Null
    $dump = & adb -s $dev shell cat $uiDumpPath 2>&1 | Out-String
    $result.Output += "UIDUMP:`n$dump`n"

    # Try to tap center of screen to trigger primary action
    & adb -s $dev shell wm size | Out-Null
    $sizeOut = & adb -s $dev shell wm size 2>&1 | Out-String
    if ($sizeOut -match "Physical size: (\d+)x(\d+)") {
      $w = [int]$Matches[1]
      $h = [int]$Matches[2]
      $x = [int]($w/2)
      $y = [int]($h*0.6)
      & adb -s $dev shell input tap $x $y
      Start-Sleep -Seconds 1
    }

    # Capture screenshot
    $localScreenshot = "artifacts/" + (($pkg -split '\.')[-1]) + "_" + $dev + "_ui.png"
    & adb -s $dev exec-out screencap -p > $localScreenshot
    $result.ScreenshotPaths += $localScreenshot

    # Run integration tests if integration_test exists
    $integrationPath = Join-Path $appPath "integration_test"
    if (Test-Path $integrationPath) {
      Write-Host "Running integration tests for $appPath on device $dev" -ForegroundColor Cyan
      Push-Location $appPath
      $driveOut = flutter drive --driver=test_driver/integration_test.dart --target=integration_test/screenshot_test.dart -d $dev 2>&1 | Out-String
      Pop-Location
      $result.Output += "INTEGRATION_OUTPUT:`n$driveOut`n"
      if ($driveOut -match "All tests passed") { $result.Integration = $true }
    } else {
      $result.Output += "INTEGRATION_NOT_FOUND: $integrationPath`n"
    }

    return $result
  } -ArgumentList $m.AppPath, $m.Device, $m.Package
}

Write-Host "Waiting for UI & integration jobs to complete..." -ForegroundColor Cyan
$jobs | Wait-Job -Timeout 3600

Write-Host "Collecting job outputs..." -ForegroundColor Cyan
$allResults = @()
foreach ($j in $jobs) {
  $r = Receive-Job -Job $j -Keep
  $allResults += $r
  Write-Host "--- Result for $($r.App) on $($r.Device) ---" -ForegroundColor Gray
  Write-Host "Installed: $($r.Install) | IntegrationPassed: $($r.Integration)" -ForegroundColor White
  Write-Host "Screenshots: $($r.ScreenshotPaths -join ', ')" -ForegroundColor White
  Write-Host "Output excerpt:`n$($r.Output.Substring(0,[math]::Min($r.Output.Length,1000)))`n" -ForegroundColor DarkGray
}

# Save summary
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$summaryPath = "artifacts/ui_integration_summary_$timestamp.json"
$allResults | ConvertTo-Json -Depth 6 | Out-File $summaryPath -Encoding utf8
Write-Host "Summary written to: $summaryPath" -ForegroundColor Green

# Cleanup
$jobs | Remove-Job -Force
Write-Host "UI & Integration checks completed." -ForegroundColor Green
