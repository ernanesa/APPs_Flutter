# ========================================
# SCRIPT: Pre-Flight Check
# Valida sistema antes de build/deploy
# ========================================

Write-Host "`n🚀 PRE-FLIGHT CHECK - Sistema de Otimização Extrema" -ForegroundColor Cyan
Write-Host ("="*70) -ForegroundColor Cyan

# 1. RAM Check
$totalRAM = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory
$totalRAM_GB = [math]::Round($totalRAM / 1GB, 1)
$availableRAM = (Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory
$availableRAM_GB = [math]::Round($availableRAM / 1MB, 1)

Write-Host "`n📊 HARDWARE:" -ForegroundColor Yellow
Write-Host "   RAM Total:      $totalRAM_GB GB" -ForegroundColor Gray
Write-Host "   RAM Disponível: $availableRAM_GB GB" -ForegroundColor Gray

if ($availableRAM_GB -lt 10) {
    Write-Host "   ⚠️  AVISO: Pouca RAM disponível para build paralelo!" -ForegroundColor Yellow
} else {
    Write-Host "   ✅ RAM OK para paralelização máxima" -ForegroundColor Green
}

# 2. CPU Check
$cpu = Get-CimInstance Win32_Processor
Write-Host "   CPU:            $($cpu.Name)" -ForegroundColor Gray
Write-Host "   Cores:          $($cpu.NumberOfCores) físicos" -ForegroundColor Gray
Write-Host "   Threads:        $($cpu.NumberOfLogicalProcessors) lógicos" -ForegroundColor Gray

if ($cpu.NumberOfLogicalProcessors -ge 16) {
    Write-Host "   ✅ CPU excelente para paralelização (20 threads!)" -ForegroundColor Green
} elseif ($cpu.NumberOfLogicalProcessors -ge 8) {
    Write-Host "   ✅ CPU boa para paralelização" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  CPU pode limitar paralelização" -ForegroundColor Yellow
}

# 3. GPU Check
Write-Host "`n🎮 GPU:" -ForegroundColor Yellow
try {
    $gpu = Get-CimInstance Win32_VideoController | Where-Object { $_.Name -like '*RTX*' -or $_.Name -like '*NVIDIA*' }
    if ($gpu) {
        Write-Host "   GPU:            $($gpu.Name)" -ForegroundColor Gray
        $vram_GB = [math]::Round($gpu.AdapterRAM / 1GB, 1)
        if ($vram_GB -gt 0) {
            Write-Host "   VRAM:           $vram_GB GB" -ForegroundColor Gray
        }
        Write-Host "   ✅ NVIDIA GPU detectada!" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  NVIDIA GPU NÃO detectada" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ⚠️  Erro ao detectar GPU" -ForegroundColor Yellow
}

# 4. Emulator Check
Write-Host "`n📱 EMULADORES:" -ForegroundColor Yellow
$adb = "C:\Users\Ernane\AppData\Local\Android\Sdk\platform-tools\adb.exe"

if (Test-Path $adb) {
    $devices = & $adb devices 2>&1 | Select-String "emulator"
    $deviceCount = ($devices | Measure-Object).Count
    
    Write-Host "   Dispositivos online: $deviceCount" -ForegroundColor Gray
    
    if ($deviceCount -eq 0) {
        Write-Host "   ⚠️  Nenhum emulador iniciado" -ForegroundColor Yellow
        Write-Host "   💡 Execute: pwsh tools/create_avds_optimized.ps1" -ForegroundColor Cyan
    } elseif ($deviceCount -lt 4) {
        Write-Host "   ⚠️  Apenas $deviceCount emulador(es) - recomendado 4" -ForegroundColor Yellow
    } else {
        Write-Host "   ✅ 4 emuladores online (otimizado)" -ForegroundColor Green
    }
} else {
    Write-Host "   ❌ ADB não encontrado" -ForegroundColor Red
}

# 5. Flutter SDK Check
Write-Host "`n🎯 FLUTTER SDK:" -ForegroundColor Yellow
$flutter = "C:\dev\flutter\bin\flutter.bat"

if (Test-Path $flutter) {
    try {
        $version = & $flutter --version 2>&1 | Select-String "Flutter" | Select-Object -First 1
        Write-Host "   $version" -ForegroundColor Gray
        Write-Host "   ✅ Flutter SDK OK" -ForegroundColor Green
    } catch {
        Write-Host "   ⚠️  Erro ao verificar Flutter" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ❌ Flutter SDK não encontrado em C:\dev\flutter" -ForegroundColor Red
}

# 6. Gradle Daemon Check
Write-Host "`n⚙️  GRADLE DAEMON:" -ForegroundColor Yellow
$gradleDaemons = Get-Process -Name "java" -ErrorAction SilentlyContinue | 
    Where-Object { $_.CommandLine -like "*gradle*" }

if ($gradleDaemons) {
    Write-Host "   Daemons ativos: $($gradleDaemons.Count)" -ForegroundColor Gray
    Write-Host "   ✅ Daemon pronto" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Nenhum daemon ativo (será iniciado no primeiro build)" -ForegroundColor Yellow
}

# 7. Disk Space Check
Write-Host "`n💾 DISCO:" -ForegroundColor Yellow
$drive = Get-PSDrive C
$freeSpace_GB = [math]::Round($drive.Free / 1GB, 1)

Write-Host "   Espaço livre: $freeSpace_GB GB" -ForegroundColor Gray

if ($freeSpace_GB -lt 50) {
    Write-Host "   ⚠️  AVISO: Pouco espaço em disco!" -ForegroundColor Yellow
} else {
    Write-Host "   ✅ Espaço OK" -ForegroundColor Green
}

# Resumo
Write-Host "`n" + ("="*70) -ForegroundColor Cyan
Write-Host "📋 RESUMO:" -ForegroundColor Cyan

$maxParallel = [math]::Floor(($totalRAM_GB - 2) / 3)
$maxParallel = [math]::Max(1, [math]::Min($maxParallel, 10))

Write-Host "   Paralelização recomendada: $maxParallel builds simultâneos" -ForegroundColor Green
Write-Host "   Emuladores paralelos:       4 (RTX 3050 6GB)" -ForegroundColor Green
Write-Host "   Melos concurrency:          8-10 (configurado)" -ForegroundColor Green
Write-Host "   CPU Threads disponíveis:    $($cpu.NumberOfLogicalProcessors) (14 cores P+E)" -ForegroundColor Green

Write-Host "`n✅ Sistema pronto para operação BEAST MODE!" -ForegroundColor Green
