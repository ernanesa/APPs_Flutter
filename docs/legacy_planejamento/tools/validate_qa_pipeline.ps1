Param(
  [string]$AppName = "all"
)

Write-Host "🔧 Running QA Pipeline Validation for: $AppName" -ForegroundColor Cyan

# 1. Lint + Tests + l10n
Write-Host "1. Running melos run qa (lint + test + check:l10n)" -ForegroundColor Yellow
melos run qa
if ($LASTEXITCODE -ne 0) { Write-Host "❌ QA gate failed (melos run qa)" -ForegroundColor Red; exit 1 }

# 2. Store assets check
Write-Host "2. Running check_store_assets" -ForegroundColor Yellow
melos run check:store_assets
if ($LASTEXITCODE -ne 0) { Write-Host "❌ Store assets check failed" -ForegroundColor Red; exit 1 }

# 3. Golden tests (placeholder)
Write-Host "3. Running golden tests (placeholder)" -ForegroundColor Yellow
pwsh -NoProfile -File tools/run_golden_tests.ps1 -AppName $AppName
if ($LASTEXITCODE -ne 0) { Write-Host "❌ Golden tests failed" -ForegroundColor Red; exit 1 }

# 4. Perf smoke (placeholder)
Write-Host "4. Running perf smoke (placeholder)" -ForegroundColor Yellow
pwsh -NoProfile -File tools/run_perf_smoke.ps1 -AppName $AppName
if ($LASTEXITCODE -ne 0) { Write-Host "❌ Perf smoke failed" -ForegroundColor Red; exit 1 }

# 5. Security scan (placeholder)
Write-Host "5. Running security scan (MobSF placeholder)" -ForegroundColor Yellow
pwsh -NoProfile -File tools/run_mobsf_scan.ps1 -AppName $AppName
if ($LASTEXITCODE -ne 0) { Write-Host "❌ Security scan failed" -ForegroundColor Red; exit 1 }

Write-Host "✅ QA Pipeline Validation PASSED for $AppName" -ForegroundColor Green
exit 0
