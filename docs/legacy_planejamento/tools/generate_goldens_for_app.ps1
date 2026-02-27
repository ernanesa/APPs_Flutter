Param(
  [Parameter(Mandatory=$true)][string]$AppName,
  [string]$Device = "emulator-5554"
)

# Locate app path under apps/* if present
$repoRoot = Resolve-Path .
$appPath = Get-ChildItem -Directory -Path "apps" -Recurse -Depth 2 | Where-Object { $_.Name -eq $AppName } | Select-Object -First 1
if (-not $appPath) {
    Write-Host "❌ App $AppName not found under apps/" -ForegroundColor Red
    exit 1
}

$appDir = $appPath.FullName
Write-Host "📸 Generating goldens for $AppName at $appDir" -ForegroundColor Cyan

# Clean current output
$curDir = Join-Path "$(Resolve-Path artifacts/goldens).Path" "$AppName\current"
New-Item -ItemType Directory -Force -Path $curDir | Out-Null

# Run integration test to generate screenshots
Push-Location $appDir
try {
    Write-Host "Running integration tests (flutter drive) on $Device..." -ForegroundColor Yellow
    flutter drive --driver=test_driver/integration_test.dart --target=integration_test/screenshot_test.dart -d $Device
} catch {
    Write-Host "⚠️ flutter drive failed or no device available" -ForegroundColor Yellow
}

# Collect screenshots from typical locations
$sources = @(
    Join-Path $appDir "integration_test/screenshots",
    Join-Path $appDir "build"  # fallback
)

$found = $false
foreach ($src in $sources) {
    if (Test-Path $src) {
        Get-ChildItem -Path $src -Filter *.png -Recurse | ForEach-Object {
            Copy-Item -Path $_.FullName -Destination (Join-Path $curDir $_.Name) -Force
            $found = $true
        }
    }
}

if (-not $found) {
    Write-Host "⚠️ No screenshots found after integration test. Check integration_test output paths." -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "✅ Current goldens generated in $curDir" -ForegroundColor Green
    exit 0
}
Pop-Location
