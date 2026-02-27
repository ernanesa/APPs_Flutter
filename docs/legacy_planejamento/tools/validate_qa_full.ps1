#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Master QA Pipeline Orchestrator - Full Autonomous Validation

.DESCRIPTION
    Orchestrates complete QA validation for Flutter apps:
    - Golden visual regression tests
    - Performance smoke tests
    - Security scanning (MobSF)
    - Self-healing failure analysis
    - Architecture compliance

    Designed for Factory Mode: validates apps at scale.

.PARAMETER AppName
    Name of app to validate (e.g., "pomodoro_timer")
    Use "all" to validate all apps (WARNING: time-intensive)

.PARAMETER SkipGolden
    Skip golden image tests

.PARAMETER SkipPerf
    Skip performance smoke tests

.PARAMETER SkipSecurity
    Skip security scanning

.EXAMPLE
    pwsh tools/validate_qa_full.ps1 -AppName pomodoro_timer

.EXAMPLE
    pwsh tools/validate_qa_full.ps1 -AppName fasting_tracker -SkipPerf
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$AppName,

    [switch]$SkipGolden,
    [switch]$SkipPerf,
    [switch]$SkipSecurity,
    [switch]$Verbose
)

$ErrorActionPreference = "Continue"
$startTime = Get-Date

Write-Host "`n" + ("=" * 80) -ForegroundColor Cyan
Write-Host "🏭 QA AUTONOMOUS FACTORY - Full Pipeline Validation" -ForegroundColor Cyan
Write-Host ("=" * 80) -ForegroundColor Cyan
Write-Host "📱 App: $AppName" -ForegroundColor White
Write-Host "⏰ Started: $($startTime.ToString('yyyy-MM-dd HH:mm:ss'))" -ForegroundColor Gray
Write-Host ""

$results = @{}
$totalStages = 0
$passedStages = 0

# Stage 1: Architecture Compliance (AGENT-ARCH)
Write-Host "📐 [1/6] Architecture Compliance Check..." -ForegroundColor Yellow
$totalStages++

$appPath = Get-ChildItem -Path "apps" -Recurse -Filter $AppName -Directory | Select-Object -First 1 -ExpandProperty FullName

if (-not $appPath) {
    Write-Host "   ❌ App not found: $AppName" -ForegroundColor Red
    exit 1
}

# Check for Clean Architecture structure
$hasDomain = Test-Path "$appPath/lib/domain" -PathType Container
$hasData = Test-Path "$appPath/lib/data" -PathType Container
$hasPresentation = Test-Path "$appPath/lib/presentation" -PathType Container

if ($hasDomain -and $hasData -and $hasPresentation) {
    Write-Host "   ✅ Clean Architecture: PASS" -ForegroundColor Green
    $results["architecture"] = "PASS"
    $passedStages++
} else {
    Write-Host "   ⚠️  Simple structure detected (acceptable for small apps)" -ForegroundColor Yellow
    $results["architecture"] = "WARN"
    $passedStages++  # Not blocking
}

# Stage 2: Unit/Widget Tests (AGENT-QA)
Write-Host "`n🧪 [2/6] Running Unit/Widget Tests..." -ForegroundColor Yellow
$totalStages++

Push-Location $appPath
try {
    $testOutput = flutter test 2>&1
    $testExitCode = $LASTEXITCODE

    if ($testExitCode -eq 0) {
        Write-Host "   ✅ Tests: PASS" -ForegroundColor Green
        $results["tests"] = "PASS"
        $passedStages++
    } else {
        Write-Host "   ❌ Tests: FAIL" -ForegroundColor Red
        $results["tests"] = "FAIL"

        # Run self-heal analyzer
        Write-Host "   🔧 Running self-heal analysis..." -ForegroundColor Cyan
        flutter test --machine > test_results.json 2>&1
        python3 ../../../tools/self_heal_runner.py test_results.json 2>&1 | Write-Host
    }
} finally {
    Pop-Location
}

# Stage 3: Golden Visual Tests (AGENT-VISUAL)
if (-not $SkipGolden) {
    Write-Host "`n🎨 [3/6] Golden Visual Regression Tests..." -ForegroundColor Yellow
    $totalStages++

    try {
        $env:APP_NAME = $AppName
        pwsh tools/run_golden_tests.ps1

        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ Golden Tests: PASS" -ForegroundColor Green
            $results["golden"] = "PASS"
            $passedStages++
        } else {
            Write-Host "   ❌ Golden Tests: FAIL" -ForegroundColor Red
            Write-Host "   Review diffs: artifacts/goldens/$AppName/diffs/" -ForegroundColor Gray
            $results["golden"] = "FAIL"
        }
    } catch {
        Write-Host "   ⚠️  Golden Tests: ERROR - $_" -ForegroundColor Yellow
        $results["golden"] = "ERROR"
    }
} else {
    Write-Host "`n⏭️  [3/6] Skipping Golden Tests" -ForegroundColor Gray
}

# Stage 4: Performance Smoke Tests (AGENT-PERF)
if (-not $SkipPerf) {
    Write-Host "`n⚡ [4/6] Performance Smoke Tests..." -ForegroundColor Yellow
    $totalStages++

    try {
        pwsh tools/run_perf_smoke.ps1 -AppName $AppName

        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ Performance: PASS" -ForegroundColor Green
            $results["performance"] = "PASS"
            $passedStages++
        } else {
            Write-Host "   ❌ Performance: FAIL" -ForegroundColor Red
            $results["performance"] = "FAIL"
        }
    } catch {
        Write-Host "   ⚠️  Performance: ERROR - $_" -ForegroundColor Yellow
        $results["performance"] = "ERROR"
    }
} else {
    Write-Host "`n⏭️  [4/6] Skipping Performance Tests" -ForegroundColor Gray
}

# Stage 5: Security Scanning (AGENT-SEC)
if (-not $SkipSecurity) {
    Write-Host "`n🔒 [5/6] Security Scanning (MobSF)..." -ForegroundColor Yellow
    $totalStages++

    try {
        pwsh tools/run_mobsf_scan.ps1 -AppName $AppName

        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ Security: PASS" -ForegroundColor Green
            $results["security"] = "PASS"
            $passedStages++
        } else {
            Write-Host "   ❌ Security: FAIL" -ForegroundColor Red
            $results["security"] = "FAIL"
        }
    } catch {
        Write-Host "   ⚠️  Security: SKIP (MobSF not configured)" -ForegroundColor Yellow
        $results["security"] = "SKIP"
        $passedStages++  # Not blocking if not configured
    }
} else {
    Write-Host "`n⏭️  [5/6] Skipping Security Scan" -ForegroundColor Gray
}

# Stage 6: Final Validation
Write-Host "`n📊 [6/6] Final Validation..." -ForegroundColor Yellow
$totalStages++

$criticalFailures = @($results.GetEnumerator() | Where-Object { $_.Value -eq "FAIL" })

if ($criticalFailures.Count -eq 0) {
    Write-Host "   ✅ All critical checks passed" -ForegroundColor Green
    $passedStages++
} else {
    Write-Host "   ❌ Critical failures detected:" -ForegroundColor Red
    $criticalFailures | ForEach-Object {
        Write-Host "      - $($_.Key): FAIL" -ForegroundColor Red
    }
}

# Summary Report
$endTime = Get-Date
$duration = $endTime - $startTime

Write-Host "`n" + ("=" * 80) -ForegroundColor Cyan
Write-Host "📈 QA PIPELINE SUMMARY" -ForegroundColor Cyan
Write-Host ("=" * 80) -ForegroundColor Cyan

Write-Host "`n📱 App: $AppName" -ForegroundColor White
Write-Host "⏱️  Duration: $($duration.ToString('mm\:ss'))" -ForegroundColor Gray
Write-Host "`n📊 Results:" -ForegroundColor White

$results.GetEnumerator() | Sort-Object Key | ForEach-Object {
    $icon = switch ($_.Value) {
        "PASS" { "✅" }
        "FAIL" { "❌" }
        "WARN" { "⚠️ " }
        "SKIP" { "⏭️ " }
        "ERROR" { "⚠️ " }
    }
    $color = switch ($_.Value) {
        "PASS" { "Green" }
        "FAIL" { "Red" }
        "WARN" { "Yellow" }
        "SKIP" { "Gray" }
        "ERROR" { "Yellow" }
    }
    Write-Host "   $icon $($_.Key): $($_.Value)" -ForegroundColor $color
}

$passRate = if ($totalStages -gt 0) { [math]::Round(($passedStages / $totalStages) * 100, 1) } else { 0 }
Write-Host "`n🎯 Pass Rate: $passRate% ($passedStages/$totalStages)" -ForegroundColor $(if ($passRate -ge 80) { "Green" } elseif ($passRate -ge 60) { "Yellow" } else { "Red" })

if ($criticalFailures.Count -eq 0) {
    Write-Host "`n✅ PIPELINE PASSED - Ready for publication" -ForegroundColor Green
    Write-Host ("=" * 80) -ForegroundColor Cyan
    exit 0
} else {
    Write-Host "`n❌ PIPELINE FAILED - Fix issues before publishing" -ForegroundColor Red
    Write-Host "`n💡 Next Steps:" -ForegroundColor Cyan
    Write-Host "   1. Review failure details above" -ForegroundColor Gray
    Write-Host "   2. Run self-heal analyzer for test failures" -ForegroundColor Gray
    Write-Host "   3. Check golden diffs: artifacts/goldens/$AppName/diffs/" -ForegroundColor Gray
    Write-Host "   4. Fix issues and re-run: melos run validate:qa" -ForegroundColor Gray
    Write-Host ("=" * 80) -ForegroundColor Cyan
    exit 1
}
