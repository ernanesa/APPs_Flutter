[CmdletBinding()]
param(
  [Parameter(Mandatory = $false)]
  [string]$PublishingRoot = ".\\apps"
)

$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$legacyScript = Join-Path $scriptDir "legacy\\check_store_assets.ps1"

if (!(Test-Path $legacyScript)) {
  throw "Legacy script not found: $legacyScript"
}

if (!(Test-Path $PublishingRoot)) {
  Write-Host "Publishing root not found (skipping): $PublishingRoot" -ForegroundColor Yellow
  exit 0
}

$publishingRootFullPath = (Resolve-Path -LiteralPath $PublishingRoot).Path

$storeAssetsGlob = "$publishingRootFullPath\\*\\*\\publishing\\store_assets"
$storeAssetsDirs = Get-ChildItem -Path $storeAssetsGlob -Directory -ErrorAction SilentlyContinue |
  Sort-Object FullName |
  ForEach-Object { $_.FullName }

if ($storeAssetsDirs.Count -eq 0) {
  Write-Host "No store_assets directories found under: $storeAssetsGlob" -ForegroundColor Yellow
  exit 0
}

$failed = @()
Write-Host "Validating Play Store assets for $($storeAssetsDirs.Count) app(s)..." -ForegroundColor Cyan

foreach ($dir in $storeAssetsDirs) {
  $relative = $dir.Replace((Resolve-Path -LiteralPath ".").Path + "\\", ".\\")
  Write-Host "`n==> $relative" -ForegroundColor Cyan
  try {
    $shell = (Get-Command pwsh -ErrorAction SilentlyContinue)
    if ($null -ne $shell) {
      pwsh -NoProfile -File $legacyScript -AssetsDir $dir
    } else {
      powershell.exe -NoProfile -ExecutionPolicy Bypass -File $legacyScript -AssetsDir $dir
    }
  } catch {
    $failed += $relative
  }
}

if ($failed.Count -gt 0) {
  Write-Host "`nFAIL: store assets validation failed for:" -ForegroundColor Red
  $failed | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
  exit 1
}

Write-Host "`nOK: store assets validation passed for all apps." -ForegroundColor Green
