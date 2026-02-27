# ========================================
# SCRIPT: Monitor CPU/RAM em Tempo Real
# Alvo: 90-95% CPU usage durante builds
# ========================================

param(
    [int]$DurationMinutes = 10,
    [int]$IntervalSeconds = 2
)

Write-Host "📊 MONITOR CPU/RAM - TEMPO REAL" -ForegroundColor Cyan
Write-Host "⏱️  Duração: $DurationMinutes minutos | Intervalo: $IntervalSeconds segundos" -ForegroundColor Gray
Write-Host ("="*80) -ForegroundColor Cyan

$startTime = Get-Date
$endTime = $startTime.AddMinutes($DurationMinutes)
$logFile = "cpu_monitor_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"

# CSV Header
"Timestamp,CPU_Percent,RAM_Used_GB,RAM_Free_GB,Flutter_Processes,Gradle_Processes" | 
    Out-File -FilePath $logFile

$maxCPU = 0
$avgCPU = 0
$samples = 0

Write-Host "`n🎯 Meta: CPU Usage 90-95%" -ForegroundColor Yellow
Write-Host "📈 Monitorando..." -ForegroundColor Cyan

while ((Get-Date) -lt $endTime) {
    $now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    # CPU Usage
    $cpuCounter = Get-Counter '\Processor(_Total)\% Processor Time' -SampleInterval 1
    $cpu = [math]::Round($cpuCounter.CounterSamples.CookedValue, 1)
    
    # RAM
    $os = Get-CimInstance Win32_OperatingSystem
    $totalRAM = $os.TotalVisibleMemorySize / 1MB
    $freeRAM = $os.FreePhysicalMemory / 1MB
    $usedRAM = $totalRAM - $freeRAM
    
    # Processes
    $flutterProc = (Get-Process -Name "flutter*","dart*" -ErrorAction SilentlyContinue | Measure-Object).Count
    $gradleProc = (Get-Process -Name "java" -ErrorAction SilentlyContinue | 
        Where-Object { $_.CommandLine -like "*gradle*" } | Measure-Object).Count
    
    # Estatísticas
    $maxCPU = [math]::Max($maxCPU, $cpu)
    $samples++
    $avgCPU = ($avgCPU * ($samples - 1) + $cpu) / $samples
    
    # Status Color
    $cpuColor = if ($cpu -ge 90) { "Green" } elseif ($cpu -ge 70) { "Yellow" } else { "Red" }
    $ramColor = if ($usedRAM -le 28) { "Green" } else { "Yellow" }
    
    # Display
    Write-Host "`r[$now] CPU: $cpu% | RAM: $([math]::Round($usedRAM, 1))GB | Flutter: $flutterProc | Gradle: $gradleProc | Max: $([math]::Round($maxCPU, 1))% | Avg: $([math]::Round($avgCPU, 1))%" -NoNewline -ForegroundColor $cpuColor
    
    # Log
    "$now,$cpu,$([math]::Round($usedRAM, 2)),$([math]::Round($freeRAM, 2)),$flutterProc,$gradleProc" | 
        Out-File -FilePath $logFile -Append
    
    Start-Sleep -Seconds $IntervalSeconds
}

# Resumo
Write-Host "`n`n" + ("="*80) -ForegroundColor Cyan
Write-Host "📊 RESUMO DO MONITORAMENTO" -ForegroundColor Cyan
Write-Host ("="*80) -ForegroundColor Cyan

Write-Host "⏱️  Duração:        $DurationMinutes minutos" -ForegroundColor Gray
Write-Host "📊 CPU Máximo:     $([math]::Round($maxCPU, 1))%" -ForegroundColor $(if ($maxCPU -ge 90) { "Green" } else { "Yellow" })
Write-Host "📊 CPU Médio:      $([math]::Round($avgCPU, 1))%" -ForegroundColor Gray
Write-Host "📊 Amostras:       $samples" -ForegroundColor Gray
Write-Host "📄 Log salvo:      $logFile" -ForegroundColor Cyan

if ($maxCPU -ge 90) {
    Write-Host "`n✅ EXCELENTE! CPU atingiu meta de 90-95%" -ForegroundColor Green
} elseif ($maxCPU -ge 70) {
    Write-Host "`n⚠️  CPU abaixo da meta. Considere aumentar paralelização." -ForegroundColor Yellow
} else {
    Write-Host "`n❌ CPU muito baixa. Sistema subutilizado!" -ForegroundColor Red
}
