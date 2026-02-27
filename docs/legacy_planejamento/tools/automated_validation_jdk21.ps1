param(
    [switch]$BuildRepresentative = $true
)

$root = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $root

Write-Host "🔍 Scanning apps under ../apps for Flutter projects..."
$apps = Get-ChildItem -Path "$root\..\apps" -Directory | Where-Object {
    Test-Path "$($_.FullName)\pubspec.yaml"
}

$repApps = @(
    "apps/health/bmi_calculator",
    "apps/productivity/pomodoro_timer",
    "apps/finance/compound_interest_calculator",
    "apps/media/white_noise"
)

foreach ($app in $apps) {
    $appPath = Resolve-Path "$($app.FullName)"
    Write-Host "\n====== Processing $($app.Name) ======" -ForegroundColor Cyan
    Set-Location $appPath

    Write-Host "→ flutter pub get" -ForegroundColor Yellow
    flutter pub get

    Write-Host "→ flutter gen-l10n (if l10n files exist)" -ForegroundColor Yellow
    try {
        flutter gen-l10n
    } catch {
        Write-Host "  gen-l10n failed or not configured: $_" -ForegroundColor DarkYellow
    }

    Write-Host "→ flutter analyze" -ForegroundColor Yellow
    $analyzeExit = & flutter analyze; if ($LASTEXITCODE -ne 0) { Write-Host "  ✖ analyze failed ($LASTEXITCODE)" -ForegroundColor Red }

    Write-Host "→ flutter test" -ForegroundColor Yellow
    $testExit = & flutter test; if ($LASTEXITCODE -ne 0) { Write-Host "  ✖ tests failed ($LASTEXITCODE)" -ForegroundColor Red }

    if ($BuildRepresentative -and ($repApps -contains ("apps/" + $app.Name))) {
        Write-Host "→ flutter build appbundle --release (representative build)" -ForegroundColor Yellow
        $buildExit = & flutter build appbundle --release; if ($LASTEXITCODE -ne 0) { Write-Host "  ✖ build failed ($LASTEXITCODE)" -ForegroundColor Red }
    }
}

Write-Host "\n✅ Validation run complete. Check logs above for failures." -ForegroundColor Green
