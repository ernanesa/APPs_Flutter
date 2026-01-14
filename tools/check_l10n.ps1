[CmdletBinding()]
param(
  [Parameter(Mandatory = $false)]
  [string]$AppPath = ".\\bmi_calculator"
)

$ErrorActionPreference = 'Stop'

function Get-JsonObject([string]$path) {
  if (!(Test-Path $path)) {
    throw "File not found: $path"
  }
  $raw = Get-Content -LiteralPath $path -Raw -Encoding UTF8
  if ([string]::IsNullOrWhiteSpace($raw)) {
    throw "Empty file: $path"
  }
  return $raw | ConvertFrom-Json
}

$appFullPath = (Resolve-Path -LiteralPath $AppPath).Path
$l10nDir = Join-Path $appFullPath 'lib\l10n'
$templatePath = Join-Path $l10nDir 'app_en.arb'

if (!(Test-Path $l10nDir)) {
  throw "l10n directory not found: $l10nDir"
}
if (!(Test-Path $templatePath)) {
  throw "Template ARB not found: $templatePath"
}

$templateObj = Get-JsonObject $templatePath
$templateKeys = @($templateObj.PSObject.Properties.Name | Where-Object { $_ -and -not $_.StartsWith('@') })
$templateKeySet = [System.Collections.Generic.HashSet[string]]::new([string[]]$templateKeys)

$arbFiles = Get-ChildItem -LiteralPath $l10nDir -Filter 'app_*.arb' | Sort-Object Name
if ($arbFiles.Count -lt 2) {
  throw "Expected multiple ARB files in: $l10nDir"
}

$hasErrors = $false
Write-Host "Checking l10n keys in: $l10nDir" -ForegroundColor Cyan
Write-Host "Template: $($templatePath)" -ForegroundColor Cyan
Write-Host "Template keys: $($templateKeys.Count)" -ForegroundColor Cyan

foreach ($file in $arbFiles) {
  if ($file.FullName -eq $templatePath) { continue }

  $obj = Get-JsonObject $file.FullName
  $keys = @($obj.PSObject.Properties.Name | Where-Object { $_ -and -not $_.StartsWith('@') })
  $keySet = [System.Collections.Generic.HashSet[string]]::new([string[]]$keys)

  $missing = @()
  foreach ($k in $templateKeys) {
    if (-not $keySet.Contains($k)) { $missing += $k }
  }

  $extra = @()
  foreach ($k in $keys) {
    if (-not $templateKeySet.Contains($k)) { $extra += $k }
  }

  if ($missing.Count -gt 0 -or $extra.Count -gt 0) {
    $hasErrors = $true
    Write-Host "\n$file" -ForegroundColor Yellow
    if ($missing.Count -gt 0) {
      Write-Host "  Missing keys ($($missing.Count)):" -ForegroundColor Red
      $missing | Sort-Object | ForEach-Object { Write-Host "    - $_" -ForegroundColor Red }
    }
    if ($extra.Count -gt 0) {
      Write-Host "  Extra keys ($($extra.Count)):" -ForegroundColor DarkYellow
      $extra | Sort-Object | ForEach-Object { Write-Host "    + $_" -ForegroundColor DarkYellow }
    }
  }
}

if ($hasErrors) {
  Write-Host "\nFAIL: l10n keys are not in sync." -ForegroundColor Red
  exit 1
}

Write-Host "\nOK: all ARB files match template keys." -ForegroundColor Green
