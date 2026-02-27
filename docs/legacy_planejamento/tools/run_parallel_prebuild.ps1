$apps = @(
  'apps/health/bmi_calculator',
  'apps/productivity/pomodoro_timer',
  'apps/finance/compound_interest_calculator'
)

$jobs = @()
foreach ($a in $apps) {
  Write-Host "Starting pre-build check for: $a" -ForegroundColor Cyan
  $jobs += Start-Job -ScriptBlock { param($p) pwsh tools/pre_build_check.ps1 -AppPath $p -DetailedOutput } -ArgumentList $a
}

Write-Host "Waiting for jobs to complete..." -ForegroundColor Cyan
$jobs | Wait-Job

Write-Host "Collecting outputs..." -ForegroundColor Cyan
foreach ($j in $jobs) {
  Write-Host "--- Output for job $($j.Id) ---" -ForegroundColor Gray
  Receive-Job -Job $j -Keep
}

# Cleanup
$jobs | Remove-Job -Force
Write-Host "All pre-build checks completed." -ForegroundColor Green
