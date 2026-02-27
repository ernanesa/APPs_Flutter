#!/usr/bin/env pwsh
<#
.SYNOPSIS
    QA Factory Environment Validator

.DESCRIPTION
    Validates that all QA autonomous factory components are properly installed
    and configured. Checks tools, dependencies, and provides setup guidance.
#>

$ErrorActionPreference = "Continue"

Write-Host "`n" + ("=" * 80) -ForegroundColor Cyan
Write-Host "🏭 QA AUTONOMOUS FACTORY - Environment Validation" -ForegroundColor Cyan
Write-Host ("=" * 80) -ForegroundColor Cyan

$checks = @{}
$criticalFailures = 0

# Check 1: Flutter SDK
Write-Host "`n📱 [1/12] Flutter SDK..." -ForegroundColor Yellow
try {
    $flutterVersion = flutter --version 2>&1 | Select-String "Flutter" | Select-Object -First 1
    Write-Host "   ✅ $flutterVersion" -ForegroundColor Green
    $checks["flutter"] = "PASS"
} catch {
    Write-Host "   ❌ Flutter not found in PATH" -ForegroundColor Red
    Write-Host "      Install: https://docs.flutter.dev/get-started/install" -ForegroundColor Gray
    $checks["flutter"] = "FAIL"
    $criticalFailures++
}

# Check 2: Dart SDK
Write-Host "`n🎯 [2/12] Dart SDK..." -ForegroundColor Yellow
try {
    $dartVersion = dart --version 2>&1
    Write-Host "   ✅ Dart installed" -ForegroundColor Green
    $checks["dart"] = "PASS"
} catch {
    Write-Host "   ❌ Dart not found" -ForegroundColor Red
    $checks["dart"] = "FAIL"
    $criticalFailures++
}

# Check 3: Melos
Write-Host "`n📦 [3/12] Melos..." -ForegroundColor Yellow
try {
    $melosVersion = melos --version 2>&1
    Write-Host "   ✅ Melos $melosVersion" -ForegroundColor Green
    $checks["melos"] = "PASS"
} catch {
    Write-Host "   ⚠️  Melos not found" -ForegroundColor Yellow
    Write-Host "      Install: dart pub global activate melos" -ForegroundColor Gray
    $checks["melos"] = "WARN"
}

# Check 4: Python 3
Write-Host "`n🐍 [4/12] Python 3..." -ForegroundColor Yellow
try {
    $pythonVersion = python3 --version 2>&1
    Write-Host "   ✅ $pythonVersion" -ForegroundColor Green
    $checks["python"] = "PASS"
} catch {
    Write-Host "   ❌ Python 3 not found" -ForegroundColor Red
    Write-Host "      Install: https://www.python.org/downloads/" -ForegroundColor Gray
    $checks["python"] = "FAIL"
    $criticalFailures++
}

# Check 5: Python venv
Write-Host "`n🔧 [5/12] Python Virtual Environment..." -ForegroundColor Yellow
if (Test-Path ".venv") {
    Write-Host "   ✅ Virtual environment exists (.venv/)" -ForegroundColor Green
    $checks["venv"] = "PASS"
} else {
    Write-Host "   ⚠️  Virtual environment not found" -ForegroundColor Yellow
    Write-Host "      Create: python3 -m venv .venv" -ForegroundColor Gray
    Write-Host "      Activate: source .venv/bin/activate (Linux/Mac)" -ForegroundColor Gray
    Write-Host "                .venv\\Scripts\\activate (Windows)" -ForegroundColor Gray
    $checks["venv"] = "WARN"
}

# Check 6: QA Tools
Write-Host "`n🛠️  [6/12] QA Automation Tools..." -ForegroundColor Yellow
$toolsExist = @(
    "tools/golden_compare_simple.py",
    "tools/run_golden_tests.ps1",
    "tools/generate_goldens_for_app.ps1",
    "tools/run_perf_smoke.ps1",
    "tools/run_mobsf_scan.ps1",
    "tools/self_heal_runner.py",
    "tools/validate_qa_full.ps1"
)

$missingTools = $toolsExist | Where-Object { -not (Test-Path $_) }

if ($missingTools.Count -eq 0) {
    Write-Host "   ✅ All 7 QA tools found" -ForegroundColor Green
    $checks["tools"] = "PASS"
} else {
    Write-Host "   ❌ Missing tools:" -ForegroundColor Red
    $missingTools | ForEach-Object { Write-Host "      - $_" -ForegroundColor Red }
    $checks["tools"] = "FAIL"
    $criticalFailures++
}

# Check 7: Agent Specs
Write-Host "`n🤖 [7/12] Agent Specifications..." -ForegroundColor Yellow
$agentSpecs = Get-ChildItem -Path ".github/agents" -Filter "*.agent.md" -File -ErrorAction SilentlyContinue

if ($agentSpecs.Count -ge 5) {
    Write-Host "   ✅ $($agentSpecs.Count) agent(s) found" -ForegroundColor Green
    $checks["agents"] = "PASS"
} else {
    Write-Host "   ⚠️  Only $($agentSpecs.Count) agent(s) found (expected 5)" -ForegroundColor Yellow
    $checks["agents"] = "WARN"
}

# Check 8: Documentation
Write-Host "`n📚 [8/12] Documentation..." -ForegroundColor Yellow
$docs = @(
    "docs/README.md",
    "docs/PLAYBOOK.md",
    "docs/QA.md",
    "docs/MASTER_TEST_PLAN.md",
    "docs/PUBLISHING.md",
    "docs/KNOWLEDGE_BASE.md"
)

$missingDocs = $docs | Where-Object { -not (Test-Path $_) }

if ($missingDocs.Count -eq 0) {
    Write-Host "   ✅ All key docs present" -ForegroundColor Green
    $checks["docs"] = "PASS"
} else {
    Write-Host "   ⚠️  Missing docs:" -ForegroundColor Yellow
    $missingDocs | ForEach-Object { Write-Host "      - $_" -ForegroundColor Gray }
    $checks["docs"] = "WARN"
}

# Check 9: Git LFS
Write-Host "`n📦 [9/12] Git LFS..." -ForegroundColor Yellow
try {
    $lfsVersion = git lfs version 2>&1
    Write-Host "   ✅ Git LFS installed" -ForegroundColor Green
    $checks["git-lfs"] = "PASS"
} catch {
    Write-Host "   ⚠️  Git LFS not found" -ForegroundColor Yellow
    Write-Host "      Install: https://git-lfs.github.com/" -ForegroundColor Gray
    Write-Host "      Initialize: git lfs install" -ForegroundColor Gray
    $checks["git-lfs"] = "WARN"
}

# Check 10: Artifacts Directory
Write-Host "`n📁 [10/12] Artifacts Directory..." -ForegroundColor Yellow
if (Test-Path "artifacts/goldens") {
    $apps = Get-ChildItem -Path "artifacts/goldens" -Directory -ErrorAction SilentlyContinue
    Write-Host "   ✅ Goldens directory exists ($($apps.Count) apps)" -ForegroundColor Green
    $checks["artifacts"] = "PASS"
} else {
    Write-Host "   ⚠️  Goldens directory not found" -ForegroundColor Yellow
    Write-Host "      Create: mkdir -p artifacts/goldens" -ForegroundColor Gray
    $checks["artifacts"] = "WARN"
}

# Check 11: Integration Tests
Write-Host "`n🧪 [11/12] Integration Tests..." -ForegroundColor Yellow
$integrationTests = Get-ChildItem -Path "apps" -Recurse -Filter "screenshot_test.dart" -File -ErrorAction SilentlyContinue

if ($integrationTests.Count -gt 0) {
    Write-Host "   ✅ $($integrationTests.Count) integration tests found" -ForegroundColor Green
    $checks["integration-tests"] = "PASS"
} else {
    Write-Host "   ⚠️  No integration tests found" -ForegroundColor Yellow
    Write-Host "      Create integration_test/screenshot_test.dart in apps" -ForegroundColor Gray
    $checks["integration-tests"] = "WARN"
}

# Check 12: CI Workflow
Write-Host "`n⚙️  [12/12] CI/CD Workflow..." -ForegroundColor Yellow
if (Test-Path ".github/workflows/qa-pipeline.yml") {
    Write-Host "   ✅ QA pipeline workflow configured" -ForegroundColor Green
    $checks["ci"] = "PASS"
} else {
    Write-Host "   ⚠️  CI workflow not found" -ForegroundColor Yellow
    $checks["ci"] = "WARN"
}

# Summary
Write-Host "`n" + ("=" * 80) -ForegroundColor Cyan
Write-Host "📊 VALIDATION SUMMARY" -ForegroundColor Cyan
Write-Host ("=" * 80) -ForegroundColor Cyan

$passed = ($checks.Values | Where-Object { $_ -eq "PASS" }).Count
$warned = ($checks.Values | Where-Object { $_ -eq "WARN" }).Count
$failed = ($checks.Values | Where-Object { $_ -eq "FAIL" }).Count

Write-Host "`n✅ Passed: $passed" -ForegroundColor Green
Write-Host "⚠️  Warnings: $warned" -ForegroundColor Yellow
Write-Host "❌ Failed: $failed" -ForegroundColor Red

Write-Host "`n📋 Detailed Results:" -ForegroundColor White
$checks.GetEnumerator() | Sort-Object Key | ForEach-Object {
    $icon = switch ($_.Value) {
        "PASS" { "✅" }
        "WARN" { "⚠️ " }
        "FAIL" { "❌" }
    }
    $color = switch ($_.Value) {
        "PASS" { "Green" }
        "WARN" { "Yellow" }
        "FAIL" { "Red" }
    }
    Write-Host "   $icon $($_.Key): $($_.Value)" -ForegroundColor $color
}

if ($criticalFailures -eq 0 -and $failed -eq 0) {
    Write-Host "`n✅ ENVIRONMENT READY - All critical components available" -ForegroundColor Green
    Write-Host "`n🚀 Next Steps:" -ForegroundColor Cyan
    Write-Host "   1. Bootstrap packages: melos bootstrap" -ForegroundColor Gray
    Write-Host "   2. Run QA validation: melos run validate:qa:full -- -AppName <app>" -ForegroundColor Gray
    Write-Host "   3. Read docs index: docs/README.md" -ForegroundColor Gray
    Write-Host ("=" * 80) -ForegroundColor Cyan
    exit 0
} elseif ($criticalFailures -gt 0) {
    Write-Host "`n❌ CRITICAL FAILURES DETECTED" -ForegroundColor Red
    Write-Host "   Fix critical issues (Flutter, Dart, Python, Tools) before proceeding" -ForegroundColor Red
    Write-Host ("=" * 80) -ForegroundColor Cyan
    exit 1
} else {
    Write-Host "`n⚠️  ENVIRONMENT PARTIALLY READY" -ForegroundColor Yellow
    Write-Host "   Some optional features not available (see warnings above)" -ForegroundColor Yellow
    Write-Host "   Core functionality should work" -ForegroundColor Yellow
    Write-Host ("=" * 80) -ForegroundColor Cyan
    exit 0
}
