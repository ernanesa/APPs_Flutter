# tools/run_blitz.ps1
# The Ultimate Testing Blitz Executor
# Runs tests for all Flutter apps in the monorepo.

param (
  [switch]$UpdateGoldens = $false,
  [switch]$Fast = $false # Skips pub get if true
)

$ErrorActionPreference = "Stop"
$AppRoot = Resolve-Path "apps"
$Apps = Get-ChildItem -Path $AppRoot -Directory -Recurse | Where-Object { Test-Path "$($_.FullName)\pubspec.yaml" }

Write-Host "`n🔥 STARTING ULTIMATE TESTING BLITZ 🔥" -ForegroundColor Magenta
Write-Host "Found $( $Apps.Count ) apps to test.`n" -ForegroundColor Gray

$Results = @{}
$StartTime = Get-Date

foreach ($App in $Apps) {
  Write-Host "👉 [$($App.Name)]" -ForegroundColor Cyan -NoNewline
    
  $AppPath = $App.FullName
  Push-Location $AppPath

  try {
    # 1. Pub Get (unless skipped)
    if (-not $Fast) {
      Write-Host " 📦 dep..." -NoNewline -ForegroundColor DarkGray
      $null = & "C:\Users\Ernane\flutter\sdk\bin\flutter.bat" pub get 2>&1
    }

    # 2. Run Tests
    Write-Host " 🧪 testing..." -NoNewline -ForegroundColor Yellow
        
    $TestCmd = "& 'C:\Users\Ernane\flutter\sdk\bin\flutter.bat' test"
    if ($UpdateGoldens) {
      $TestCmd += " --update-goldens"
    }
        
    Invoke-Expression $TestCmd | Out-Null
        
    Write-Host " ✅ PASS" -ForegroundColor Green
    $Results[$App.Name] = "PASS"
  }
  catch {
    Write-Host " ❌ FAIL" -ForegroundColor Red
    $Results[$App.Name] = "FAIL"
    # Optional: Print error details if needed, but keeping output clean for blitz
  }
  finally {
    Pop-Location
  }
}

$Duration = (Get-Date) - $StartTime
Write-Host "`n📊 BLITZ COMPLETE inOT in $($Duration.TotalSeconds.ToString("N1"))s" -ForegroundColor Magenta
Write-Host "============================="

foreach ($Key in $Results.Keys) {
  $Status = $Results[$Key]
  $Color = if ($Status -eq "PASS") { "Green" } else { "Red" }
  Write-Host "$Key : $Status" -ForegroundColor $Color
}

if ($Results.Values -contains "FAIL") {
  Exit 1
}
Exit 0
