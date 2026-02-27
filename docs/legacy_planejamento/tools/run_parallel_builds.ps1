$builds = @(
  @{ App='bmi_calculator'; Category='health' },
  @{ App='pomodoro_timer'; Category='productivity' },
  @{ App='compound_interest_calculator'; Category='finance' }
)

$jobs = @()
foreach ($b in $builds) {
  $app = $b.App
  $cat = $b.Category
  Write-Host "Starting build job for: $app ($cat)" -ForegroundColor Cyan
  $jobs += Start-Job -ScriptBlock { param($a,$c) pwsh tools/batch_build.ps1 -Apps $a -Category $c -CollectAabs } -ArgumentList $app,$cat
}

Write-Host "Waiting for build jobs to complete..." -ForegroundColor Cyan
$jobs | Wait-Job

Write-Host "Collecting build outputs..." -ForegroundColor Cyan
foreach ($j in $jobs) {
  Write-Host "--- Build Output for job $($j.Id) ---" -ForegroundColor Gray
  Receive-Job -Job $j -Keep
}

# Cleanup
$jobs | Remove-Job -Force
Write-Host "All builds completed." -ForegroundColor Green
