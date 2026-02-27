# Build all apps sequentially with validation steps (pub get, gen-l10n, analyze, test, build AAB)
param(
    [switch]$SkipTests = $false
)

$root = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $root

$appsDir = Join-Path $root "..\apps"
$apps = Get-ChildItem -Path $appsDir -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'pubspec.yaml') }

$artifactsRoot = Join-Path $root "..\artifacts\builds_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Force -Path $artifactsRoot | Out-Null

foreach ($app in $apps) {
    $appPath = $app.FullName
    $appName = $app.Name
    Write-Host "\n===== Building $appName =====" -ForegroundColor Cyan

    $appArtifactDir = Join-Path $artifactsRoot $appName
    New-Item -ItemType Directory -Force -Path $appArtifactDir | Out-Null

    Push-Location $appPath

    # run pub get
    Write-Host "-> flutter pub get" -ForegroundColor Yellow
    flutter pub get *>&1 | Tee-Object -FilePath (Join-Path $appArtifactDir 'pub_get.log')

    # gen-l10n
    Write-Host "-> flutter gen-l10n (if configured)" -ForegroundColor Yellow
    try {
        flutter gen-l10n *>&1 | Tee-Object -FilePath (Join-Path $appArtifactDir 'gen_l10n.log')
    } catch {
        Write-Host "  gen-l10n failed or not configured: $_" -ForegroundColor DarkYellow
    }

    # analyze
    Write-Host "-> flutter analyze" -ForegroundColor Yellow
    flutter analyze *>&1 | Tee-Object -FilePath (Join-Path $appArtifactDir 'analyze.log')

    # tests
    if (-not $SkipTests) {
        Write-Host "-> flutter test" -ForegroundColor Yellow
        flutter test *>&1 | Tee-Object -FilePath (Join-Path $appArtifactDir 'test.log')
    } else {
        Write-Host "-> Skipping tests (SkipTests)"
    }

    # build AAB
    Write-Host "-> flutter build appbundle --release" -ForegroundColor Yellow
    $buildResult = flutter build appbundle --release *>&1 | Tee-Object -FilePath (Join-Path $appArtifactDir 'build.log')

    # Copy AAB artifact if exists
    $aabPath = Join-Path $appPath "build\app\outputs\bundle\release\app-release.aab"
    if (Test-Path $aabPath) {
        Copy-Item -Path $aabPath -Destination (Join-Path $appArtifactDir "${appName}-app-release.aab") -Force
        Write-Host "  ✅ AAB generated and copied to artifacts for $appName" -ForegroundColor Green
    } else {
        Write-Host "  ❌ AAB not found for $appName; check build.log" -ForegroundColor Red
    }

    Pop-Location
}

Write-Host "\nAll builds finished. Artifacts saved to: $artifactsRoot" -ForegroundColor Green
