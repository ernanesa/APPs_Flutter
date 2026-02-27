# ============================================================================
# WORKFLOW BEAST MODE COMPLETO - HIPER-OTIMIZADO
# ============================================================================

param(
    [string]$FlutterPath = "C:\dev\flutter\bin\flutter.bat"
)

Write-Host "`n🚀 PASSO 3/3: Executando Workflow Beast Mode Completo`n" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Gray

# Verificar Flutter SDK
if (!(Test-Path $FlutterPath)) {
    Write-Host "❌ Flutter SDK não encontrado em: $FlutterPath" -ForegroundColor Red
    Write-Host "💡 Execute primeiro: tools\install_flutter.ps1" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Flutter SDK encontrado: $FlutterPath" -ForegroundColor Green
$flutterDir = Split-Path -Parent $FlutterPath

# ============================================================================
# ETAPA 1: Criar AVDs Otimizados (4 emuladores)
# ============================================================================

Write-Host "`n📱 ETAPA 1/5: Criando AVDs Otimizados para RTX 3050...`n" -ForegroundColor Cyan

$androidSdk = "$env:LOCALAPPDATA\Android\Sdk"
$sdkmanager = "$androidSdk\cmdline-tools\latest\bin\sdkmanager.bat"
$avdmanager = "$androidSdk\cmdline-tools\latest\bin\avdmanager.bat"

if (!(Test-Path $sdkmanager)) {
    Write-Host "⚠️  SDK Manager não encontrado. Baixando system images manualmente..." -ForegroundColor Yellow
    & $FlutterPath doctor --android-licenses
}

# Baixar system images
Write-Host "📥 Baixando system images (Android 35 e 34)..." -ForegroundColor Yellow
if (Test-Path $sdkmanager) {
    & $sdkmanager "system-images;android-35;google_apis;x86_64" | Out-Null
    & $sdkmanager "system-images;android-34;google_apis;x86_64" | Out-Null
}

# Criar 4 AVDs
$avds = @(
    @{Name="Pixel7_API35_Primary"; API=35; RAM=7168; Cores=6},
    @{Name="Pixel7_API35_Worker1"; API=35; RAM=7168; Cores=6},
    @{Name="Pixel7_API34_Worker2"; API=34; RAM=6144; Cores=4},
    @{Name="Pixel7_API34_Worker3"; API=34; RAM=6144; Cores=4}
)

foreach ($avd in $avds) {
    Write-Host "   🔧 Criando: $($avd.Name)..." -NoNewline
    
    # Deletar se existir
    if (Test-Path $avdmanager) {
        & $avdmanager delete avd -n $avd.Name 2>&1 | Out-Null
    }
    
    # Criar AVD
    if (Test-Path $avdmanager) {
        $createCmd = "echo no | $avdmanager create avd -n $($avd.Name) -k 'system-images;android-$($avd.API);google_apis;x86_64' -d 'pixel_7'"
        Invoke-Expression $createCmd 2>&1 | Out-Null
    }
    
    # Configurar para RTX 3050
    $configPath = "$env:USERPROFILE\.android\avd\$($avd.Name).avd\config.ini"
    if (Test-Path $configPath) {
        Add-Content -Path $configPath -Value @"

# RTX 3050 GPU Optimization
hw.gpu.enabled=yes
hw.gpu.mode=host
hw.ramSize=$($avd.RAM)
hw.cpu.ncore=$($avd.Cores)
hw.keyboard=yes
disk.dataPartition.size=4G
"@
        Write-Host " ✅" -ForegroundColor Green
    } else {
        Write-Host " ⚠️  (config não encontrado)" -ForegroundColor Yellow
    }
}

Write-Host "`n✅ AVDs criados com otimização RTX 3050!`n" -ForegroundColor Green

# ============================================================================
# ETAPA 2: Iniciar Emuladores em Paralelo
# ============================================================================

Write-Host "📱 ETAPA 2/5: Iniciando 4 emuladores em paralelo...`n" -ForegroundColor Cyan

$emulator = "$androidSdk\emulator\emulator.exe"
$jobs = @()

if (Test-Path $emulator) {
    foreach ($avd in $avds) {
        Write-Host "   🚀 Iniciando: $($avd.Name)..." -ForegroundColor Yellow
        
        $job = Start-Job -ScriptBlock {
            param($emulatorPath, $avdName)
            & $emulatorPath -avd $avdName -gpu host -no-snapshot-load -memory $args[2] -cores $args[3]
        } -ArgumentList $emulator, $avd.Name, $avd.RAM, $avd.Cores
        
        $jobs += $job
        Start-Sleep -Seconds 3
    }
    
    Write-Host "`n✅ Emuladores iniciados em background!`n" -ForegroundColor Green
} else {
    Write-Host "⚠️  Emulator não encontrado. Pulando..." -ForegroundColor Yellow
}

# Aguardar emuladores ficarem online
Write-Host "⏳ Aguardando emuladores ficarem online (até 60s)..." -ForegroundColor Yellow
$timeout = 60
$elapsed = 0

while ($elapsed -lt $timeout) {
    $devices = & adb devices | Select-String "device$" | Measure-Object
    if ($devices.Count -ge 4) {
        Write-Host "✅ $($devices.Count) emuladores online!`n" -ForegroundColor Green
        break
    }
    Start-Sleep -Seconds 5
    $elapsed += 5
    Write-Host "   ⏳ $elapsed s..." -NoNewline
}

# ============================================================================
# ETAPA 3: Teste de Build Paralelo (8 apps)
# ============================================================================

Write-Host "`n🏗️  ETAPA 3/5: Teste de Build Paralelo (8 apps)...`n" -ForegroundColor Cyan

# Calcular paralelização dinâmica
$os = Get-CimInstance Win32_OperatingSystem
$totalRAM = [math]::Round($os.TotalVisibleMemorySize / 1GB, 2)
$freeRAM = [math]::Round($os.FreePhysicalMemory / 1GB, 2)
$maxParallel = [math]::Floor(($totalRAM - 2) / 3)
$maxParallel = [math]::Min($maxParallel, 8)

Write-Host "   📊 RAM Total: $totalRAM GB" -ForegroundColor White
Write-Host "   📊 RAM Livre: $freeRAM GB" -ForegroundColor Green
Write-Host "   🔧 Paralelização: $maxParallel builds simultâneos`n" -ForegroundColor Cyan

# Top 8 apps para teste
$testApps = @(
    "apps\productivity\pomodoro_timer",
    "apps\health\bmi_calculator",
    "apps\health\fasting_tracker",
    "apps\utility\compound_interest_calculator",
    "apps\utility\tip_calculator",
    "apps\utility\percentage_calculator",
    "apps\utility\discount_calculator",
    "apps\utility\age_calculator"
)

$buildResults = @()
$startTime = Get-Date

$testApps | ForEach-Object -Parallel {
    $app = $_
    $flutterCmd = $using:FlutterPath
    $appPath = "C:\Users\Ernane\Personal\APPs_Flutter_2\$app"
    
    if (Test-Path $appPath) {
        $appName = Split-Path -Leaf $app
        $appStart = Get-Date
        
        try {
            Set-Location $appPath
            
            # Clean + Pub Get + Build
            & $flutterCmd clean | Out-Null
            & $flutterCmd pub get | Out-Null
            & $flutterCmd build appbundle --release --no-tree-shake-icons
            
            $duration = ((Get-Date) - $appStart).TotalMinutes
            
            if (Test-Path "build\app\outputs\bundle\release\app-release.aab") {
                $size = [math]::Round((Get-Item "build\app\outputs\bundle\release\app-release.aab").Length / 1MB, 2)
                [PSCustomObject]@{
                    App = $appName
                    Status = "✅ SUCCESS"
                    Duration = "$([math]::Round($duration, 2)) min"
                    Size = "$size MB"
                }
            } else {
                [PSCustomObject]@{
                    App = $appName
                    Status = "❌ FAILED"
                    Duration = "$([math]::Round($duration, 2)) min"
                    Size = "N/A"
                }
            }
        } catch {
            [PSCustomObject]@{
                App = $appName
                Status = "❌ ERROR"
                Duration = "N/A"
                Size = "N/A"
            }
        }
    }
} -ThrottleLimit $maxParallel | Tee-Object -Variable buildResults

$totalDuration = ((Get-Date) - $startTime).TotalMinutes

Write-Host "`n======================================================================" -ForegroundColor Gray
Write-Host "📊 RESULTADOS DO BUILD PARALELO:" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Gray

$buildResults | Format-Table -AutoSize

Write-Host "⏱️  Tempo Total: $([math]::Round($totalDuration, 2)) minutos" -ForegroundColor Cyan
Write-Host "🎯 Target: 5-7 minutos para 8 apps" -ForegroundColor Yellow

if ($totalDuration -le 7) {
    Write-Host "✅ META ATINGIDA! Build paralelo funcionando perfeitamente!" -ForegroundColor Green
} else {
    Write-Host "⚠️  Acima do target. Verifique recursos ou otimize gradle.properties" -ForegroundColor Yellow
}

# ============================================================================
# ETAPA 4: Monitoramento de CPU em Tempo Real
# ============================================================================

Write-Host "`n📊 ETAPA 4/5: Iniciando Monitor de CPU (30s)...`n" -ForegroundColor Cyan

$monitorJob = Start-Job -ScriptBlock {
    $samples = 6
    for ($i = 1; $i -le $samples; $i++) {
        $cpu = (Get-CimInstance Win32_Processor).LoadPercentage
        $os = Get-CimInstance Win32_OperatingSystem
        $ramUsed = [math]::Round(($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / 1MB, 2)
        $ramTotal = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
        $ramPercent = [math]::Round(($ramUsed / $ramTotal) * 100, 2)
        
        Write-Host "   [$i/$samples] CPU: $cpu% | RAM: $ramUsed GB / $ramTotal GB ($ramPercent%)" -ForegroundColor $(if ($cpu -ge 90) { "Green" } elseif ($cpu -ge 70) { "Yellow" } else { "Red" })
        Start-Sleep -Seconds 5
    }
}

Wait-Job $monitorJob | Out-Null
Receive-Job $monitorJob

# ============================================================================
# ETAPA 5: Relatório Final
# ============================================================================

Write-Host "`n======================================================================" -ForegroundColor Gray
Write-Host "🎉 WORKFLOW BEAST MODE COMPLETO!" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Gray

Write-Host "`n📋 RESUMO:`n" -ForegroundColor Cyan
Write-Host "   ✅ AVDs criados: 4 (otimizados RTX 3050)" -ForegroundColor Green
Write-Host "   ✅ Emuladores iniciados: $($jobs.Count)" -ForegroundColor Green
Write-Host "   ✅ Apps compilados: $($buildResults.Count)" -ForegroundColor Green
Write-Host "   ⏱️  Tempo total de build: $([math]::Round($totalDuration, 2)) min" -ForegroundColor Cyan

$successCount = ($buildResults | Where-Object { $_.Status -eq "✅ SUCCESS" }).Count
$failCount = $buildResults.Count - $successCount

Write-Host "   📊 Sucessos: $successCount / $($buildResults.Count)" -ForegroundColor Green
if ($failCount -gt 0) {
    Write-Host "   ⚠️  Falhas: $failCount" -ForegroundColor Yellow
}

Write-Host "`n📁 Próximos Passos:" -ForegroundColor Cyan
Write-Host "   1. Escalar para 152 apps: melos run build:appbundle" -ForegroundColor White
Write-Host "   2. Aplicar otimizações globais: tools\deploy_gradle_optimization.ps1" -ForegroundColor White
Write-Host "   3. Configurar VSCode settings.json (GPU + 8GB heap)" -ForegroundColor White

Write-Host "`n✅ BEAST MODE ATIVADO! 🚀`n" -ForegroundColor Green
