# Batch Analyze Script - Beast Mode 5.2
# Usage: pwsh tools/batch_analyze.ps1 -Apps "app1,app2,app3" -Category "productivity"

param(
    [Parameter(Mandatory=$false)]
    [string]$Apps,

    [Parameter(Mandatory=$false)]
    [string]$Category,

    [switch]$Parallel,
    [switch]$ExportJson
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

function Invoke-FlutterAnalyze {
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
            Infos = 0
            Duration = 0
            Output = ""
        }
    }

    $startTime = Get-Date
    Write-Host "🔍 Analyzing: $AppName..." -ForegroundColor White

    # Run flutter analyze
    Push-Location $appPath
    $output = flutter analyze --no-fatal-infos 2>&1 | Out-String
    $exitCode = $LASTEXITCODE
    Pop-Location

    $duration = ((Get-Date) - $startTime).TotalSeconds

    # Parse output
    $errors = 0
    $warnings = 0
    $infos = 0

    # Count errors
    if ($output -match "(\d+)\s+error") {
        $errors = [int]$Matches[1]
    }

    # Count warnings
    if ($output -match "(\d+)\s+warning") {
        $warnings = [int]$Matches[1]
    }

    # Count infos
    if ($output -match "(\d+)\s+info") {
        $infos = [int]$Matches[1]
    }

    # Check for "No issues found"
    $noIssues = $output -match "No issues found"

    $status = if ($noIssues -or ($errors -eq 0 -and $warnings -eq 0)) {
        "✅ CLEAN"
    } elseif ($errors -gt 0) {
        "❌ ERRORS"
    } elseif ($warnings -gt 0) {
        "⚠️  WARNINGS"
    } else {
        "ℹ️  INFOS"
    }

    $statusColor = switch ($status) {
        "✅ CLEAN" { "Green" }
        "❌ ERRORS" { "Red" }
        "⚠️  WARNINGS" { "Yellow" }
        default { "Cyan" }
    }

    Write-Host "  $status - E:$errors W:$warnings I:$infos ($([math]::Round($duration, 1))s)" -ForegroundColor $statusColor

    return @{
        App = $AppName
        Category = $Category
        Status = $status
        Errors = $errors
        Warnings = $warnings
        Infos = $infos
        Duration = $duration
        AppPath = $appPath
        Output = $output
        ExitCode = $exitCode
    }
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

Write-Header "BATCH FLUTTER ANALYZE - BEAST MODE 5.2"

$appList = Get-AppList
$totalApps = $appList.Count
$currentCategory = if ($Category) { $Category } else { "productivity" }

Write-Host "📋 Apps to analyze: $totalApps" -ForegroundColor White
Write-Host "📁 Category: $currentCategory" -ForegroundColor White
Write-Host "⚡ Mode: $(if ($Parallel) { 'Parallel (faster)' } else { 'Sequential' })" -ForegroundColor White
Write-Host ""

$overallStartTime = Get-Date

# Analyze apps
if ($Parallel) {
    # Parallel execution
    $script:results = $appList | ForEach-Object -Parallel {
        $app = $_
        $category = $using:currentCategory

        # Import function in parallel context
        $analyzeFunc = ${function:Invoke-FlutterAnalyze}.ToString()
        Invoke-Expression "function Invoke-FlutterAnalyze { $analyzeFunc }"

        Invoke-FlutterAnalyze -AppName $app -Category $category
    } -ThrottleLimit 5
} else {
    # Sequential execution
    foreach ($app in $appList) {
        $result = Invoke-FlutterAnalyze -AppName $app -Category $currentCategory
        $script:results += [PSCustomObject]$result
    }
}

$overallDuration = ((Get-Date) - $overallStartTime).TotalSeconds

# =============================================================================
# SUMMARY
# =============================================================================

Write-Header "ANALYSIS SUMMARY"

$clean = ($script:results | Where-Object { $_.Status -eq "✅ CLEAN" }).Count
$withErrors = ($script:results | Where-Object { $_.Status -eq "❌ ERRORS" }).Count
$withWarnings = ($script:results | Where-Object { $_.Status -eq "⚠️  WARNINGS" }).Count
$withInfos = ($script:results | Where-Object { $_.Status -eq "ℹ️  INFOS" }).Count
$notFound = ($script:results | Where-Object { $_.Status -eq "NOT_FOUND" }).Count

$totalErrors = ($script:results | Measure-Object -Property Errors -Sum).Sum
$totalWarnings = ($script:results | Measure-Object -Property Warnings -Sum).Sum
$totalInfos = ($script:results | Measure-Object -Property Infos -Sum).Sum

Write-Host "✅ CLEAN:        $clean/$totalApps ($([math]::Round($clean/$totalApps*100, 1))%)" -ForegroundColor Green
Write-Host "❌ WITH ERRORS:  $withErrors/$totalApps ($([math]::Round($withErrors/$totalApps*100, 1))%)" -ForegroundColor Red
Write-Host "⚠️  WITH WARNINGS: $withWarnings/$totalApps ($([math]::Round($withWarnings/$totalApps*100, 1))%)" -ForegroundColor Yellow
Write-Host "ℹ️  WITH INFOS:   $withInfos/$totalApps ($([math]::Round($withInfos/$totalApps*100, 1))%)" -ForegroundColor Cyan

if ($notFound -gt 0) {
    Write-Host "🔍 NOT FOUND:    $notFound/$totalApps" -ForegroundColor Gray
}

Write-Host ""
Write-Host "📊 Total Errors:   $totalErrors" -ForegroundColor $(if ($totalErrors -eq 0) { "Green" } else { "Red" })
Write-Host "📊 Total Warnings: $totalWarnings" -ForegroundColor Yellow
Write-Host "📊 Total Infos:    $totalInfos" -ForegroundColor Cyan
Write-Host "⏱️  Total Duration: $([math]::Round($overallDuration, 1))s" -ForegroundColor White
Write-Host ""

# Detailed results table
Write-Header "DETAILED RESULTS"

$script:results | Sort-Object -Property Errors -Descending | Format-Table -Property @{
    Label = "App"
    Expression = { $_.App }
    Width = 25
}, @{
    Label = "Status"
    Expression = { $_.Status }
    Width = 12
}, @{
    Label = "Errors"
    Expression = { $_.Errors }
    Width = 8
}, @{
    Label = "Warnings"
    Expression = { $_.Warnings }
    Width = 10
}, @{
    Label = "Infos"
    Expression = { $_.Infos }
    Width = 8
}, @{
    Label = "Duration"
    Expression = { "$([math]::Round($_.Duration, 1))s" }
    Width = 10
} -AutoSize

# Export JSON if requested
if ($ExportJson) {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $jsonPath = "analysis_results_$timestamp.json"
    $script:results | ConvertTo-Json -Depth 10 | Out-File $jsonPath
    Write-Host "✅ Results exported to: $jsonPath" -ForegroundColor Green
    Write-Host ""
}

# Show apps with errors
if ($withErrors -gt 0) {
    Write-Header "APPS WITH ERRORS ($withErrors)"

    $appsWithErrors = $script:results | Where-Object { $_.Errors -gt 0 } | Sort-Object -Property Errors -Descending

    foreach ($app in $appsWithErrors) {
        Write-Host "`n❌ $($app.App) - $($app.Errors) error(s)" -ForegroundColor Red

        # Extract error lines from output
        $errorLines = $app.Output -split "`n" | Where-Object { $_ -match "error\s+-" } | Select-Object -First 5

        foreach ($line in $errorLines) {
            Write-Host "  $line" -ForegroundColor Gray
        }

        if ($app.Errors -gt 5) {
            Write-Host "  ... and $($app.Errors - 5) more error(s)" -ForegroundColor Gray
        }
    }
}

# Performance stats
Write-Header "PERFORMANCE STATS"

$avgDuration = ($script:results | Measure-Object -Property Duration -Average).Average
$maxDuration = ($script:results | Measure-Object -Property Duration -Maximum).Maximum
$minDuration = ($script:results | Measure-Object -Property Duration -Minimum).Minimum

Write-Host "Average time per app: $([math]::Round($avgDuration, 2))s" -ForegroundColor White
Write-Host "Fastest app:          $([math]::Round($minDuration, 2))s" -ForegroundColor Green
Write-Host "Slowest app:          $([math]::Round($maxDuration, 2))s" -ForegroundColor Yellow

if ($Parallel) {
    $estimatedSequential = $avgDuration * $totalApps
    $speedup = $estimatedSequential / $overallDuration
    Write-Host "Parallel speedup:     $([math]::Round($speedup, 1))x faster" -ForegroundColor Cyan
}

Write-Host ""

# Recommendations
Write-Header "RECOMMENDATIONS"

if ($withErrors -eq 0 -and $withWarnings -eq 0) {
    Write-Host "🎉 All apps are clean! Ready to build." -ForegroundColor Green
} elseif ($withErrors -gt 0) {
    Write-Host "❌ Fix errors in $withErrors app(s) before building" -ForegroundColor Red
    Write-Host "   Focus on apps with most errors first" -ForegroundColor Gray
} elseif ($withWarnings -gt 0) {
    Write-Host "⚠️  Review warnings in $withWarnings app(s)" -ForegroundColor Yellow
    Write-Host "   Warnings won't block builds but should be addressed" -ForegroundColor Gray
}

$successRate = [math]::Round(($clean / $totalApps) * 100, 1)
Write-Host ""
Write-Host "📊 Clean Rate: $successRate% ($clean/$totalApps)" -ForegroundColor White

if ($successRate -eq 100) {
    Write-Host "✅ Perfect! All apps passed analysis." -ForegroundColor Green
} elseif ($successRate -ge 80) {
    Write-Host "✅ Good! Most apps are clean." -ForegroundColor Green
} elseif ($successRate -ge 50) {
    Write-Host "⚠️  Moderate. Address issues in failing apps." -ForegroundColor Yellow
} else {
    Write-Host "❌ Low success rate. Major issues detected." -ForegroundColor Red
}

Write-Host ""

# Exit code
if ($withErrors -gt 0) {
    exit 1
} else {
    exit 0
}
