# QUICK PARALLEL ANALYZE - Super Fast Analysis Only
# Executes flutter analyze on all apps in parallel - NO tests, NO builds

param(
    [int]$MaxJobs = 20,
    [string]$Category = "all",
    [switch]$FixCommon
)

$ErrorActionPreference = "Continue"
$ProgressPreference = "SilentlyContinue"

# ANSI Colors
$GREEN = "`e[32m"
$RED = "`e[31m"
$YELLOW = "`e[33m"
$BLUE = "`e[34m"
$CYAN = "`e[36m"
$MAGENTA = "`e[35m"
$RESET = "`e[0m"
$BOLD = "`e[1m"

Write-Host "${BOLD}${CYAN}⚡ QUICK PARALLEL ANALYZE - MAXIMUM SPEED${RESET}"
Write-Host ""

$startTime = Get-Date

# Descobrir apps
$appsRoot = "C:\Users\Ernane\Personal\APPs_Flutter_2\apps"
$allApps = @()

if ($Category -eq "all") {
    $categories = @("finance", "health", "media", "niche", "productivity", "tools", "utility")
} else {
    $categories = @($Category)
}

foreach ($cat in $categories) {
    $catPath = Join-Path $appsRoot $cat
    if (Test-Path $catPath) {
        $apps = Get-ChildItem -Path $catPath -Directory
        foreach ($app in $apps) {
            $pubspecPath = Join-Path $app.FullName "pubspec.yaml"
            if (Test-Path $pubspecPath) {
                $allApps += @{
                    Name = $app.Name
                    Category = $cat
                    Path = $app.FullName
                }
            }
        }
    }
}

Write-Host "${BLUE}📦 Apps to analyze: $($allApps.Count)${RESET}"
Write-Host "${BLUE}⚡ Parallel jobs: $MaxJobs${RESET}"
Write-Host ""

$scriptBlock = {
    param($appPath, $appName, $category)

    $result = @{
        App = $appName
        Category = $category
        Errors = 0
        Warnings = 0
        Issues = @()
        Success = $false
        Duration = 0
    }

    $start = Get-Date

    try {
        Push-Location $appPath

        # Pub get silencioso
        flutter pub get --suppress-analytics 2>&1 | Out-Null

        # Analyze
        $output = flutter analyze --no-pub 2>&1 | Out-String

        # Parse results
        if ($output -match 'No issues found!') {
            $result.Success = $true
        }

        if ($output -match '(\d+) error') {
            $result.Errors = [int]$matches[1]
        }

        if ($output -match '(\d+) warning') {
            $result.Warnings = [int]$matches[1]
        }

        if ($output -match '(\d+) hint') {
            # Ignoring hints
        }

        # Extract issues
        $lines = $output -split "`n"
        foreach ($line in $lines) {
            if ($line -match '^\s+(error|warning|info)\s+•\s+(.+?)\s+•\s+(.+?)\s+•\s+(.+)$') {
                $result.Issues += @{
                    Type = $matches[1]
                    Message = $matches[2]
                    File = $matches[3]
                    Code = $matches[4]
                }
            }
        }

        $result.Success = ($result.Errors -eq 0)

    } catch {
        $result.Success = $false
    } finally {
        Pop-Location
        $result.Duration = ((Get-Date) - $start).TotalSeconds
    }

    return $result
}

# Execute em paralelo
$results = [System.Collections.Concurrent.ConcurrentBag[object]]::new()
$jobs = @()

Write-Host "${YELLOW}⚡ Starting parallel execution...${RESET}"
Write-Host ""

foreach ($app in $allApps) {
    $job = Start-Job -ScriptBlock $scriptBlock -ArgumentList @($app.Path, $app.Name, $app.Category)
    $jobs += $job

    # Throttle: wait if too many jobs running
    while (($jobs | Where-Object { $_.State -eq 'Running' }).Count -ge $MaxJobs) {
        Start-Sleep -Milliseconds 100
    }
}

# Monitor progress
$total = $jobs.Count
$lastCount = 0

while ($jobs | Where-Object { $_.State -eq 'Running' }) {
    $completed = ($jobs | Where-Object { $_.State -eq 'Completed' }).Count
    $running = ($jobs | Where-Object { $_.State -eq 'Running' }).Count

    if ($completed -ne $lastCount) {
        $percent = [Math]::Round(($completed / $total) * 100, 1)
        $elapsed = ((Get-Date) - $startTime).TotalSeconds
        $eta = if ($completed -gt 0) { ($elapsed / $completed) * ($total - $completed) } else { 0 }

        Write-Host "`r${CYAN}Progress: $completed/$total ($percent%) | Running: $running | ETA: $([Math]::Round($eta, 0))s${RESET}" -NoNewline
        $lastCount = $completed
    }

    Start-Sleep -Milliseconds 200
}

Write-Host ""
Write-Host ""

# Collect results
foreach ($job in $jobs) {
    $result = Receive-Job -Job $job
    if ($result) {
        $results.Add($result)

        $status = if ($result.Success) { "${GREEN}✓${RESET}" } else { "${RED}✗${RESET}" }
        $issues = "$($result.Errors)E/$($result.Warnings)W"

        Write-Host "$status ${BOLD}$($result.Category)/$($result.App)${RESET} - $issues - $([Math]::Round($result.Duration, 1))s"
    }
    Remove-Job -Job $job
}

# Statistics
$endTime = Get-Date
$totalDuration = ($endTime - $startTime).TotalSeconds

Write-Host ""
Write-Host "${BOLD}${MAGENTA}═══════════════════════════════════════${RESET}"
Write-Host "${BOLD}${MAGENTA}           FINAL STATISTICS            ${RESET}"
Write-Host "${BOLD}${MAGENTA}═══════════════════════════════════════${RESET}"
Write-Host ""

$success = ($results | Where-Object { $_.Success }).Count
$failed = $results.Count - $success
$successRate = [Math]::Round(($success / $results.Count) * 100, 1)

$totalErrors = ($results | Measure-Object -Property Errors -Sum).Sum
$totalWarnings = ($results | Measure-Object -Property Warnings -Sum).Sum

Write-Host "${GREEN}✓ Success: $success${RESET}"
Write-Host "${RED}✗ Failed: $failed${RESET}"
Write-Host "${BLUE}📊 Success Rate: $successRate%${RESET}"
Write-Host "${RED}🔥 Total Errors: $totalErrors${RESET}"
Write-Host "${YELLOW}⚠️  Total Warnings: $totalWarnings${RESET}"
Write-Host ""
Write-Host "${BOLD}${BLUE}⏱️  Total Time: $([Math]::Round($totalDuration, 1))s${RESET}"
Write-Host "${BOLD}${BLUE}⚡ Avg per App: $([Math]::Round($totalDuration / $results.Count, 2))s${RESET}"
Write-Host "${BOLD}${BLUE}🚀 Apps per Second: $([Math]::Round($results.Count / $totalDuration, 2))${RESET}"
Write-Host ""

# Failed apps details
if ($failed -gt 0) {
    Write-Host "${BOLD}${RED}Apps with Errors:${RESET}"
    $results | Where-Object { -not $_.Success } | Sort-Object Errors -Descending | ForEach-Object {
        Write-Host "  ${RED}✗${RESET} $($_.Category)/$($_.App) - $($_.Errors) errors, $($_.Warnings) warnings"

        # Show top 3 issues
        $_.Issues | Where-Object { $_.Type -eq 'error' } | Select-Object -First 3 | ForEach-Object {
            Write-Host "    ${RED}→${RESET} $($_.Message) - $($_.File)"
        }
    }
    Write-Host ""
}

# Common issues analysis
if ($FixCommon) {
    Write-Host "${BOLD}${YELLOW}🔧 COMMON ISSUES ANALYSIS:${RESET}"
    Write-Host ""

    $allIssues = $results | ForEach-Object { $_.Issues }
    $groupedIssues = $allIssues | Group-Object -Property Message | Sort-Object Count -Descending | Select-Object -First 10

    foreach ($issue in $groupedIssues) {
        Write-Host "  ${CYAN}[$($issue.Count) apps]${RESET} $($issue.Name)"
    }
    Write-Host ""
}

# Top performers
Write-Host "${BOLD}${GREEN}🏆 Top 5 Fastest:${RESET}"
$results | Sort-Object Duration | Select-Object -First 5 | ForEach-Object {
    Write-Host "  ${GREEN}⚡${RESET} $($_.Category)/$($_.App) - $([Math]::Round($_.Duration, 2))s"
}
Write-Host ""

# Export JSON
$outputDir = "C:\Users\Ernane\Personal\APPs_Flutter_2\build_output_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

$jsonPath = Join-Path $outputDir "analyze_results.json"
$results | ConvertTo-Json -Depth 10 | Out-File -FilePath $jsonPath -Encoding UTF8

Write-Host "${BLUE}💾 Results saved: $jsonPath${RESET}"
Write-Host ""

if ($failed -eq 0) {
    Write-Host "${BOLD}${GREEN}🎉 ALL APPS PASSED ANALYSIS!${RESET}"
    exit 0
} else {
    Write-Host "${BOLD}${YELLOW}⚠️  $failed apps have issues - review above${RESET}"
    exit 1
}
