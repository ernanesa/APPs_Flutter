# SMART PARALLEL TEST RUNNER - Optimized Batching
# Detecta automaticamente a capacidade da máquina e otimiza execução

param(
    [string]$Category = "all",
    [switch]$QuickMode,
    [switch]$DeepMode,
    [switch]$OnlyFailed,
    [string]$AppName
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

# Detectar capacidade da máquina
$totalRAM = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB
$cores = (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors
$freeRAM = (Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB

# Calcular jobs paralelos ótimos
$optimalJobs = switch ($cores)
{
    { $_ -ge 16 }
    { 32 
    }
    { $_ -ge 12 }
    { 24 
    }
    { $_ -ge 8 }
    { 16 
    }
    { $_ -ge 6 }
    { 12 
    }
    { $_ -ge 4 }
    { 8 
    }
    default
    { 4 
    }
}

# Ajustar baseado em RAM disponível (cada job usa ~500MB)
$maxJobsByRAM = [Math]::Floor($freeRAM / 500)
$finalJobs = [Math]::Min($optimalJobs, $maxJobsByRAM)
$finalJobs = [Math]::Max($finalJobs, 4)  # Mínimo 4 jobs

Write-Host "${BOLD}${CYAN}╔════════════════════════════════════════════════════════════════╗${RESET}"
Write-Host "${BOLD}${CYAN}║          SMART PARALLEL TEST RUNNER - ZERO LAG                ║${RESET}"
Write-Host "${BOLD}${CYAN}╚════════════════════════════════════════════════════════════════╝${RESET}"
Write-Host ""
Write-Host "${BLUE}🖥️  CPU Cores: $cores | RAM: $([Math]::Round($totalRAM, 1))GB (Free: $([Math]::Round($freeRAM/1024, 1))GB)${RESET}"
Write-Host "${BLUE}⚡ Parallel Jobs: $finalJobs (optimized)${RESET}"
Write-Host ""

$startTime = Get-Date

# Descobrir apps
$appsRoot = "C:\Users\Ernane\Personal\APPs_Flutter_2\apps"
$allApps = @()

if ($AppName)
{
    # Buscar app específico
    Get-ChildItem -Path $appsRoot -Recurse -Directory | Where-Object { $_.Name -eq $AppName } | ForEach-Object {
        $pubspec = Join-Path $_.FullName "pubspec.yaml"
        if (Test-Path $pubspec)
        {
            $cat = $_.Parent.Name
            $allApps += @{
                Name = $_.Name
                Category = $cat
                Path = $_.FullName
            }
        }
    }
} else
{
    $categories = if ($Category -eq "all")
    {
        @("finance", "health", "media", "niche", "productivity", "tools", "utility")
    } else
    {
        @($Category)
    }

    foreach ($cat in $categories)
    {
        $catPath = Join-Path $appsRoot $cat
        if (Test-Path $catPath)
        {
            Get-ChildItem -Path $catPath -Directory | ForEach-Object {
                $pubspec = Join-Path $_.FullName "pubspec.yaml"
                if (Test-Path $pubspec)
                {
                    $allApps += @{
                        Name = $_.Name
                        Category = $cat
                        Path = $_.FullName
                    }
                }
            }
        }
    }
}

if ($OnlyFailed)
{
    # Carregar último resultado
    $lastResults = Get-ChildItem "C:\Users\Ernane\Personal\APPs_Flutter_2\build_output_*\massive_parallel_results.json" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if ($lastResults)
    {
        $previousResults = Get-Content $lastResults.FullName | ConvertFrom-Json
        $failedApps = $previousResults | Where-Object { -not $_.Success } | ForEach-Object { $_.App }
        $allApps = $allApps | Where-Object { $failedApps -contains $_.Name }
        Write-Host "${YELLOW}📋 Re-testing $($allApps.Count) failed apps from previous run${RESET}"
    } else
    {
        Write-Host "${RED}⚠️  No previous results found, running all apps${RESET}"
    }
}

Write-Host "${BOLD}${BLUE}📦 Total Apps: $($allApps.Count)${RESET}"
Write-Host ""

# Script block otimizado
$scriptBlock = {
    param($app, $quickMode, $deepMode)

    $result = @{
        App = $app.Name
        Category = $app.Category
        Path = $app.Path
        Success = $false
        Duration = 0
        Errors = 0
        Warnings = 0
        AnalyzeOutput = ""
        TestOutput = ""
    }

    $startTime = Get-Date
    $ErrorActionPreference = "SilentlyContinue"

    try
    {
        Set-Location $app.Path

        # Quick Mode: apenas analyze
        if ($quickMode)
        {
            $analyzeOutput = flutter analyze 2>&1 | Out-String
            $result.AnalyzeOutput = $analyzeOutput

            if ($analyzeOutput -match '(\d+)\s+issue.*found')
            {
                $issues = [int]$matches[1]
                $result.Errors = $issues
            }
            if ($analyzeOutput -match 'No issues found')
            {
                $result.Success = $true
            }
        }
        # Deep Mode: full build + test
        elseif ($deepMode)
        {
            flutter clean | Out-Null
            flutter pub get | Out-Null

            if (Test-Path "l10n.yaml")
            {
                flutter gen-l10n | Out-Null
            }

            $analyzeOutput = flutter analyze 2>&1 | Out-String
            $result.AnalyzeOutput = $analyzeOutput

            if (Test-Path "test")
            {
                $testOutput = flutter test 2>&1 | Out-String
                $result.TestOutput = $testOutput
            }

            $buildOutput = flutter build apk --debug 2>&1 | Out-String
            $result.Success = $LASTEXITCODE -eq 0
        }
        # Normal Mode: analyze + test
        else
        {
            flutter pub get | Out-Null

            if (Test-Path "l10n.yaml")
            {
                flutter gen-l10n | Out-Null
            }

            $analyzeOutput = flutter analyze 2>&1 | Out-String
            $result.AnalyzeOutput = $analyzeOutput

            if ($analyzeOutput -match '(\d+)\s+issue.*found')
            {
                $issues = [int]$matches[1]
                $result.Errors = $issues
            }

            if (Test-Path "test")
            {
                $testOutput = flutter test 2>&1 | Out-String
                $result.TestOutput = $testOutput
                $result.Success = $LASTEXITCODE -eq 0 -and $result.Errors -eq 0
            } else
            {
                $result.Success = $result.Errors -eq 0
            }
        }

    } catch
    {
        $result.Success = $false
    }

    $result.Duration = ((Get-Date) - $startTime).TotalSeconds
    return $result
}

# Executar em paralelo com progresso real-time
$results = [System.Collections.Concurrent.ConcurrentBag[object]]::new()
$jobs = @()
$processedCount = 0

Write-Host "${YELLOW}⚡ STARTING PARALLEL EXECUTION...${RESET}"
Write-Host ""

foreach ($app in $allApps)
{
    # Aguardar se já temos muitos jobs rodando
    while (($jobs | Where-Object { $_.State -eq 'Running' }).Count -ge $finalJobs)
    {
        Start-Sleep -Milliseconds 100

        # Coletar jobs completados
        $completedJobs = $jobs | Where-Object { $_.State -eq 'Completed' }
        foreach ($job in $completedJobs)
        {
            $result = Receive-Job -Job $job
            if ($result)
            {
                $results.Add($result)
                $processedCount++

                $status = if ($result.Success)
                { "${GREEN}✓${RESET}" 
                } else
                { "${RED}✗${RESET}" 
                }
                $duration = [Math]::Round($result.Duration, 1)
                $errors = if ($result.Errors -gt 0)
                { " ${RED}($($result.Errors)E)${RESET}" 
                } else
                { "" 
                }

                Write-Host "$status [$processedCount/$($allApps.Count)] ${BOLD}$($result.Category)/$($result.App)${RESET} - ${duration}s$errors"
            }
            Remove-Job -Job $job
        }
        $jobs = $jobs | Where-Object { $_.State -ne 'Completed' }
    }

    # Iniciar novo job
    $job = Start-Job -ScriptBlock $scriptBlock -ArgumentList @($app, $QuickMode, $DeepMode)
    $jobs += $job
}

# Aguardar jobs restantes
Write-Host ""
Write-Host "${CYAN}⏳ Waiting for remaining jobs...${RESET}"
while ($jobs | Where-Object { $_.State -eq 'Running' })
{
    $runningCount = ($jobs | Where-Object { $_.State -eq 'Running' }).Count
    Write-Host "`r${YELLOW}Running: $runningCount${RESET}" -NoNewline
    Start-Sleep -Milliseconds 200

    $completedJobs = $jobs | Where-Object { $_.State -eq 'Completed' }
    foreach ($job in $completedJobs)
    {
        $result = Receive-Job -Job $job
        if ($result)
        {
            $results.Add($result)
            $processedCount++

            $status = if ($result.Success)
            { "${GREEN}✓${RESET}" 
            } else
            { "${RED}✗${RESET}" 
            }
            $duration = [Math]::Round($result.Duration, 1)
            $errors = if ($result.Errors -gt 0)
            { " ${RED}($($result.Errors)E)${RESET}" 
            } else
            { "" 
            }

            Write-Host "`r$status [$processedCount/$($allApps.Count)] ${BOLD}$($result.Category)/$($result.App)${RESET} - ${duration}s$errors"
        }
        Remove-Job -Job $job
    }
    $jobs = $jobs | Where-Object { $_.State -ne 'Completed' }
}

Get-Job | Remove-Job -Force

# Estatísticas finais
$endTime = Get-Date
$totalDuration = ($endTime - $startTime).TotalSeconds

Write-Host ""
Write-Host "${BOLD}${MAGENTA}╔════════════════════════════════════════════════════════════════╗${RESET}"
Write-Host "${BOLD}${MAGENTA}║                    FINAL RESULTS                               ║${RESET}"
Write-Host "${BOLD}${MAGENTA}╚════════════════════════════════════════════════════════════════╝${RESET}"
Write-Host ""

$successful = ($results | Where-Object { $_.Success }).Count
$failed = $results.Count - $successful
$successRate = if ($results.Count -gt 0)
{ [Math]::Round(($successful / $results.Count) * 100, 1) 
} else
{ 0 
}
$totalErrors = ($results | Measure-Object -Property Errors -Sum).Sum
$avgDuration = if ($results.Count -gt 0)
{ [Math]::Round(($results | Measure-Object -Property Duration -Average).Average, 1) 
} else
{ 0 
}

Write-Host "${GREEN}✓ Successful: $successful / $($results.Count)${RESET}"
Write-Host "${RED}✗ Failed: $failed${RESET}"
Write-Host "${BLUE}📊 Success Rate: $successRate%${RESET}"
Write-Host "${YELLOW}⚠️  Total Errors: $totalErrors${RESET}"
Write-Host ""
Write-Host "${BOLD}${BLUE}⏱️  Total Duration: $([Math]::Round($totalDuration, 1))s${RESET}"
Write-Host "${BOLD}${BLUE}⚡ Average per App: ${avgDuration}s${RESET}"
Write-Host "${BOLD}${BLUE}🚀 Speedup: $([Math]::Round($results.Count * $avgDuration / $totalDuration, 1))x${RESET}"
Write-Host ""

# Apps com problemas
if ($failed -gt 0)
{
    Write-Host "${BOLD}${RED}Failed Apps:${RESET}"
    $results | Where-Object { -not $_.Success } | Sort-Object Category, App | ForEach-Object {
        Write-Host "  ${RED}✗${RESET} $($_.Category)/$($_.App) - $($_.Errors) issues"
    }
    Write-Host ""
}

# Top 5 mais rápidos
Write-Host "${BOLD}${GREEN}🏆 Top 5 Fastest:${RESET}"
$results | Sort-Object Duration | Select-Object -First 5 | ForEach-Object {
    Write-Host "  ${GREEN}⚡${RESET} $($_.Category)/$($_.App) - $([Math]::Round($_.Duration, 1))s"
}
Write-Host ""

# Salvar resultados
$outputDir = "C:\Users\Ernane\Personal\APPs_Flutter_2\build_output_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $outputDir -Force | Out-Null

$jsonPath = Join-Path $outputDir "smart_parallel_results.json"
$results | ConvertTo-Json -Depth 10 | Out-File -FilePath $jsonPath -Encoding UTF8

# CSV para análise rápida
$csvPath = Join-Path $outputDir "results.csv"
$results | Select-Object Category, App, Success, Duration, Errors | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

Write-Host "${BLUE}💾 Results saved to: $outputDir${RESET}"
Write-Host ""

if ($failed -eq 0)
{
    Write-Host "${BOLD}${GREEN}🎉 ALL TESTS PASSED! ZERO LAG ACHIEVED!${RESET}"
    exit 0
} else
{
    Write-Host "${BOLD}${YELLOW}⚠️  $failed apps need attention${RESET}"
    exit 1
}
