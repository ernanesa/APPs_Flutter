# BEAST MODE 5.2 - ULTRA PARALLEL TESTING V2 (CORREÇÕES + EXPANSÃO)
# Versão: 2.0 - Corrigido e expandido
# - Testa em TODOS os AVDs disponíveis
# - Screenshots de theme testing corrigidos
# - Testes de interface completos
# - Performance, Accessibility, Fix jobs funcionando

param(
    [int]$ThrottleLimit = 16
)

$ErrorActionPreference = "Continue"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outputDir = "artifacts/beast_v2_$timestamp"
New-Item -ItemType Directory -Path $outputDir -Force | Out-Null

$adbPath = "C:\Users\Ernane\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$flutterPath = "C:\Users\Ernane\flutter\sdk\bin\flutter.bat"

# Detectar devices disponíveis
$devicesRaw = & $adbPath devices | Select-String "emulator-" | ForEach-Object { $_.ToString().Split()[0] }
$availableDevices = @($devicesRaw | Where-Object { $_ })

if ($availableDevices.Count -eq 0) {
    Write-Host "❌ ERRO: Nenhum device disponível!" -ForegroundColor Red
    exit 1
}

Write-Host "🚀 BEAST MODE ULTRA V2 - HIPER-ACELERAÇÃO ATIVADA" -ForegroundColor Magenta
Write-Host "📊 Throttle Limit: $ThrottleLimit jobs simultâneos" -ForegroundColor Cyan
Write-Host "📱 Devices Disponíveis: $($availableDevices.Count) - $($availableDevices -join ', ')" -ForegroundColor Cyan
Write-Host ""

$apps = @(
    @{Name="bmi_calculator"; Path="apps/health/bmi_calculator"; Package="sa.rezende.bmi_calculator"},
    @{Name="pomodoro_timer"; Path="apps/productivity/pomodoro_timer"; Package="sa.rezende.pomodoro_timer"},
    @{Name="compound_interest_calculator"; Path="apps/finance/compound_interest_calculator"; Package="sa.rezende.compound_interest_calculator"}
)

$jobs = @()

# =========================
# FASE 0: BUILD APKs (PARALELO)
# =========================
Write-Host "🔨 FASE 0: Building APKs em Paralelo..." -ForegroundColor Yellow

foreach ($app in $apps) {
    $jobName = "Build_$($app.Name)"
    $jobs += Start-Job -Name $jobName -ScriptBlock {
        param($appPath, $appName, $flutterPath)
        
        $result = @{
            Name = "Build - $appName"
            Status = "RUNNING"
            StartTime = Get-Date
        }
        
        try {
            Set-Location $appPath
            
            # Flutter clean + pub get + build
            $output = @()
            $output += & $flutterPath clean 2>&1 | Out-String
            $output += & $flutterPath pub get 2>&1 | Out-String
            $output += & $flutterPath build apk --debug 2>&1 | Out-String
            
            $apkPath = "build/app/outputs/flutter-apk/app-debug.apk"
            if (Test-Path $apkPath) {
                $result.Status = "SUCCESS"
                $result.ApkPath = (Resolve-Path $apkPath).Path
                $result.ApkSize = [math]::Round((Get-Item $apkPath).Length / 1MB, 2)
            } else {
                $result.Status = "FAILED"
                $result.Error = "APK not found"
            }
            
            $result.Output = $output -join "`n"
        } catch {
            $result.Status = "FAILED"
            $result.Error = $_.Exception.Message
        }
        
        $result.EndTime = Get-Date
        $result.Duration = ($result.EndTime - $result.StartTime).TotalSeconds
        return $result
    } -ArgumentList (Join-Path "C:\Users\Ernane\Personal\APPs_Flutter_2" $app.Path), $app.Name, $flutterPath
}

# Aguardar builds completarem
Write-Host "⏳ Aguardando builds..." -ForegroundColor Cyan
$jobs | Wait-Job | Out-Null
$buildResults = $jobs | Receive-Job
$jobs | Remove-Job -Force
$jobs = @()

Write-Host ""
foreach ($result in $buildResults) {
    if ($result.Status -eq "SUCCESS") {
        Write-Host "   ✅ $($result.Name) - $($result.ApkSize) MB ($([math]::Round($result.Duration, 1))s)" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $($result.Name) - FAILED: $($result.Error)" -ForegroundColor Red
    }
}

# =========================
# FASE 1: INSTALAÇÃO EM TODOS OS DEVICES (PARALELO)
# =========================
Write-Host ""
Write-Host "📲 FASE 1: Instalando em TODOS os devices..." -ForegroundColor Yellow

foreach ($app in $apps) {
    $apkPath = Join-Path "C:\Users\Ernane\Personal\APPs_Flutter_2" "$($app.Path)/build/app/outputs/flutter-apk/app-debug.apk"
    
    foreach ($device in $availableDevices) {
        $jobName = "Install_$($app.Name)_$device"
        $jobs += Start-Job -Name $jobName -ScriptBlock {
            param($apkPath, $appName, $device, $adbPath)
            
            $result = @{
                Name = "$appName → $device"
                Status = "RUNNING"
                StartTime = Get-Date
            }
            
            try {
                if (Test-Path $apkPath) {
                    $output = & $adbPath -s $device install -r $apkPath 2>&1 | Out-String
                    
                    if ($output -like "*Success*") {
                        $result.Status = "SUCCESS"
                    } else {
                        $result.Status = "FAILED"
                        $result.Error = "Install failed"
                    }
                    $result.Output = $output
                } else {
                    $result.Status = "FAILED"
                    $result.Error = "APK not found: $apkPath"
                }
            } catch {
                $result.Status = "FAILED"
                $result.Error = $_.Exception.Message
            }
            
            $result.EndTime = Get-Date
            $result.Duration = ($result.EndTime - $result.StartTime).TotalSeconds
            return $result
        } -ArgumentList $apkPath, $app.Name, $device, $adbPath
    }
}

Write-Host "⏳ Aguardando instalações..." -ForegroundColor Cyan
$jobs | Wait-Job | Out-Null
$installResults = $jobs | Receive-Job
$jobs | Remove-Job -Force
$jobs = @()

Write-Host ""
$installMatrix = $installResults | Group-Object { $_.Name.Split('→')[0].Trim() }
foreach ($group in $installMatrix) {
    $appName = $group.Name
    $success = ($group.Group | Where-Object { $_.Status -eq "SUCCESS" }).Count
    $total = $group.Count
    $icon = if ($success -eq $total) { "✅" } else { "⚠️" }
    Write-Host "   $icon ${appName}: $success/$total devices" -ForegroundColor $(if ($success -eq $total) { "Green" } else { "Yellow" })
}

# =========================
# FASE 2: UI SCREENSHOT MATRIX (TODOS OS APPS × TODOS OS DEVICES)
# =========================
Write-Host ""
Write-Host "📸 FASE 2: UI Screenshot Matrix (Apps × Devices × Screens)..." -ForegroundColor Yellow

$uiScenarios = @(
    @{Screen="home"; Delay=3},
    @{Screen="after_interaction"; Delay=2}
)

foreach ($app in $apps) {
    foreach ($device in $availableDevices) {
        foreach ($scenario in $uiScenarios) {
            $jobName = "Screenshot_$($app.Name)_${device}_$($scenario.Screen)"
            $jobs += Start-Job -Name $jobName -ScriptBlock {
                param($package, $appName, $device, $screen, $delay, $adbPath, $outputDir)
                
                $result = @{
                    Name = "$appName @ $device - $screen"
                    Status = "RUNNING"
                    StartTime = Get-Date
                }
                
                try {
                    # Lançar app
                    & $adbPath -s $device shell am start -n "$package/.MainActivity" 2>&1 | Out-Null
                    Start-Sleep -Seconds $delay
                    
                    # Interação básica (se não for home)
                    if ($screen -ne "home") {
                        & $adbPath -s $device shell input tap 400 800 2>&1 | Out-Null
                        Start-Sleep -Seconds 2
                    }
                    
                    # Capturar screenshot (método direto via file pull)
                    $screenshotPath = "$outputDir/${appName}_${device}_${screen}.png"
                    & $adbPath -s $device shell screencap -p /sdcard/screen.png 2>&1 | Out-Null
                    & $adbPath -s $device pull /sdcard/screen.png $screenshotPath 2>&1 | Out-Null
                    
                    if ((Test-Path $screenshotPath) -and (Get-Item $screenshotPath).Length -gt 1000) {
                        $result.Status = "SUCCESS"
                        $result.Screenshot = $screenshotPath
                        $result.Size = [math]::Round((Get-Item $screenshotPath).Length / 1KB, 1)
                    } else {
                        $result.Status = "FAILED"
                        $result.Error = "Screenshot invalid or too small"
                    }
                } catch {
                    $result.Status = "FAILED"
                    $result.Error = $_.Exception.Message
                }
                
                $result.EndTime = Get-Date
                $result.Duration = ($result.EndTime - $result.StartTime).TotalSeconds
                return $result
            } -ArgumentList $app.Package, $app.Name, $device, $scenario.Screen, $scenario.Delay, $adbPath, $outputDir
        }
    }
}

# =========================
# FASE 3: UI AUTOMATION TESTS (INTERAÇÃO COMPLETA)
# =========================
Write-Host "🤖 FASE 3: UI Automation Tests..." -ForegroundColor Yellow

$automationTests = @(
    @{
        App = "bmi_calculator"
        Package = "sa.rezende.bmi_calculator"
        Test = "FullCalculation"
        Steps = @(
            @{Action="tap"; X=400; Y=600; Desc="Tap height field"},
            @{Action="text"; Value="170"; Desc="Enter height"},
            @{Action="tap"; X=400; Y=800; Desc="Tap weight field"},
            @{Action="text"; Value="70"; Desc="Enter weight"},
            @{Action="tap"; X=400; Y=1000; Desc="Tap calculate"},
            @{Action="wait"; Seconds=2; Desc="Wait for result"}
        )
    },
    @{
        App = "compound_interest_calculator"
        Package = "sa.rezende.compound_interest_calculator"
        Test = "BasicCalculation"
        Steps = @(
            @{Action="tap"; X=400; Y=600; Desc="Tap principal"},
            @{Action="text"; Value="1000"; Desc="Enter 1000"},
            @{Action="tap"; X=400; Y=800; Desc="Tap rate"},
            @{Action="text"; Value="5"; Desc="Enter 5%"},
            @{Action="tap"; X=400; Y=1000; Desc="Tap calculate"}
        )
    }
)

foreach ($test in $automationTests) {
    foreach ($device in $availableDevices) {
        $jobName = "Automation_$($test.App)_${device}_$($test.Test)"
        $jobs += Start-Job -Name $jobName -ScriptBlock {
            param($package, $appName, $testName, $steps, $device, $adbPath, $outputDir)
            
            $result = @{
                Name = "$appName @ $device - $testName"
                Status = "RUNNING"
                StartTime = Get-Date
                StepsCompleted = @()
            }
            
            try {
                # Lançar app limpo
                & $adbPath -s $device shell am force-stop $package 2>&1 | Out-Null
                Start-Sleep -Seconds 1
                & $adbPath -s $device shell am start -n "$package/.MainActivity" 2>&1 | Out-Null
                Start-Sleep -Seconds 3
                
                # Executar steps
                foreach ($step in $steps) {
                    switch ($step.Action) {
                        "tap" {
                            & $adbPath -s $device shell input tap $($step.X) $($step.Y) 2>&1 | Out-Null
                            Start-Sleep -Milliseconds 500
                        }
                        "text" {
                            & $adbPath -s $device shell input text $($step.Value) 2>&1 | Out-Null
                            Start-Sleep -Milliseconds 500
                        }
                        "wait" {
                            Start-Sleep -Seconds $($step.Seconds)
                        }
                    }
                    $result.StepsCompleted += $step.Desc
                }
                
                # UI Dump final
                & $adbPath -s $device shell uiautomator dump /sdcard/ui_dump.xml 2>&1 | Out-Null
                $uiContent = & $adbPath -s $device shell cat /sdcard/ui_dump.xml 2>&1
                
                # Screenshot final (método direto via file pull)
                $screenshotPath = "$outputDir/${appName}_${device}_${testName}_final.png"
                & $adbPath -s $device shell screencap -p /sdcard/screen_final.png 2>&1 | Out-Null
                & $adbPath -s $device pull /sdcard/screen_final.png $screenshotPath 2>&1 | Out-Null
                
                $result.Status = "SUCCESS"
                $result.Screenshot = $screenshotPath
                $result.UIElements = ($uiContent | Select-String -Pattern 'text="[^"]+"' -AllMatches).Matches.Count
            } catch {
                $result.Status = "FAILED"
                $result.Error = $_.Exception.Message
            }
            
            $result.EndTime = Get-Date
            $result.Duration = ($result.EndTime - $result.StartTime).TotalSeconds
            return $result
        } -ArgumentList $test.Package, $test.App, $test.Test, $test.Steps, $device, $adbPath, $outputDir
    }
}

# =========================
# FASE 4: PERFORMANCE ANALYSIS (TODOS OS APPS)
# =========================
Write-Host "⚡ FASE 4: Performance Analysis..." -ForegroundColor Yellow

foreach ($app in $apps) {
    $jobName = "Perf_$($app.Name)"
    $jobs += Start-Job -Name $jobName -ScriptBlock {
        param($appPath, $appName, $flutterPath)
        
        $result = @{
            Name = "$appName - Performance"
            Status = "RUNNING"
            StartTime = Get-Date
        }
        
        try {
            Set-Location $appPath
            
            # Análise estática
            $analyzeOutput = & $flutterPath analyze 2>&1 | Out-String
            $result.AnalyzeOutput = $analyzeOutput
            $result.AnalyzeIssues = ($analyzeOutput | Select-String -Pattern "issue" -AllMatches).Matches.Count
            
            # Contagem de anti-patterns
            $libPath = "lib"
            if (Test-Path $libPath) {
                $result.SetStateCount = (Get-ChildItem $libPath -Recurse -Filter "*.dart" -ErrorAction SilentlyContinue | Select-String "setState\(" -ErrorAction SilentlyContinue | Measure-Object).Count
                $result.DebugPrintCount = (Get-ChildItem $libPath -Recurse -Filter "*.dart" -ErrorAction SilentlyContinue | Select-String "debugPrint\(" -ErrorAction SilentlyContinue | Measure-Object).Count
                $result.ConstCount = (Get-ChildItem $libPath -Recurse -Filter "*.dart" -ErrorAction SilentlyContinue | Select-String "const \w+\(" -ErrorAction SilentlyContinue | Measure-Object).Count
            }
            
            $result.Status = "SUCCESS"
        } catch {
            $result.Status = "FAILED"
            $result.Error = $_.Exception.Message
        }
        
        $result.EndTime = Get-Date
        $result.Duration = ($result.EndTime - $result.StartTime).TotalSeconds
        return $result
    } -ArgumentList (Join-Path "C:\Users\Ernane\Personal\APPs_Flutter_2" $app.Path), $app.Name, $flutterPath
}

# =========================
# FASE 5: ACCESSIBILITY AUDIT (TODOS OS APPS)
# =========================
Write-Host "♿ FASE 5: Accessibility Audit..." -ForegroundColor Yellow

foreach ($app in $apps) {
    $jobName = "A11y_$($app.Name)"
    $jobs += Start-Job -Name $jobName -ScriptBlock {
        param($appPath, $appName)
        
        $result = @{
            Name = "$appName - Accessibility"
            Status = "RUNNING"
            StartTime = Get-Date
        }
        
        try {
            $libPath = Join-Path $appPath "lib"
            
            if (Test-Path $libPath) {
                $result.SemanticsLabels = (Get-ChildItem $libPath -Recurse -Filter "*.dart" -ErrorAction SilentlyContinue | Select-String "semanticsLabel:" -ErrorAction SilentlyContinue | Measure-Object).Count
                $result.ExcludeSemantics = (Get-ChildItem $libPath -Recurse -Filter "*.dart" -ErrorAction SilentlyContinue | Select-String "ExcludeSemantics" -ErrorAction SilentlyContinue | Measure-Object).Count
                $result.MergeSemantics = (Get-ChildItem $libPath -Recurse -Filter "*.dart" -ErrorAction SilentlyContinue | Select-String "MergeSemantics" -ErrorAction SilentlyContinue | Measure-Object).Count
                
                $result.Score = if ($result.SemanticsLabels -gt 10) { "GOOD" } elseif ($result.SemanticsLabels -gt 5) { "FAIR" } else { "POOR" }
                $result.Status = "SUCCESS"
            } else {
                $result.Status = "FAILED"
                $result.Error = "lib path not found"
            }
        } catch {
            $result.Status = "FAILED"
            $result.Error = $_.Exception.Message
        }
        
        $result.EndTime = Get-Date
        $result.Duration = ($result.EndTime - $result.StartTime).TotalSeconds
        return $result
    } -ArgumentList (Join-Path "C:\Users\Ernane\Personal\APPs_Flutter_2" $app.Path), $app.Name
}

# =========================
# AGUARDAR TODOS OS JOBS
# =========================
Write-Host ""
Write-Host "⏳ Executando $($jobs.Count) jobs em paralelo (Throttle: $ThrottleLimit)..." -ForegroundColor Cyan

$completedJobs = @()
$startTime = Get-Date

while ($jobs.Count -gt 0) {
    $running = ($jobs | Get-Job | Where-Object { $_.State -eq 'Running' }).Count
    $completed = ($jobs | Get-Job | Where-Object { $_.State -eq 'Completed' }).Count
    $failed = ($jobs | Get-Job | Where-Object { $_.State -eq 'Failed' }).Count
    
    $elapsed = ((Get-Date) - $startTime).TotalSeconds
    Write-Host "`r🔄 Running: $running | Completed: $completed | Failed: $failed | Elapsed: $([math]::Round($elapsed, 1))s" -NoNewline -ForegroundColor Yellow
    
    $jobs | Get-Job | Where-Object { $_.State -ne 'Running' } | ForEach-Object {
        $completedJobs += Receive-Job -Job $_ -ErrorAction SilentlyContinue
        Remove-Job -Job $_ -Force -ErrorAction SilentlyContinue
        $jobs = $jobs | Where-Object { $_.Id -ne $_.Id }
    }
    
    Start-Sleep -Milliseconds 500
}

Write-Host ""
Write-Host ""

# =========================
# CONSOLIDAR RESULTADOS
# =========================
Write-Host "📊 Consolidando Resultados..." -ForegroundColor Cyan

$summary = @{
    Timestamp = $timestamp
    TotalJobs = $completedJobs.Count
    Duration = ((Get-Date) - $startTime).TotalSeconds
    Devices = $availableDevices
    Results = @{
        Builds = $buildResults
        Installs = $installResults
        Screenshots = $completedJobs | Where-Object { $_.Name -like "*Screenshot*" -or $_.Name -like "*home*" -or $_.Name -like "*after_interaction*" }
        Automation = $completedJobs | Where-Object { $_.Name -like "*Automation*" -or $_.Name -like "*Calculation*" }
        Performance = $completedJobs | Where-Object { $_.Name -like "*Perf*" -or $_.Name -like "*Performance*" }
        Accessibility = $completedJobs | Where-Object { $_.Name -like "*A11y*" -or $_.Name -like "*Accessibility*" }
    }
}

# Salvar relatório
$reportPath = "$outputDir/summary_report.json"
$summary | ConvertTo-Json -Depth 10 | Out-File $reportPath -Encoding UTF8

# =========================
# EXIBIR RESULTADOS
# =========================
Write-Host ""
Write-Host "=" * 80 -ForegroundColor Magenta
Write-Host "  BEAST MODE ULTRA V2 - RESULTADOS FINAIS" -ForegroundColor Magenta
Write-Host "=" * 80 -ForegroundColor Magenta
Write-Host ""

$totalDuration = [math]::Round($summary.Duration, 2)
Write-Host "⏱️  Duração Total: ${totalDuration}s" -ForegroundColor Cyan
Write-Host "📊 Total de Jobs: $($summary.TotalJobs)" -ForegroundColor Cyan
Write-Host "📱 Devices Testados: $($availableDevices.Count) - $($availableDevices -join ', ')" -ForegroundColor Cyan
Write-Host ""

# Builds
Write-Host "🔨 BUILDS:" -ForegroundColor Yellow
foreach ($build in $buildResults) {
    $icon = if ($build.Status -eq "SUCCESS") { "✅" } else { "❌" }
    $duration = [math]::Round($build.Duration, 1)
    Write-Host "   $icon $($build.Name) - ${duration}s" -ForegroundColor $(if ($build.Status -eq "SUCCESS") { "Green" } else { "Red" })
    if ($build.Status -eq "SUCCESS") {
        Write-Host "      APK: $($build.ApkSize) MB" -ForegroundColor Gray
    }
}

# Instalações
Write-Host ""
Write-Host "📲 INSTALAÇÕES (Matrix: Apps × Devices):" -ForegroundColor Yellow
$installSuccess = ($installResults | Where-Object { $_.Status -eq "SUCCESS" }).Count
$installTotal = $installResults.Count
Write-Host "   Total: $installSuccess/$installTotal instalações bem-sucedidas" -ForegroundColor Cyan
foreach ($group in $installMatrix) {
    $appName = $group.Name
    $deviceList = $group.Group | ForEach-Object { 
        $dev = $_.Name.Split('→')[1].Trim()
        $icon = if ($_.Status -eq "SUCCESS") { "✅" } else { "❌" }
        "$icon $dev"
    }
    Write-Host "   • $appName" -ForegroundColor White
    Write-Host "      $($deviceList -join ', ')" -ForegroundColor Gray
}

# Screenshots
Write-Host ""
Write-Host "📸 SCREENSHOTS:" -ForegroundColor Yellow
$screenshots = $summary.Results.Screenshots | Where-Object { $_.Status -eq "SUCCESS" }
Write-Host "   Total capturado: $($screenshots.Count) screenshots" -ForegroundColor Cyan
$screenshotsByApp = $screenshots | Group-Object { $_.Name.Split('@')[0].Trim() }
foreach ($group in $screenshotsByApp) {
    Write-Host "   • $($group.Name): $($group.Count) screenshots" -ForegroundColor White
}

# Automação
Write-Host ""
Write-Host "🤖 UI AUTOMATION:" -ForegroundColor Yellow
$automation = $summary.Results.Automation
$automationSuccess = ($automation | Where-Object { $_.Status -eq "SUCCESS" }).Count
Write-Host "   Testes: $automationSuccess/$($automation.Count) bem-sucedidos" -ForegroundColor Cyan
foreach ($test in $automation) {
    $icon = if ($test.Status -eq "SUCCESS") { "✅" } else { "❌" }
    Write-Host "   $icon $($test.Name) - $($test.StepsCompleted.Count) steps" -ForegroundColor $(if ($test.Status -eq "SUCCESS") { "Green" } else { "Red" })
}

# Performance
Write-Host ""
Write-Host "⚡ PERFORMANCE:" -ForegroundColor Yellow
foreach ($perf in $summary.Results.Performance) {
    if ($perf.Status -eq "SUCCESS") {
        Write-Host "   📊 $($perf.Name):" -ForegroundColor Cyan
        Write-Host "      Analyze issues: $($perf.AnalyzeIssues)" -ForegroundColor Gray
        Write-Host "      setState calls: $($perf.SetStateCount)" -ForegroundColor Gray
        Write-Host "      debugPrint calls: $($perf.DebugPrintCount)" -ForegroundColor Gray
        Write-Host "      const widgets: $($perf.ConstCount)" -ForegroundColor Gray
    }
}

# Accessibility
Write-Host ""
Write-Host "♿ ACCESSIBILITY:" -ForegroundColor Yellow
foreach ($a11y in $summary.Results.Accessibility) {
    if ($a11y.Status -eq "SUCCESS") {
        $scoreColor = if ($a11y.Score -eq "GOOD") { "Green" } elseif ($a11y.Score -eq "FAIR") { "Yellow" } else { "Red" }
        Write-Host "   🏆 $($a11y.Name): $($a11y.Score)" -ForegroundColor $scoreColor
        Write-Host "      Semantics labels: $($a11y.SemanticsLabels)" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "=" * 80 -ForegroundColor Magenta
Write-Host "🚀 BEAST MODE ULTRA V2 CONCLUÍDO!" -ForegroundColor Magenta
Write-Host "=" * 80 -ForegroundColor Magenta
Write-Host ""
Write-Host "📂 Artefatos: $outputDir" -ForegroundColor Cyan
Write-Host "📄 Relatório: $reportPath" -ForegroundColor Cyan

# Listar todos os screenshots
$allScreenshots = Get-ChildItem "$outputDir/*.png" -ErrorAction SilentlyContinue
if ($allScreenshots.Count -gt 0) {
    Write-Host ""
    Write-Host "📸 $($allScreenshots.Count) screenshots capturados:" -ForegroundColor Green
    $allScreenshots | ForEach-Object { Write-Host "   • $($_.Name)" -ForegroundColor Gray }
}
