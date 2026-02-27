$apps = @(
  'apps/health/bmi_calculator',
  'apps/productivity/pomodoro_timer',
  'apps/finance/compound_interest_calculator'
)

$jobs = @()
foreach ($a in $apps) {
  Write-Host "Starting tests for: $a" -ForegroundColor Cyan
  $jobs += Start-Job -ScriptBlock { param($p) Push-Location $p; flutter test --concurrency=6 2>&1 | Out-String } -ArgumentList $a
}

Write-Host "Waiting for test jobs to complete..." -ForegroundColor Cyan
$jobs | Wait-Job

Write-Host "Collecting test outputs..." -ForegroundColor Cyan
foreach ($j in $jobs) {
  Write-Host "--- Test Output for job $($j.Id) ---" -ForegroundColor Gray
  $out = Receive-Job -Job $j -Keep
  Write-Host $out
}

# Cleanup
$jobs | Remove-Job -Force
Write-Host "All tests completed." -ForegroundColor Green
