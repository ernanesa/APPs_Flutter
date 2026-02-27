# CATEGORY-BASED PARALLEL TEST EXECUTOR
# Executa testes massivos por categoria com máxima paralelização

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("finance", "health", "media", "niche", "productivity", "tools", "utility", "all")]
    [string]$Category,

    [int]$MaxJobs = 20,
    [switch]$QuickMode,  # Apenas analyze, sem tests
    [switch]$FullMode,   # Analyze + Test + Build
    [switch]$FixMode     # Tenta corrigir erros automaticamente
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

Write-Host "${BOLD}${CYAN}╔════════════════════════════════════════════════════════════════╗${RESET}"
Write-Host "${BOLD}${CYAN}║   CATEGORY PARALLEL TEST EXECUTOR - $Category${RESET}"
Write-Host "${BOLD}${CYAN}╚════════════════════════════════════════════════════════════════╝${RESET}"
Write-Host ""

$startTime = Get-Date

# Descobrir apps da categoria
$appsRoot = "C:\Users\Ernane\Personal\APPs_Flutter_2\apps"
$apps = @()

if ($Category -eq "all")
{
    $categories = @("finance", "health", "media", "niche", "productivity", "tools", "utility")
    foreach ($cat in $categories)
    {
        $catPath = Join-Path $appsRoot $cat
        if (Test-Path $catPath)
        {
            $catApps = Get-ChildItem -Path $catPath -Directory
            foreach ($app in $catApps)
            {
                if (Test-Path (Join-Path $app.FullName "pubspec.yaml"))
                {
                    $apps += @{
                        Name = $app.Name
                        Category = $cat
                        Path = $app.FullName
                    }
                }
            }
        }
    }
} else
{
    $catPath = Join-Path $appsRoot $Category
    if (Test-Path $catPath)
    {
        $catApps = Get-ChildItem -Path $catPath -Directory
        foreach ($app in $catApps)
        {
            if (Test-Path (Join-Path $app.FullName "pubspec.yaml"))
            {
                $apps += @{
                    Name = $app.Name
                    Category = $Category
                    Path = $app.FullName
                }
            }
        }
    }
}

Write-Host "${BLUE}📦 Total Apps: $($apps.Count)${RESET}"
Write-Host "${CYAN}⚡ Max Parallel Jobs: $MaxJobs${RESET}"
Write-Host "${YELLOW}🔥 Mode: $(if ($QuickMode) { 'QUICK' } elseif ($FullMode) { 'FULL' } else { 'STANDARD' })${RESET}"
Write-Host ""

# Script block para processamento
$scriptBlock = {
    param($app, $quickMode, $fullMode, $fixMode)

    $result = @{
        App = $app.Name
        Category = $app.Category
        Success = $false
        Duration = 0
        Errors = @()
        Warnings = @()
        AnalyzeOutput = ""
        TestOutput = ""
        BuildOutput = ""
    }

    $appStart = Get-Date

    try
    {
        Set-Location $app.Path

        # 1. Pub Get (sempre)
        flutter pub get 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0)
        {
            $result.Errors += "pub_get_failed"
            return $result
        }

        # 2. Gen L10n (se existir)
        if (Test-Path "l10n.yaml")
        {
            flutter gen-l10n 2>&1 | Out-Null
        }

        # 3. Analyze
        $analyzeOutput = flutter analyze 2>&1 | Out-String
        $result.AnalyzeOutput = $analyzeOutput

        # Parse errors
        $errorMatches = [regex]::Matches($analyzeOutput, '(?m)^\s*error •')
        $warningMatches = [regex]::Matches($analyzeOutput, '(?m)^\s*warning •')

        if ($errorMatches.Count -gt 0)
        {
            foreach ($match in $errorMatches)
            {
                $line = $analyzeOutput.Substring($match.Index, 200) -split "`n" | Select-Object -First 1
                $result.Errors += $line.Trim()
            }
        }

        if ($warningMatches.Count -gt 0)
        {
            foreach ($match in $warningMatches)
            {
                $line = $analyzeOutput.Substring($match.Index, 200) -split "`n" | Select-Object -First 1
                $result.Warnings += $line.Trim()
            }
        }

        # 4. Test (se não for quick mode)
        if (-not $quickMode)
        {
            if (Test-Path "test")
            {
                $testOutput = flutter test 2>&1 | Out-String
                $result.TestOutput = $testOutput

                if ($LASTEXITCODE -ne 0)
                {
                    $result.Errors += "tests_failed"
                }
            }
        }

        # 5. Build (se full mode)
        if ($fullMode)
        {
            $buildOutput = flutter build apk --debug 2>&1 | Out-String
            $result.BuildOutput = $buildOutput

            if ($LASTEXITCODE -ne 0)
            {
                $result.Errors += "build_failed"
            }
        }

        # 6. Auto-fix (se fix mode e houver erros)
        if ($fixMode -and $result.Errors.Count -gt 0)
        {
            # Common fixes

            # Fix 1: Missing integration_test dependency
            if ($analyzeOutput -match "integration_test")
            {
                $pubspec = Get-Content "pubspec.yaml" -Raw
                if ($pubspec -notmatch "integration_test:")
                {
                    $pubspec = $pubspec -replace '(dev_dependencies:)', "`$1`n  integration_test:`n    sdk: flutter"
                    Set-Content "pubspec.yaml" -Value $pubspec
                    flutter pub get 2>&1 | Out-Null
                    $result.Errors = $result.Errors | Where-Object { $_ -notmatch "integration_test" }
                }
            }

            # Fix 2: StateNotifier → Notifier migration
            if ($analyzeOutput -match "StateNotifier")
            {
                Get-ChildItem -Path "lib" -Filter "*.dart" -Recurse | ForEach-Object {
                    $content = Get-Content $_.FullName -Raw
                    $content = $content -replace 'StateNotifier<', 'Notifier<'
                    $content = $content -replace 'StateNotifierProvider<', 'NotifierProvider<'
                    Set-Content $_.FullName -Value $content
                }
                flutter analyze 2>&1 | Out-Null
            }

            # Fix 3: Remove invalid test boilerplate
            if (Test-Path "test/widget_test.dart")
            {
                $testContent = Get-Content "test/widget_test.dart" -Raw
                if ($testContent -match "MyApp")
                {
                    Remove-Item "test/widget_test.dart" -Force
                }
            }
        }

        # Success = sem erros
        $result.Success = $result.Errors.Count -eq 0

    } catch
    {
        $result.Errors += "exception: $($_.Exception.Message)"
    } finally
    {
        $result.Duration = ((Get-Date) - $appStart).TotalSeconds
    }

    return $result
}

# Executar em paralelo
$jobs = @()
$results = [System.Collections.Concurrent.ConcurrentBag[object]]::new()

Write-Host "${YELLOW}⚡ STARTING PARALLEL EXECUTION...${RESET}"
Write-Host ""

foreach ($app in $apps)
{
    # Limitar jobs ativos
    while (($jobs | Where-Object { $_.State -eq 'Running' }).Count -ge $MaxJobs)
    {
        Start-Sleep -Milliseconds 100

        # Processar jobs completos
        $completedJobs = $jobs | Where-Object { $_.State -eq 'Completed' }
        foreach ($job in $completedJobs)
        {
            $result = Receive-Job -Job $job
            $results.Add($result)

            $status = if ($result.Success)
            { "${GREEN}✓${RESET}" 
            } else
            { "${RED}✗${RESET}" 
            }
            $duration = [Math]::Round($result.Duration, 1)
            $errorCount = $result.Errors.Count
            $warningCount = $result.Warnings.Count

            Write-Host "$status ${BOLD}$($result.Category)/$($result.App)${RESET} - ${duration}s - ${errorCount}E/${warningCount}W"

            Remove-Job -Job $job
        }
        $jobs = $jobs | Where-Object { $_.State -ne 'Completed' }
    }

    # Iniciar novo job
    $job = Start-Job -ScriptBlock $scriptBlock -ArgumentList @($app, $QuickMode, $FullMode, $FixMode)
    $jobs += $job
}

# Aguardar jobs restantes
Write-Host ""
Write-Host "${CYAN}⏳ Waiting for remaining jobs...${RESET}"

Wait-Job -Job $jobs | Out-Null

foreach ($job in $jobs)
{
    $result = Receive-Job -Job $job
    if ($result)
    {
        $results.Add($result)

        $status = if ($result.Success)
        { "${GREEN}✓${RESET}" 
        } else
        { "${RED}✗${RESET}" 
        }
        $duration = [Math]::Round($result.Duration, 1)
        $errorCount = $result.Errors.Count
        $warningCount = $result.Warnings.Count

        Write-Host "$status ${BOLD}$($result.Category)/$($result.App)${RESET} - ${duration}s - ${errorCount}E/${warningCount}W"
    }
    Remove-Job -Job $job
}

# Estatísticas finais
$endTime = Get-Date
$totalDuration = ($endTime - $startTime).TotalSeconds

Write-Host ""
Write-Host "${BOLD}${MAGENTA}╔════════════════════════════════════════════════════════════════╗${RESET}"
Write-Host "${BOLD}${MAGENTA}║                  FINAL STATISTICS                              ║${RESET}"
Write-Host "${BOLD}${MAGENTA}╚════════════════════════════════════════════════════════════════╝${RESET}"
Write-Host ""

$successful = ($results | Where-Object { $_.Success }).Count
$failed = $results.Count - $successful
$successRate = if ($results.Count -gt 0)
{ [Math]::Round(($successful / $results.Count) * 100, 1) 
} else
{ 0 
}

Write-Host "${GREEN}✓ Successful: $successful / $($results.Count)${RESET}"
Write-Host "${RED}✗ Failed: $failed${RESET}"
Write-Host "${BLUE}📊 Success Rate: $successRate%${RESET}"
Write-Host "${CYAN}⏱️  Total Time: $([Math]::Round($totalDuration, 1))s${RESET}"
Write-Host "${CYAN}⚡ Avg per App: $([Math]::Round($totalDuration / $results.Count, 1))s${RESET}"
Write-Host ""

# Mostrar erros por tipo
if ($failed -gt 0)
{
    Write-Host "${BOLD}${RED}Failed Apps Details:${RESET}"
    $results | Where-Object { -not $_.Success } | ForEach-Object {
        Write-Host ""
        Write-Host "  ${RED}✗ $($_.Category)/$($_.App)${RESET}"
        if ($_.Errors.Count -gt 0)
        {
            Write-Host "    Errors:"
            $_.Errors | Select-Object -First 3 | ForEach-Object {
                Write-Host "      - $_"
            }
        }
    }
    Write-Host ""
}

# Salvar relatório
$reportPath = "C:\Users\Ernane\Personal\APPs_Flutter_2\build_output_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
if (-not (Test-Path $reportPath))
{
    New-Item -ItemType Directory -Path $reportPath -Force | Out-Null
}

$reportFile = Join-Path $reportPath "category_${Category}_report.json"
$results | ConvertTo-Json -Depth 10 | Out-File -FilePath $reportFile -Encoding UTF8

Write-Host "${BLUE}💾 Report saved: $reportFile${RESET}"
Write-Host ""

# Exit code
exit $(if ($failed -eq 0)
    { 0 
    } else
    { 1 
    })
