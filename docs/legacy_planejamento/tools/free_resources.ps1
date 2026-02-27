# ============================================================================
# LIBERADOR DE RECURSOS - BEAST MODE
# ============================================================================

Write-Host "`n🧹 PASSO 2/3: Liberando Recursos do Sistema...`n" -ForegroundColor Cyan

# 1. Fechar processos pesados
Write-Host "📊 Fechando aplicativos pesados..." -ForegroundColor Yellow

$processesToKill = @("chrome", "msedge", "teams", "slack", "discord", "spotify", "code-insiders")
$killedCount = 0

foreach ($proc in $processesToKill) {
    $processes = Get-Process -Name $proc -ErrorAction SilentlyContinue
    if ($processes) {
        $count = $processes.Count
        Stop-Process -Name $proc -Force -ErrorAction SilentlyContinue
        $killedCount += $count
        Write-Host "   ✅ Fechado: $proc ($count instâncias)" -ForegroundColor Green
    }
}

Write-Host "   📊 Total de processos fechados: $killedCount`n" -ForegroundColor Cyan

# 2. Limpar builds antigos
Write-Host "🗑️  Limpando builds antigos..." -ForegroundColor Yellow

$buildDirs = Get-ChildItem -Path "C:\Users\Ernane\Personal\APPs_Flutter_2\apps" -Recurse -Directory -Filter "build" -ErrorAction SilentlyContinue
$freedSpace = 0

foreach ($dir in $buildDirs) {
    try {
        $size = (Get-ChildItem -Path $dir.FullName -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1GB
        Remove-Item -Path $dir.FullName -Recurse -Force -ErrorAction SilentlyContinue
        $freedSpace += $size
        Write-Host "   ✅ Removido: $($dir.FullName)" -ForegroundColor Green
    } catch {
        Write-Host "   ⚠️  Erro ao remover: $($dir.FullName)" -ForegroundColor Yellow
    }
}

Write-Host "   💾 Espaço liberado: $([math]::Round($freedSpace, 2)) GB`n" -ForegroundColor Cyan

# 3. Limpar Gradle cache (manter somente versões recentes)
Write-Host "🗑️  Limpando cache do Gradle..." -ForegroundColor Yellow

$gradleCachePath = "$env:USERPROFILE\.gradle\caches"
if (Test-Path $gradleCachePath) {
    $oldDirs = Get-ChildItem -Path $gradleCachePath -Directory | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) }
    foreach ($dir in $oldDirs) {
        try {
            Remove-Item -Path $dir.FullName -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "   ✅ Removido cache antigo: $($dir.Name)" -ForegroundColor Green
        } catch {
            Write-Host "   ⚠️  Erro ao remover: $($dir.Name)" -ForegroundColor Yellow
        }
    }
}

# 4. Verificar RAM disponível
Write-Host "`n📊 STATUS FINAL DOS RECURSOS:`n" -ForegroundColor Cyan

$os = Get-CimInstance Win32_OperatingSystem
$totalRAM = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
$freeRAM = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
$usedRAM = $totalRAM - $freeRAM

Write-Host "   RAM Total:      $totalRAM GB" -ForegroundColor White
Write-Host "   RAM Livre:      $freeRAM GB" -ForegroundColor Green
Write-Host "   RAM Em Uso:     $usedRAM GB" -ForegroundColor Yellow

if ($freeRAM -lt 15) {
    Write-Host "`n   ⚠️  AVISO: Menos de 15GB livre. Feche mais aplicativos para build paralelo ideal." -ForegroundColor Yellow
} else {
    Write-Host "`n   ✅ RAM suficiente para build paralelo!" -ForegroundColor Green
}

# 5. Verificar espaço em disco
$disk = Get-PSDrive C
$freeSpace = [math]::Round($disk.Free / 1GB, 2)

Write-Host "`n   Disco Livre:    $freeSpace GB" -ForegroundColor $(if ($freeSpace -lt 100) { "Yellow" } else { "Green" })

if ($freeSpace -lt 100) {
    Write-Host "   ⚠️  AVISO: Menos de 100GB livre. Considere limpar mais espaço." -ForegroundColor Yellow
}

Write-Host "`n✅ RECURSOS LIBERADOS!`n" -ForegroundColor Green
