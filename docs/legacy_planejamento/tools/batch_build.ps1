# Batch Build Script - Beast Mode 5.2
# Usage: pwsh tools/batch_build.ps1 -Apps "app1,app2,app3" -Category "productivity"

param(
    [Parameter(Mandatory=$false)]
    [string]$Apps,

    [Parameter(Mandatory=$false)]
    [string]$Category,

    [switch]$Parallel,
    [switch]$Release = $true,
    [int]$MaxConcurrent = 3,
    [switch]$CollectAabs
)

$ErrorActionPreference = "Continue"
$script:results = @()
$script:buildDir = "build_output_$(Get-Date -Format 'yyyyMMdd_HHmmss')"

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

function Invoke-FlutterBuild {
    param(
        [string]$AppName,
        [string]$Category
    )

    $appPath = if ($Category) { "apps/$Category/$AppName" } else { "apps/productivity/$AppName" }

    if (!(Test-Path $appPath)) {
        return @{
            App = $AppName
            Status = "NOT_FOUND"
            Duration = 0
            AabSize = 0
            Output = ""
        }
    }

    $startTime = Get-Date
    Write-Host "🏗️  Building: $AppName..." -ForegroundColor White

    # Run flutter build
    Push-Location $appPath

    $buildCommand = if ($Release) {
        "flutter build appbundle --release"
    } else {
        "flutter build appbundle"
    }

    $output = Invoke-Expression "$buildCommand 2>&1" | Out-String
    $exitCode = $LASTEXITCODE

    Pop-Location

    $duration = ((Get-Date) - $startTime).TotalSeconds

    # Check for AAB file
    $aabPath = "$appPath/build/app/outputs/bundle/release/app-release.aab"
    $aabExists = Test-Path $aabPath
    $aabSize = 0

    if ($aabExists) {
        $aabSize = [math]::Round((Get-Item $aabPath).Length / 1MB, 1)
    }

    $status = if ($exitCode -eq 0 -and $aabExists) {
        "✅ SUCCESS"
    } elseif ($exitCode -eq 0) {
        "⚠️  NO_AAB"
    } else {
        "❌ FAILED"
    }

    $statusColor = switch ($status) {
        "✅ SUCCESS" { "Green" }
        "⚠️  NO_AAB" { "Yellow" }
        "❌ FAILED" { "Red" }
        default { "Gray" }
    }

    Write-Host "  $status - $($aabSize)MB ($([math]::Round($duration, 1))s)" -ForegroundColor $statusColor

    # Copy AAB if requested
    if ($CollectAabs -and $aabExists) {
        if (!(Test-Path $script:buildDir)) {
            New-Item -ItemType Directory -Path $script:buildDir -Force | Out-Null
        }

        $destPath = "$($script:buildDir)/$AppName-release.aab"
        Copy-Item $aabPath $destPath -Force
    }

    return @{
        App = $AppName
        Category = $Category
        Status = $status
        Duration = $duration
        AabSize = $aabSize
        AabPath = if ($aabExists) { $aabPath } else { "" }
        AppPath = $appPath
        Output = $output
        ExitCode = $exitCode
    }
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

Write-Header "BATCH FLUTTER BUILD - BEAST MODE 5.2"

$appList = Get-AppList
$totalApps = $appList.Count
$currentCategory = if ($Category) { $Category } else { "productivity" }

Write-Host "📋 Apps to build: $totalApps" -ForegroundColor White
Write-Host "📁 Category: $currentCategory" -ForegroundColor White
Write-Host "⚡ Mode: $(if ($Parallel) { "Parallel ($MaxConcurrent concurrent)" } else { 'Sequential' })" -ForegroundColor White
Write-Host "🎯 Build type: $(if ($Release) { 'Release' } else { 'Debug' })" -ForegroundColor White

if ($CollectAabs) {
    Write-Host "📦 Collecting AABs to: $script:buildDir" -ForegroundColor White
}

Write-Host ""

$overallStartTime = Get-Date

# Build apps
if ($Parallel) {
    Write-Host "⚡ Starting parallel builds (max $MaxConcurrent concurrent)...`n" -ForegroundColor Cyan

    $script:results = $appList | ForEach-Object -Parallel {
        $app = $_
        $category = $using:currentCategory
        $releaseMode = $using:Release
        $buildDir = $using:buildDir
        $collect = $using:CollectAabs

        # Import function in parallel context
        $buildFunc = ${function:Invoke-FlutterBuild}.ToString()
        Invoke-Expression "function Invoke-FlutterBuild { $buildFunc }"

        Invoke-FlutterBuild -AppName $app -Category $category
    } -ThrottleLimit $MaxConcurrent
} else {
    # Sequential execution
    foreach ($app in $appList) {
        $result = Invoke-FlutterBuild -AppName $app -Category $currentCategory
        $script:results += [PSCustomObject]$result
    }
}

$overallDuration = ((Get-Date) - $overallStartTime).TotalSeconds

# =============================================================================
# SUMMARY
# =============================================================================

Write-Header "BUILD SUMMARY"

$successful = ($script:results | Where-Object { $_.Status -eq "✅ SUCCESS" }).Count
$failed = ($script:results | Where-Object { $_.Status -eq "❌ FAILED" }).Count
$noAab = ($script:results | Where-Object { $_.Status -eq "⚠️  NO_AAB" }).Count
$notFound = ($script:results | Where-Object { $_.Status -eq "NOT_FOUND" }).Count

$totalAabSize = ($script:results | Measure-Object -Property AabSize -Sum).Sum
$avgDuration = ($script:results | Where-Object { $_.Duration -gt 0 } | Measure-Object -Property Duration -Average).Average

Write-Host "✅ SUCCESSFUL: $successful/$totalApps ($([math]::Round($successful/$totalApps*100, 1))%)" -ForegroundColor Green
Write-Host "❌ FAILED:     $failed/$totalApps ($([math]::Round($failed/$totalApps*100, 1))%)" -ForegroundColor Red
Write-Host "⚠️  NO AAB:     $noAab/$totalApps" -ForegroundColor Yellow

if ($notFound -gt 0) {
    Write-Host "🔍 NOT FOUND:  $notFound/$totalApps" -ForegroundColor Gray
}

Write-Host ""
Write-Host "📦 Total AAB size: $([math]::Round($totalAabSize, 1))MB" -ForegroundColor White
Write-Host "⏱️  Average time:   $([math]::Round($avgDuration, 1))s per app" -ForegroundColor White
Write-Host "⏱️  Total duration: $([math]::Round($overallDuration/60, 1))min ($([math]::Round($overallDuration, 0))s)" -ForegroundColor White
Write-Host ""

# Detailed results table
Write-Header "DETAILED RESULTS"

$script:results | Sort-Object -Property Status | Format-Table -Property @{
    Label = "App"
    Expression = { $_.App }
    Width = 25
}, @{
    Label = "Status"
    Expression = { $_.Status }
    Width = 12
}, @{
    Label = "AAB Size"
    Expression = { if ($_.AabSize -gt 0) { "$($_.AabSize)MB" } else { "-" } }
    Width = 10
}, @{
    Label = "Duration"
    Expression = { "$([math]::Round($_.Duration, 1))s" }
    Width = 10
} -AutoSize

# Show failed builds
if ($failed -gt 0) {
    Write-Header "FAILED BUILDS ($failed)"

    $failedBuilds = $script:results | Where-Object { $_.Status -eq "❌ FAILED" }

    foreach ($build in $failedBuilds) {
        Write-Host "`n❌ $($build.App)" -ForegroundColor Red

        # Extract error lines
        $errorLines = $build.Output -split "`n" | Where-Object {
            $_ -match "error|Error|ERROR|FAILURE|Exception"
        } | Select-Object -First 5

        foreach ($line in $errorLines) {
            Write-Host "  $line" -ForegroundColor Gray
        }
    }
}

# Performance stats
Write-Header "PERFORMANCE STATS"

$fastest = ($script:results | Where-Object { $_.Duration -gt 0 } | Sort-Object Duration | Select-Object -First 1)
$slowest = ($script:results | Where-Object { $_.Duration -gt 0 } | Sort-Object Duration -Descending | Select-Object -First 1)

if ($fastest) {
    Write-Host "⚡ Fastest build: $($fastest.App) - $([math]::Round($fastest.Duration, 1))s" -ForegroundColor Green
}

if ($slowest) {
    Write-Host "🐌 Slowest build: $($slowest.App) - $([math]::Round($slowest.Duration, 1))s" -ForegroundColor Yellow
}

if ($Parallel -and $successful -gt 1) {
    $estimatedSequential = $avgDuration * $successful
    $speedup = $estimatedSequential / $overallDuration
    Write-Host "🚀 Parallel speedup: $([math]::Round($speedup, 1))x faster than sequential" -ForegroundColor Cyan
}

Write-Host ""

# AAB collection info
if ($CollectAabs -and $successful -gt 0) {
    Write-Header "AAB FILES COLLECTED"

    $aabFiles = Get-ChildItem $script:buildDir -Filter "*.aab" -File

    Write-Host "📦 Location: $script:buildDir" -ForegroundColor White
    Write-Host "📊 Files: $($aabFiles.Count)" -ForegroundColor White
    Write-Host ""

    $aabFiles | ForEach-Object {
        $sizeMB = [math]::Round($_.Length / 1MB, 1)
        Write-Host "  ✅ $($_.Name) - $($sizeMB)MB" -ForegroundColor Green
    }

    Write-Host ""
}

# Recommendations
Write-Header "RECOMMENDATIONS"

if ($successful -eq $totalApps) {
    Write-Host "🎉 All builds successful! Ready for publication." -ForegroundColor Green
} elseif ($failed -gt 0) {
    Write-Host "❌ Fix build errors in $failed app(s)" -ForegroundColor Red
    Write-Host "   Review error messages above" -ForegroundColor Gray
}

$successRate = [math]::Round(($successful / $totalApps) * 100, 1)
Write-Host ""
Write-Host "📊 Success Rate: $successRate% ($successful/$totalApps)" -ForegroundColor White

if ($successRate -eq 100) {
    Write-Host "✅ Perfect! All apps built successfully." -ForegroundColor Green
} elseif ($successRate -ge 80) {
    Write-Host "✅ Good! Most apps built successfully." -ForegroundColor Green
} elseif ($successRate -ge 50) {
    Write-Host "⚠️  Moderate. Address failing builds." -ForegroundColor Yellow
} else {
    Write-Host "❌ Low success rate. Major build issues." -ForegroundColor Red
}

Write-Host ""

# Next steps
if ($successful -gt 0) {
    Write-Header "NEXT STEPS"
    Write-Host "1. Test AAB files on device/emulator" -ForegroundColor White
    Write-Host "2. Upload to Play Console Internal Testing" -ForegroundColor White
    Write-Host "3. Generate screenshots with Patrol" -ForegroundColor White
    Write-Host "4. Create/verify Privacy Policy URLs" -ForegroundColor White
    Write-Host ""
}

# Exit code
if ($failed -gt 0) {
    exit 1
} else {
    exit 0
}
