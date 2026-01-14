[CmdletBinding()]
param(
  [Parameter(Mandatory = $false)]
  [string]$AssetsDir = ".\\DadosPublicacao\\bmi_calculator\\store_assets"
)

$ErrorActionPreference = 'Stop'

function Get-ImageSize([string]$path) {
  Add-Type -AssemblyName System.Drawing | Out-Null
  $img = [System.Drawing.Image]::FromFile($path)
  try {
    return [PSCustomObject]@{ Width = $img.Width; Height = $img.Height }
  }
  finally {
    $img.Dispose()
  }
}

$assetsFullPath = (Resolve-Path -LiteralPath $AssetsDir).Path
if (!(Test-Path $assetsFullPath)) {
  throw "Assets directory not found: $assetsFullPath"
}

Write-Host "Checking Play Store assets in: $assetsFullPath" -ForegroundColor Cyan

$requiredExact = @(
  @{ Name = 'icon_512.png'; Width = 512; Height = 512 },
  @{ Name = 'feature_1024x500.png'; Width = 1024; Height = 500 }
)

$hasErrors = $false

foreach ($req in $requiredExact) {
  $p = Join-Path $assetsFullPath $req.Name
  if (!(Test-Path $p)) {
    $hasErrors = $true
    Write-Host "Missing required file: $($req.Name)" -ForegroundColor Red
    continue
  }

  $s = Get-ImageSize $p
  $dims = "$($s.Width)x$($s.Height)"
  if ($s.Width -ne $req.Width -or $s.Height -ne $req.Height) {
    $hasErrors = $true
    Write-Host "Invalid size for $($req.Name): $dims (expected $($req.Width)x$($req.Height))" -ForegroundColor Red
  }
  else {
    Write-Host "OK: $($req.Name) = $dims" -ForegroundColor Green
  }
}

$shotFiles = Get-ChildItem -LiteralPath $assetsFullPath -File |
  Where-Object { $_.Name -match '\\.(png|jpg|jpeg)$' -and $_.Name -match 'phone|screenshot' } |
  Sort-Object Name

if ($shotFiles.Count -lt 2) {
  $hasErrors = $true
  Write-Host "Expected at least 2 phone screenshots named like '*phone*' or '*screenshot*' (png/jpg). Found: $($shotFiles.Count)" -ForegroundColor Red
}
else {
  Write-Host "Found phone screenshots: $($shotFiles.Count)" -ForegroundColor Cyan
  foreach ($f in $shotFiles) {
    $s = Get-ImageSize $f.FullName
    $dims = "$($s.Width)x$($s.Height)"

    $min = 320
    $max = 3840
    if ($s.Width -lt $min -or $s.Height -lt $min -or $s.Width -gt $max -or $s.Height -gt $max) {
      $hasErrors = $true
      Write-Host "Invalid screenshot size range: $($f.Name) = $dims (must be between ${min}-${max}px)" -ForegroundColor Red
      continue
    }

    # Rough aspect ratio guidance: portrait screenshots should be taller than wide
    if ($s.Height -le $s.Width) {
      $hasErrors = $true
      Write-Host "Suspicious orientation (expected portrait): $($f.Name) = $dims" -ForegroundColor DarkYellow
    }
    else {
      Write-Host "OK: $($f.Name) = $dims" -ForegroundColor Green
    }
  }
}

if ($hasErrors) {
  Write-Host "\nFAIL: store assets validation failed." -ForegroundColor Red
  exit 1
}

Write-Host "\nOK: store assets look valid." -ForegroundColor Green
