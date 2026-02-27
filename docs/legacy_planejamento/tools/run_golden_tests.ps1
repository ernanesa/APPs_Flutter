Param(
  [string]$AppName = "all",
  [double]$Threshold = 0.998
)

Write-Host "🔬 Running golden tests for $AppName" -ForegroundColor Cyan

# Expected layout:
# artifacts/goldens/<app>/baseline/*.png
# artifacts/goldens/<app>/current/*.png
# diffs -> artifacts/goldens/<app>/diffs/

$baseDir = "artifacts/goldens/$AppName/baseline"
$curDir = "artifacts/goldens/$AppName/current"
$diffDir = "artifacts/goldens/$AppName/diffs"

if (-not (Test-Path $baseDir)) { Write-Host "❌ Baseline directory not found: $baseDir" -ForegroundColor Red; exit 0 }
if (-not (Test-Path $curDir)) { Write-Host "⚠️ Current images not found: $curDir - attempting to generate via integration tests" -ForegroundColor Yellow; pwsh -NoProfile -File tools/generate_goldens_for_app.ps1 -AppName $AppName; if (-not (Test-Path $curDir)) { Write-Host "❌ Still no current images found: $curDir" -ForegroundColor Red; exit 0 } }

$failed = @()

Get-ChildItem -Path $baseDir -Filter *.png | ForEach-Object {
    $base = $_.FullName
    $name = $_.Name
    $cur = Join-Path $curDir $name
    if (-not (Test-Path $cur)) { Write-Host "⚠️ Missing current image for $name" -ForegroundColor Yellow; $failed += $name; return }
    $outDiff = Join-Path $diffDir ($name + "_diff.png")
    New-Item -ItemType Directory -Force -Path (Split-Path $outDiff) | Out-Null

    Write-Host "Comparing $name" -ForegroundColor Gray
    $cmd = @('python3', 'tools/golden_compare.py', '--baseline', $base, '--current', $cur, '--output-diff', $outDiff, '--threshold', $Threshold.ToString('F3'))

    $proc = Start-Process -FilePath python3 -ArgumentList $cmd[1..($cmd.Count-1)] -NoNewWindow -PassThru -Wait -RedirectStandardOutput -RedirectStandardError
    $out = $proc.StandardOutput.ReadToEnd()
    if ($proc.ExitCode -ne 0) {
        Write-Host "❌ Diff too large or error comparing $name" -ForegroundColor Red
        Write-Host $out
        $failed += $name
    } else {
        Write-Host "✅ $name OK" -ForegroundColor Green
    }
}

if ($failed.Count -gt 0) {
    Write-Host "\n❌ Golden comparisons failed for: $($failed -join ', ')" -ForegroundColor Red
    exit 1
} else {
    Write-Host "\n✅ All golden comparisons passed for $AppName" -ForegroundColor Green
    exit 0
}
