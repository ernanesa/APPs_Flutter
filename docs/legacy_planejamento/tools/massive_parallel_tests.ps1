# MASSIVE PARALLEL TEST EXECUTION - BEAST MODE 🔥
# Utiliza 100% do CPU disponível para executar testes em paralelo

param(
    [int]$MaxParallelJobs = 16,  # Ajuste baseado nos cores da CPU
    [switch]$SkipClean,
    [switch]$OnlyAnalyze,
    [switch]$OnlyTest,
    [switch]$FullBuild,
    [string]$Category = "all"  # all, finance, health, media, productivity, etc.
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

Write-Host "${BOLD}${MAGENTA}╔════════════════════════════════════════════════════════════════╗${RESET}"
Write-Host "${BOLD}${MAGENTA}║     MASSIVE PARALLEL TEST EXECUTION - BEAST MODE 🔥           ║${RESET}"
Write-Host "${BOLD}${MAGENTA}║     Maximum CPU Utilization - Zero Latency                    ║${RESET}"
Write-Host "${BOLD}${MAGENTA}╚════════════════════════════════════════════════════════════════╝${RESET}"
Write-Host ""

# Detectar número de cores
$cores = (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors
$optimalJobs = [Math]::Max($cores, $MaxParallelJobs)

Write-Host "${CYAN}🖥️  CPU Cores: $cores${RESET}"
Write-Host "${CYAN}⚡ Parallel Jobs: $optimalJobs${RESET}"
Write-Host ""

# Timer
$globalStart = Get-Date

# Descobrir todos os apps
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

Write-Host "${BOLD}${BLUE}📦 Total Apps: $($allApps.Count)${RESET}"
Write-Host "${BLUE}📂 Categories: $($categories -join ', ')${RESET}"
Write-Host ""

# Resultados globais
$results = [System.Collections.Concurrent.ConcurrentBag[object]]::new()
$totalApps = $allApps.Count
$completed = 0

# Script block para cada job
$scriptBlock = {
    param($app, $skipClean, $onlyAnalyze, $onlyTest, $fullBuild)

    $result = @{
        App = $app.Name
        Category = $app.Category
        Path = $app.Path
        Success = $false
        Duration = 0
        Errors = 0
        Warnings = 0
        Tests = @{
            Total = 0
            Passed = 0
            Failed = 0
        }
        Steps = @{}
        Output = ""
    }

    $startTime = Get-Date
    $output = @()

    try {
        Push-Location $app.Path

        # Step 1: Clean
        if (-not $skipClean) {
            $cleanStart = Get-Date
            $cleanOutput = flutter clean 2>&1 | Out-String
            $result.Steps["clean"] = @{
                Duration = ((Get-Date) - $cleanStart).TotalSeconds
                Success = $LASTEXITCODE -eq 0
            }
            $output += "CLEAN: $($result.Steps["clean"].Duration)s"
        }

        # Step 2: Pub Get
        $pubStart = Get-Date
        $pubOutput = flutter pub get 2>&1 | Out-String
        $result.Steps["pub_get"] = @{
            Duration = ((Get-Date) - $pubStart).TotalSeconds
            Success = $LASTEXITCODE -eq 0
        }
        $output += "PUB GET: $($result.Steps["pub_get"].Duration)s"

        # Step 3: Gen L10n (se existir)
        if (Test-Path "l10n.yaml") {
            $l10nStart = Get-Date
            $l10nOutput = flutter gen-l10n 2>&1 | Out-String
            $result.Steps["gen_l10n"] = @{
                Duration = ((Get-Date) - $l10nStart).TotalSeconds
                Success = $LASTEXITCODE -eq 0
            }
            $output += "L10N: $($result.Steps["gen_l10n"].Duration)s"
        }

        # Step 4: Analyze
        if (-not $onlyTest) {
            $analyzeStart = Get-Date
            $analyzeOutput = flutter analyze 2>&1 | Out-String
            $result.Steps["analyze"] = @{
                Duration = ((Get-Date) - $analyzeStart).TotalSeconds
                Success = $LASTEXITCODE -eq 0
                Output = $analyzeOutput
            }

            # Parse errors/warnings
            if ($analyzeOutput -match '(\d+) issue.*found') {
                $result.Errors = [int]$matches[1]
            }
            if ($analyzeOutput -match '(\d+) error') {
                $result.Errors = [int]$matches[1]
            }
            if ($analyzeOutput -match '(\d+) warning') {
                $result.Warnings = [int]$matches[1]
            }

            $output += "ANALYZE: $($result.Errors)E/$($result.Warnings)W"
        }

        # Step 5: Test
        if (-not $onlyAnalyze) {
            if (Test-Path "test") {
                $testStart = Get-Date
                $testOutput = flutter test --machine 2>&1 | Out-String
                $result.Steps["test"] = @{
                    Duration = ((Get-Date) - $testStart).TotalSeconds
                    Success = $LASTEXITCODE -eq 0
                    Output = $testOutput
                }

                # Parse test results
                try {
                    $testLines = $testOutput -split "`n" | Where-Object { $_ -match '^\{' }
                    foreach ($line in $testLines) {
                        $json = $line | ConvertFrom-Json -ErrorAction SilentlyContinue
                        if ($json.type -eq 'done') {
                            $result.Tests.Total = $json.success + $json.failure
                            $result.Tests.Passed = $json.success
                            $result.Tests.Failed = $json.failure
                        }
                    }
                } catch {
                    # Fallback: count test files
                    $testFiles = (Get-ChildItem -Path "test" -Filter "*.dart" -Recurse).Count
                    $result.Tests.Total = $testFiles
                    if ($LASTEXITCODE -eq 0) {
                        $result.Tests.Passed = $testFiles
                    }
                }

                $output += "TESTS: $($result.Tests.Passed)/$($result.Tests.Total)"
            } else {
                $output += "TESTS: N/A"
            }
        }

        # Step 6: Build (se solicitado)
        if ($fullBuild) {
            $buildStart = Get-Date
            $buildOutput = flutter build apk --debug 2>&1 | Out-String
            $result.Steps["build"] = @{
                Duration = ((Get-Date) - $buildStart).TotalSeconds
                Success = $LASTEXITCODE -eq 0
            }
            $output += "BUILD: $($result.Steps["build"].Duration)s"
        }

        # Success se não houver erros críticos
        $result.Success = $result.Errors -eq 0 -and
                         ($result.Tests.Failed -eq 0 -or $result.Tests.Total -eq 0) -and
                         ($result.Steps["pub_get"].Success -eq $true)

    } catch {
        $result.Success = $false
        $output += "ERROR: $($_.Exception.Message)"
    } finally {
        Pop-Location
        $result.Duration = ((Get-Date) - $startTime).TotalSeconds
        $result.Output = $output -join " | "
    }

    return $result
}

# Executar jobs em paralelo
Write-Host "${BOLD}${YELLOW}⚡ INICIANDO EXECUÇÃO PARALELA...${RESET}"
Write-Host ""

$jobs = @()
$batchSize = $optimalJobs
$currentBatch = 0

for ($i = 0; $i -lt $allApps.Count; $i += $batchSize) {
    $currentBatch++
    $batch = $allApps[$i..[Math]::Min($i + $batchSize - 1, $allApps.Count - 1)]

    Write-Host "${CYAN}🚀 Batch $currentBatch - Processing $($batch.Count) apps...${RESET}"

    $batchJobs = @()
    foreach ($app in $batch) {
        $job = Start-Job -ScriptBlock $scriptBlock -ArgumentList @(
            $app,
            $SkipClean,
            $OnlyAnalyze,
            $OnlyTest,
            $FullBuild
        )
        $batchJobs += $job
    }

    # Aguardar batch completar com progresso
    $batchStart = Get-Date
    while ($batchJobs | Where-Object { $_.State -eq 'Running' }) {
        $runningCount = ($batchJobs | Where-Object { $_.State -eq 'Running' }).Count
        $completedCount = ($batchJobs | Where-Object { $_.State -eq 'Completed' }).Count
        $elapsed = ((Get-Date) - $batchStart).TotalSeconds

        Write-Host "`r${YELLOW}⏳ Running: $runningCount | Completed: $completedCount | Elapsed: $([Math]::Round($elapsed, 1))s${RESET}" -NoNewline
        Start-Sleep -Milliseconds 500
    }
    Write-Host ""

    # Coletar resultados do batch
    foreach ($job in $batchJobs) {
        $result = Receive-Job -Job $job
        if ($result) {
            $results.Add($result)

            # Output imediato
            $status = if ($result.Success) { "${GREEN}✓${RESET}" } else { "${RED}✗${RESET}" }
            $duration = [Math]::Round($result.Duration, 1)

            Write-Host "$status ${BOLD}$($result.Category)/$($result.App)${RESET} - ${duration}s - $($result.Output)"
        }
        Remove-Job -Job $job
    }

    Write-Host ""
}

# Calcular estatísticas finais
$globalEnd = Get-Date
$totalDuration = ($globalEnd - $globalStart).TotalSeconds

Write-Host ""
Write-Host "${BOLD}${MAGENTA}╔════════════════════════════════════════════════════════════════╗${RESET}"
Write-Host "${BOLD}${MAGENTA}║                    FINAL RESULTS                               ║${RESET}"
Write-Host "${BOLD}${MAGENTA}╚════════════════════════════════════════════════════════════════╝${RESET}"
Write-Host ""

$successful = ($results | Where-Object { $_.Success }).Count
$failed = $results.Count - $successful
$successRate = if ($results.Count -gt 0) { [Math]::Round(($successful / $results.Count) * 100, 1) } else { 0 }

$totalErrors = ($results | Measure-Object -Property Errors -Sum).Sum
$totalWarnings = ($results | Measure-Object -Property Warnings -Sum).Sum
$totalTests = ($results | ForEach-Object { $_.Tests.Passed } | Measure-Object -Sum).Sum
$totalTestsFailed = ($results | ForEach-Object { $_.Tests.Failed } | Measure-Object -Sum).Sum

Write-Host "${GREEN}✓ Successful: $successful${RESET}"
Write-Host "${RED}✗ Failed: $failed${RESET}"
Write-Host "${BLUE}📊 Success Rate: $successRate%${RESET}"
Write-Host "${YELLOW}⚠️  Total Errors: $totalErrors${RESET}"
Write-Host "${YELLOW}⚠️  Total Warnings: $totalWarnings${RESET}"
Write-Host "${CYAN}🧪 Tests Passed: $totalTests${RESET}"
Write-Host "${RED}🧪 Tests Failed: $totalTestsFailed${RESET}"
Write-Host ""
Write-Host "${BOLD}${BLUE}⏱️  Total Duration: $([Math]::Round($totalDuration, 1))s${RESET}"
Write-Host "${BOLD}${BLUE}⚡ Average per App: $([Math]::Round($totalDuration / $results.Count, 1))s${RESET}"
Write-Host ""

# Mostrar apps com falhas
if ($failed -gt 0) {
    Write-Host "${BOLD}${RED}Failed Apps:${RESET}"
    $results | Where-Object { -not $_.Success } | ForEach-Object {
        Write-Host "  ${RED}✗${RESET} $($_.Category)/$($_.App) - $($_.Errors)E/$($_.Warnings)W"
    }
    Write-Host ""
}

# Mostrar top 5 mais rápidos
Write-Host "${BOLD}${GREEN}🏆 Top 5 Fastest:${RESET}"
$results | Sort-Object Duration | Select-Object -First 5 | ForEach-Object {
    Write-Host "  ${GREEN}⚡${RESET} $($_.Category)/$($_.App) - $([Math]::Round($_.Duration, 1))s"
}
Write-Host ""

# Mostrar top 5 mais lentos
Write-Host "${BOLD}${YELLOW}🐌 Top 5 Slowest:${RESET}"
$results | Sort-Object Duration -Descending | Select-Object -First 5 | ForEach-Object {
    Write-Host "  ${YELLOW}⏱️${RESET} $($_.Category)/$($_.App) - $([Math]::Round($_.Duration, 1))s"
}
Write-Host ""

# Exportar resultados JSON
$jsonPath = "C:\Users\Ernane\Personal\APPs_Flutter_2\build_output_$(Get-Date -Format 'yyyyMMdd_HHmmss')\massive_parallel_results.json"
$jsonDir = Split-Path $jsonPath
if (-not (Test-Path $jsonDir)) {
    New-Item -ItemType Directory -Path $jsonDir -Force | Out-Null
}

$results | ConvertTo-Json -Depth 10 | Out-File -FilePath $jsonPath -Encoding UTF8
Write-Host "${BLUE}💾 Results saved to: $jsonPath${RESET}"
Write-Host ""

# Exit code
if ($failed -eq 0) {
    Write-Host "${BOLD}${GREEN}🎉 ALL TESTS PASSED! BEAST MODE COMPLETE!${RESET}"
    exit 0
} else {
    Write-Host "${BOLD}${RED}⚠️  SOME TESTS FAILED - CHECK DETAILS ABOVE${RESET}"
    exit 1
}
