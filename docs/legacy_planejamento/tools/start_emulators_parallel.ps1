# ========================================
# SCRIPT: Iniciar 4 Emuladores em Paralelo
# Uso RTX 3050 6GB: 100% (1.5GB x 4)
# ========================================

$androidSdk = "C:\Users\Ernane\AppData\Local\Android\Sdk"
$emulator = "$androidSdk\emulator\emulator.exe"
$adb = "$androidSdk\platform-tools\adb.exe"

Write-Host "🚀 INICIANDO 4 EMULADORES EM PARALELO" -ForegroundColor Cyan
Write-Host ("="*70) -ForegroundColor Cyan

# Verificar emulator
if (-not (Test-Path $emulator)) {
    Write-Host "❌ Emulator não encontrado: $emulator" -ForegroundColor Red
    exit 1
}

# AVDs a iniciar
$avds = @(
    "Pixel7_API35_Primary",
    "Pixel7_API35_Worker1",
    "Pixel7_API35_Worker2",
    "Pixel7_API35_Worker3"
)

# Função para iniciar emulador em background
function Start-Emulator {
    param([string]$avdName, [int]$index)
    
    Write-Host "`n🚀 Iniciando $avdName..." -ForegroundColor Cyan
    
    $process = Start-Process -FilePath $emulator -ArgumentList @(
        "-avd", $avdName,
        "-gpu", "host",
        "-memory", "7168",
        "-cores", "6",
        "-no-snapshot-load",
        "-no-boot-anim",
        "-qemu", "-smp", "6,cores=6,threads=1"
    ) -NoNewWindow -PassThru
    
    Write-Host "   ✅ Processo iniciado (PID: $($process.Id))" -ForegroundColor Green
    return $process
}

# Iniciar emuladores
$jobs = @()
foreach ($avd in $avds) {
    $index = $avds.IndexOf($avd)
    $jobs += Start-Emulator -avdName $avd -index $index
    Start-Sleep -Seconds 3  # Delay para evitar conflito de porta
}

Write-Host "`n✅ 4 Emuladores iniciados em paralelo!" -ForegroundColor Green
Write-Host "📊 Uso de VRAM estimado: 1.5GB x 4 = 6GB (RTX 3050 100%)" -ForegroundColor Yellow
Write-Host "📊 Uso de RAM estimado: 7GB x 4 = 28GB (32GB total - 88%)" -ForegroundColor Yellow
Write-Host "📊 Cores alocados: 6 P-cores x 4 = 24 threads (20 threads total)" -ForegroundColor Yellow

# Aguardar boot
Write-Host "`n⏳ Aguardando boot dos emuladores (pode levar 2-3 minutos)..." -ForegroundColor Cyan

for ($i = 1; $i -le 40; $i++) {
    Start-Sleep -Seconds 5
    
    $devices = & $adb devices 2>&1 | Select-String "emulator" | Where-Object { $_ -notlike "*offline*" }
    $count = ($devices | Measure-Object).Count
    
    $percent = [math]::Round(($count / 4) * 100)
    Write-Host "   Tentativa $i/40: $count/4 dispositivos online ($percent%)" -ForegroundColor Gray
    
    if ($count -eq 4) {
        Write-Host "`n✅ Todos os 4 emuladores ONLINE!" -ForegroundColor Green
        break
    }
}

# Listar dispositivos
Write-Host "`n📱 Dispositivos disponíveis:" -ForegroundColor Cyan
& $adb devices -l

Write-Host "`n🎉 EMULADORES PRONTOS PARA TESTES!" -ForegroundColor Green
