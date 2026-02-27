$map = @(
  @{ AppPath = 'apps/health/bmi_calculator'; Device = 'emulator-5554' },
  @{ AppPath = 'apps/productivity/pomodoro_timer'; Device = 'emulator-5556' },
  @{ AppPath = 'apps/finance/compound_interest_calculator'; Device = 'emulator-5558' }
)

$jobs = @()
foreach ($m in $map) {
  $app = $m.AppPath
  $device = $m.Device
  $jobs += Start-Job -ScriptBlock {
    param($appPath, $dev)
    Write-Host "Building debug APK for $appPath" -ForegroundColor Cyan
    Push-Location $appPath
    $out = flutter build apk --debug 2>&1 | Out-String
    Pop-Location
    $apkPath = Join-Path $appPath "build/app/outputs/flutter-apk/app-debug.apk"
    $result = @{ App = $appPath; ApkPath = $apkPath; Device = $dev; Built = $false; Installed = $false; Output = $out }
    if (Test-Path $apkPath) {
      $result.Built = $true
      Write-Host "Installing $apkPath to device $dev" -ForegroundColor Cyan
      $installOut = & adb -s $dev install -r $apkPath 2>&1 | Out-String
      if ($installOut -match "Success") { $result.Installed = $true }
      $result.Output += "`nINSTALL_OUTPUT:`n" + $installOut
    } else {
      $result.Output += "`nAPK_NOT_FOUND: $apkPath"
    }
    return $result
  } -ArgumentList $m.AppPath, $m.Device
}

Write-Host "Waiting for build/install jobs to complete..." -ForegroundColor Cyan
$jobs | Wait-Job

Write-Host "Collecting results..." -ForegroundColor Cyan
foreach ($j in $jobs) {
  $r = Receive-Job -Job $j -Keep
  Write-Host "--- Result for: $($r.App) ---" -ForegroundColor Gray
  Write-Host "Built: $($r.Built) | Installed: $($r.Installed) | Device: $($r.Device)\n" -ForegroundColor White
  Write-Host $r.Output -ForegroundColor DarkGray
}

$jobs | Remove-Job -Force
Write-Host "Debug build & install finished." -ForegroundColor Green
