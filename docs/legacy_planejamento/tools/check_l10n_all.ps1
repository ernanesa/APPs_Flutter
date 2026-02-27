[CmdletBinding()]
param(
  [Parameter(Mandatory = $false)]
  [string]$AppsRoot = ".\\apps"
)

$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$legacyScript = Join-Path $scriptDir "legacy\\check_l10n.ps1"

if (!(Test-Path $legacyScript)) {
  throw "Legacy script not found: $legacyScript"
}

$appsRootFullPath = (Resolve-Path -LiteralPath $AppsRoot).Path
if (!(Test-Path $appsRootFullPath)) {
  throw "Apps root not found: $appsRootFullPath"
}

$apps = Get-ChildItem -LiteralPath $appsRootFullPath -Directory -Recurse -Depth 1 |
  Where-Object {
    Test-Path (Join-Path $_.FullName "lib\\l10n\\app_en.arb")
  } |
  Sort-Object FullName

if ($apps.Count -eq 0) {
  Write-Host "No apps with lib/l10n/app_en.arb found under: $appsRootFullPath" -ForegroundColor Yellow
  exit 0
}

$failed = @()
Write-Host "Validating l10n for $($apps.Count) app(s)..." -ForegroundColor Cyan

foreach ($app in $apps) {
  $relative = $app.FullName.Replace((Resolve-Path -LiteralPath ".").Path + "\\", ".\\")
  Write-Host "`n==> $relative" -ForegroundColor Cyan
  try {
    $shell = (Get-Command pwsh -ErrorAction SilentlyContinue)
    if ($null -ne $shell) {
      pwsh -NoProfile -File $legacyScript -AppPath $app.FullName
    } else {
      powershell.exe -NoProfile -ExecutionPolicy Bypass -File $legacyScript -AppPath $app.FullName
    }
  } catch {
    $failed += $relative
  }
}

if ($failed.Count -gt 0) {
  Write-Host "`nFAIL: l10n validation failed for:" -ForegroundColor Red
  $failed | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
  exit 1
}

Write-Host "`nOK: l10n validation passed for all apps." -ForegroundColor Green
