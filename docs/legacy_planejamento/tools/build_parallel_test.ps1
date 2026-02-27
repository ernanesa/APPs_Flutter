# ========================================
# SCRIPT: Build Paralelo - Teste com 8 Apps
# Intel Core 7 240H (20 threads) + 32GB DDR5
# ========================================

$baseDir = "C:\Users\Ernane\Personal\APPs_Flutter_2"
$flutter = "C:\dev\flutter\bin\flutter.bat"

Write-Host "🚀 BUILD PARALELO - TESTE COM 8 APPS" -ForegroundColor Cyan
Write-Host ("="*70) -ForegroundColor Cyan

# Detectar RAM
$totalRAM = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory
$totalRAM_GB = [math]::Round($totalRAM / 1GB, 1)
$maxParallel = [math]::Floor(($totalRAM_GB - 2) / 3)
$maxParallel = [math]::Max(1, [math]::Min($maxParallel, 8))

Write-Host "📊 RAM Detectada: $totalRAM_GB GB" -ForegroundColor Cyan
Write-Host "🚀 Paralelização: $maxParallel builds simultâneos" -ForegroundColor Green

# Apps para testar (TOP 8)
$apps = @(
    "apps/productivity/pomodoro_timer",
    "apps/productivity/qr_generator",
    "apps/productivity/todo_list",
    "apps/finance/compound_interest_calculator",
    "apps/health/bmi_calculator",
    "apps/media/white_noise",
    "apps/niche/decision_wheel",
    "apps/niche/game_scoreboard"
)

Write-Host "`n📋 Apps selecionados: $($apps.Count)" -ForegroundColor Cyan
$apps | ForEach-Object { Write-Host "   - $(Split-Path $_ -Leaf)" -ForegroundColor Gray }

# Função de build
function Build-App {
    param([string]$appPath, [int]$index)
    
    $fullPath = Join-Path $baseDir $appPath
    $appName = Split-Path $appPath -Leaf
    
    Write-Host "`n[$index] 🔨 Building $appName..." -ForegroundColor Cyan
    
    try {
        Push-Location $fullPath
        
        # Clean + Pub Get + Build
        $cleanOutput = & $flutter clean 2>&1
        $getOutput = & $flutter pub get 2>&1
        $buildOutput = & $flutter build appbundle --release 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ [$index] $appName BUILD OK" -ForegroundColor Green
            return @{ Success = $true; App = $appName; Time = (Get-Date) }
        } else {
            Write-Host "❌ [$index] $appName BUILD FAILED" -ForegroundColor Red
            return @{ Success = $false; App = $appName; Error = "Exit code $LASTEXITCODE" }
        }
    } catch {
        Write-Host "❌ [$index] $appName EXCEPTION: $_" -ForegroundColor Red
        return @{ Success = $false; App = $appName; Error = $_.Exception.Message }
    } finally {
        Pop-Location
    }
}

# Build em paralelo
Write-Host "`n🚀 Iniciando build paralelo ($maxParallel workers)..." -ForegroundColor Cyan
$startTime = Get-Date

$results = $apps | ForEach-Object -Parallel {
    $buildFunc = $using:Build-App
    $index = $using:apps.IndexOf($_) + 1
    & $buildFunc -appPath $_ -index $index
} -ThrottleLimit $maxParallel

$endTime = Get-Date
$duration = ($endTime - $startTime).TotalMinutes

# Relatório
Write-Host "`n" + ("="*70) -ForegroundColor Cyan
Write-Host "📊 RELATÓRIO DE BUILD PARALELO" -ForegroundColor Cyan
Write-Host ("="*70) -ForegroundColor Cyan

$success = ($results | Where-Object { $_.Success }).Count
$failed = ($results | Where-Object { -not $_.Success }).Count

Write-Host "✅ Sucessos:  $success / $($apps.Count)" -ForegroundColor Green
Write-Host "❌ Falhas:    $failed / $($apps.Count)" -ForegroundColor $(if ($failed -eq 0) { "Green" } else { "Red" })
Write-Host "⏱️  Tempo:     $([math]::Round($duration, 2)) minutos" -ForegroundColor Yellow
Write-Host "🚀 Workers:   $maxParallel paralelos" -ForegroundColor Cyan

# Economia de tempo
$sequentialTime = $apps.Count * 5
$savings = $sequentialTime - $duration
$savingsPercent = [math]::Round(($savings / $sequentialTime) * 100, 1)

Write-Host "`n💰 ECONOMIA DE TEMPO:" -ForegroundColor Green
Write-Host "   Sequencial estimado: $sequentialTime minutos" -ForegroundColor Gray
Write-Host "   Paralelo real:       $([math]::Round($duration, 2)) minutos" -ForegroundColor Gray
Write-Host "   Economia:            $([math]::Round($savings, 2)) minutos ($savingsPercent%)" -ForegroundColor Green

if ($failed -gt 0) {
    Write-Host "`n❌ Apps com falha:" -ForegroundColor Red
    $results | Where-Object { -not $_.Success } | ForEach-Object {
        Write-Host "   - $($_.App): $($_.Error)" -ForegroundColor Red
    }
}

Write-Host "`n🎉 TESTE CONCLUÍDO!" -ForegroundColor Green
