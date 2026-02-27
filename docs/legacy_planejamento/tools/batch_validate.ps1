# Batch Validation Script - Beast Mode 5.2
# Usage: pwsh tools/batch_validate.ps1 -Apps "app1,app2,app3" -Category "productivity"

param(
    [Parameter(Mandatory=$false)]
    [string]$Apps,

    [Parameter(Mandatory=$false)]
    [string]$Category,

    [switch]$AutoFix,
    [switch]$ExportCsv
)

$ErrorActionPreference = "Continue"
$script:results = @()

function Write-Header {
    param([string]$Text)
    Write-Host "`n$('=' * 80)" -ForegroundColor Cyan
    Write-Host "  $Text" -ForegroundColor Cyan
    Write-Host "$('=' * 80)`n" -ForegroundColor Cyan
}

function Get-AppList {
    if ($Apps) {
        return $Apps -split ','
    }

    if ($Category) {
        $categoryPath = "apps/$Category"
        if (!(Test-Path $categoryPath)) {
            Write-Host "❌ Category path not found: $categoryPath" -ForegroundColor Red
            exit 1
        }

        $appDirs = Get-ChildItem $categoryPath -Directory
        return $appDirs | ForEach-Object { $_.Name }
    }

    Write-Host "❌ Must specify either -Apps or -Category" -ForegroundColor Red
    exit 1
}

function Invoke-AppValidation {
    param(
        [string]$AppName,
        [string]$Category
    )

    $appPath = if ($Category) { "apps/$Category/$AppName" } else { "apps/productivity/$AppName" }

    if (!(Test-Path $appPath)) {
        return @{
            App = $AppName
            Status = "NOT_FOUND"
            Errors = 0
            Warnings = 0
            Duration = 0
        }
    }

    $startTime = Get-Date

    Write-Host "🔍 Validating: $AppName..." -ForegroundColor White

    # Run pre_build_check.ps1
    $output = & pwsh -NoProfile tools/pre_build_check.ps1 -AppPath $appPath 2>&1
    $exitCode = $LASTEXITCODE

    $errors = 0
    $warnings = 0

    # Parse output
    if ($output -match "ERRORS \((\d+)\)") {
        $errors = [int]$Matches[1]
    }
    if ($output -match "WARNINGS \((\d+)\)") {
        $warnings = [int]$Matches[1]
    }

    $duration = ((Get-Date) - $startTime).TotalSeconds

    $status = if ($exitCode -eq 0 -and $errors -eq 0) {
        "✅ PASS"
    } elseif ($errors -gt 0) {
        "❌ FAIL"
    } else {
        "⚠️  WARN"
    }

    Write-Host "  $status - Errors: $errors, Warnings: $warnings ($([math]::Round($duration, 1))s)" -ForegroundColor $(
        if ($status -eq "✅ PASS") { "Green" }
        elseif ($status -eq "❌ FAIL") { "Red" }
        else { "Yellow" }
    )

    return @{
        App = $AppName
        Category = $Category
        Status = $status
        Errors = $errors
        Warnings = $warnings
        Duration = $duration
        AppPath = $appPath
        Output = $output -join "`n"
    }
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

Write-Header "BATCH APP VALIDATION - BEAST MODE 5.2"

$appList = Get-AppList
$totalApps = $appList.Count

Write-Host "📋 Apps to validate: $totalApps" -ForegroundColor White
Write-Host "📁 Category: $(if ($Category) { $Category } else { 'productivity (default)' })" -ForegroundColor White
Write-Host ""

$currentCategory = if ($Category) { $Category } else { "productivity" }

# Validate each app
foreach ($app in $appList) {
    $result = Invoke-AppValidation -AppName $app -Category $currentCategory
    $script:results += [PSCustomObject]$result
}

# =============================================================================
# SUMMARY
# =============================================================================

Write-Header "VALIDATION SUMMARY"

$passed = ($script:results | Where-Object { $_.Status -eq "✅ PASS" }).Count
$failed = ($script:results | Where-Object { $_.Status -eq "❌ FAIL" }).Count
$warned = ($script:results | Where-Object { $_.Status -eq "⚠️  WARN" }).Count
$notFound = ($script:results | Where-Object { $_.Status -eq "NOT_FOUND" }).Count

$totalErrors = ($script:results | Measure-Object -Property Errors -Sum).Sum
$totalWarnings = ($script:results | Measure-Object -Property Warnings -Sum).Sum
$totalDuration = ($script:results | Measure-Object -Property Duration -Sum).Sum

Write-Host "✅ PASSED:    $passed/$totalApps ($([math]::Round($passed/$totalApps*100, 1))%)" -ForegroundColor Green
Write-Host "❌ FAILED:    $failed/$totalApps ($([math]::Round($failed/$totalApps*100, 1))%)" -ForegroundColor Red
Write-Host "⚠️  WARNINGS:  $warned/$totalApps ($([math]::Round($warned/$totalApps*100, 1))%)" -ForegroundColor Yellow

if ($notFound -gt 0) {
    Write-Host "🔍 NOT FOUND: $notFound/$totalApps" -ForegroundColor Gray
}

Write-Host ""
Write-Host "📊 Total Errors:   $totalErrors" -ForegroundColor $(if ($totalErrors -eq 0) { "Green" } else { "Red" })
Write-Host "📊 Total Warnings: $totalWarnings" -ForegroundColor Yellow
Write-Host "⏱️  Total Duration: $([math]::Round($totalDuration, 1))s" -ForegroundColor White
Write-Host ""

# Detailed results
Write-Header "DETAILED RESULTS"

$script:results | Format-Table -Property App, Status, Errors, Warnings, @{
    Label = "Duration"
    Expression = { "$([math]::Round($_.Duration, 1))s" }
} -AutoSize

# Export CSV if requested
if ($ExportCsv) {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $csvPath = "validation_results_$timestamp.csv"
    $script:results | Export-Csv -Path $csvPath -NoTypeInformation
    Write-Host "✅ Results exported to: $csvPath" -ForegroundColor Green
}

# Apps that need attention
$needsAttention = $script:results | Where-Object { $_.Status -ne "✅ PASS" -and $_.Status -ne "NOT_FOUND" }

if ($needsAttention.Count -gt 0) {
    Write-Header "APPS NEEDING ATTENTION ($($needsAttention.Count))"

    foreach ($app in $needsAttention) {
        Write-Host "`n$($app.Status) $($app.App)" -ForegroundColor $(
            if ($app.Status -eq "❌ FAIL") { "Red" } else { "Yellow" }
        )

        # Show first few lines of output with errors/warnings
        $outputLines = $app.Output -split "`n"
        $errorLines = $outputLines | Where-Object { $_ -match "❌|⚠️" } | Select-Object -First 5

        foreach ($line in $errorLines) {
            Write-Host "  $line" -ForegroundColor Gray
        }
    }
}

# Recommendations
Write-Header "RECOMMENDATIONS"

if ($failed -gt 0) {
    Write-Host "❌ Fix errors in $failed app(s) before proceeding" -ForegroundColor Red
    Write-Host "   Run: pwsh tools/pre_build_check.ps1 -AppPath apps/<category>/<app> -DetailedOutput" -ForegroundColor Gray
}

if ($warned -gt 0) {
    Write-Host "⚠️  Review warnings in $warned app(s)" -ForegroundColor Yellow
}

if ($passed -eq $totalApps) {
    Write-Host "🎉 All apps passed validation! Ready to proceed with implementation." -ForegroundColor Green
} else {
    $successRate = [math]::Round($passed/$totalApps*100, 1)
    Write-Host "📊 Success Rate: $successRate% ($passed/$totalApps)" -ForegroundColor White

    if ($successRate -ge 80) {
        Write-Host "✅ Good success rate. Proceed with caution." -ForegroundColor Green
    } elseif ($successRate -ge 50) {
        Write-Host "⚠️  Moderate success rate. Fix critical issues first." -ForegroundColor Yellow
    } else {
        Write-Host "❌ Low success rate. Address issues before continuing." -ForegroundColor Red
    }
}

Write-Host ""

# Exit code
if ($failed -gt 0) {
    exit 1
} else {
    exit 0
}
