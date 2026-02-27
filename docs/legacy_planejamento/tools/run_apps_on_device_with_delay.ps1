param(
  [string]$DeviceId = "",
  [int]$DelaySeconds = 25,
  [switch]$SkipTests = $false
)

# Set up
$root = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $root

function Get-DeviceId {
  $devices = & adb devices | Where-Object {$_ -and $_ -notmatch 'List'} | ForEach-Object { ($_ -split "\s+")[0] }
  $devices = $devices | Where-Object {$_ -ne ''}
  if ($DeviceId -ne '' -and $devices -contains $DeviceId) { return $DeviceId }
  if ($devices.Count -ge 1) { return $devices[0] }
  throw "No ADB device found. Connect device and try again."
}

$device = Get-DeviceId
Write-Host "Using device: $device" -ForegroundColor Cyan

$appsDir = Join-Path $root "..\apps"
$apps = Get-ChildItem -Path $appsDir -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'pubspec.yaml') }

$artifactsRoot = Join-Path $root "..\artifacts\run_on_device_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Force -Path $artifactsRoot | Out-Null

foreach ($app in $apps) {
  $appName = $app.Name
  $appPath = $app.FullName
  $appArtifactDir = Join-Path $artifactsRoot $appName
  New-Item -ItemType Directory -Force -Path $appArtifactDir | Out-Null

  Write-Host "\n=== Processing $appName ===" -ForegroundColor Green
  Push-Location $appPath

  # Dependency and generation
  flutter pub get *>&1 | Tee-Object -FilePath (Join-Path $appArtifactDir 'pub_get.log')
  try { flutter gen-l10n *>&1 | Tee-Object -FilePath (Join-Path $appArtifactDir 'gen_l10n.log') } catch { Write-Host "gen-l10n may not be configured for $appName" -ForegroundColor Yellow }
  flutter analyze *>&1 | Tee-Object -FilePath (Join-Path $appArtifactDir 'analyze.log')

  if (-not $SkipTests) {
    flutter test *>&1 | Tee-Object -FilePath (Join-Path $appArtifactDir 'test.log')
  }

  # Build apk (universal)
  Write-Host "Building release APK for $appName (universal)" -ForegroundColor Yellow
  flutter build apk --release *>&1 | Tee-Object -FilePath (Join-Path $appArtifactDir 'build_apk.log')

  $apkPath = Join-Path $appPath "build\app\outputs\flutter-apk\app-release.apk"
  if (-not (Test-Path $apkPath)) {
    Write-Host "APK not found at $apkPath - skipping install" -ForegroundColor Red
    Pop-Location
    continue
  }

  # Extract package name from AndroidManifest.xml
  $manifest = Join-Path $appPath "android\app\src\main\AndroidManifest.xml"
  $packageName = $null
  if (Test-Path $manifest) {
    $xml = Get-Content $manifest -Raw
    $m = [regex]::Match($xml, 'package\s*=\s*"([^"]+)"')
    if ($m.Success) { $packageName = $m.Groups[1].Value }
  }
  if (-not $packageName) {
    # fallback to reading applicationId from build.gradle
    $gradle = Join-Path $appPath "android\app\build.gradle"
    if (Test-Path $gradle) {
      $g = Get-Content $gradle -Raw
      $m = [regex]::Match($g, 'applicationId\s*=\s*"([^"]+)"')
      if ($m.Success) { $packageName = $m.Groups[1].Value }
    }
  }

  Write-Host "Package: $packageName" -ForegroundColor Cyan

  # Install APK
  Write-Host "Installing APK to device $device" -ForegroundColor Yellow
  & adb -s $device install -r $apkPath *>&1 | Tee-Object -FilePath (Join-Path $appArtifactDir 'adb_install.log')

  # Clear and capture logs
  & adb -s $device logcat -c

  # Launch app (monkey)
  if ($packageName) {
    & adb -s $device shell monkey -p $packageName -c android.intent.category.LAUNCHER 1 *>&1 | Tee-Object -FilePath (Join-Path $appArtifactDir 'adb_launch.log')
  } else {
    Write-Host "Package name unknown; cannot launch via monkey." -ForegroundColor Yellow
  }

  # Wait and let user observe
  Write-Host "Waiting $DelaySeconds seconds for observation (app: $appName)..." -ForegroundColor Magenta
  Start-Sleep -Seconds $DelaySeconds

  # Screenshot
  $ts = (Get-Date -Format 'yyyyMMdd_HHmmss')
  $screenshotPath = Join-Path $appArtifactDir "screenshot_$ts.png"
  & adb -s $device exec-out screencap -p > $screenshotPath
  Write-Host "Saved screenshot to $screenshotPath"

  # Dump logcat
  & adb -s $device logcat -d *>&1 | Tee-Object -FilePath (Join-Path $appArtifactDir 'logcat.txt')

  Pop-Location
}

Write-Host "\nAll apps processed. Artifacts are under: $artifactsRoot" -ForegroundColor Green
