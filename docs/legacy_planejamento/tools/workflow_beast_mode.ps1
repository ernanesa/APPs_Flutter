# ========================================
# WORKFLOW COMPLETO: Do Zero ao BEAST MODE
# Executa todos os passos automaticamente
# ========================================

$baseDir = "C:\Users\Ernane\Personal\APPs_Flutter_2"

Write-Host @"
🚀 WORKFLOW BEAST MODE - SETUP COMPLETO
======================================================================

Este script executará:
1. ✅ Preflight Check (validação)
2. 🔨 Criar 4 AVDs otimizados
3. 🚀 Iniciar 4 emuladores paralelos
4. 📊 Monitor CPU em background
5. 🔨 Build paralelo de 8 apps (TESTE)

Duração estimada: 30-40 minutos

======================================================================
"@ -ForegroundColor Cyan

Read-Host "Pressione ENTER para continuar ou CTRL+C para cancelar"

# PASSO 1: Preflight Check
Write-Host "`n[PASSO 1/5] 🔍 Preflight Check" -ForegroundColor Yellow
& pwsh -NoProfile -ExecutionPolicy Bypass -File "$baseDir\tools\preflight_check.ps1"

Read-Host "`nPressione ENTER para criar AVDs"

# PASSO 2: Criar AVDs
Write-Host "`n[PASSO 2/5] 🔨 Criando AVDs Otimizados" -ForegroundColor Yellow
& pwsh -NoProfile -ExecutionPolicy Bypass -File "$baseDir\tools\create_avds_optimized.ps1"

Read-Host "`nPressione ENTER para iniciar emuladores"

# PASSO 3: Iniciar Emuladores
Write-Host "`n[PASSO 3/5] 🚀 Iniciando 4 Emuladores" -ForegroundColor Yellow
$emuJob = Start-Job -ScriptBlock {
    & pwsh -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Ernane\Personal\APPs_Flutter_2\tools\start_emulators_parallel.ps1"
}

Write-Host "⏳ Emuladores iniciando em background..." -ForegroundColor Cyan
Write-Host "💡 Aguarde 3-4 minutos para boot completo" -ForegroundColor Yellow

Start-Sleep -Seconds 180  # 3 minutos

# PASSO 4: Monitor CPU (background)
Write-Host "`n[PASSO 4/5] 📊 Iniciando Monitor CPU (background)" -ForegroundColor Yellow
$monitorJob = Start-Job -ScriptBlock {
    & pwsh -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Ernane\Personal\APPs_Flutter_2\tools\monitor_cpu_realtime.ps1" -DurationMinutes 30
}

Write-Host "✅ Monitor ativo (30 minutos)" -ForegroundColor Green

Read-Host "`nPressione ENTER para iniciar build paralelo"

# PASSO 5: Build Paralelo
Write-Host "`n[PASSO 5/5] 🔨 Build Paralelo (8 apps)" -ForegroundColor Yellow
& pwsh -NoProfile -ExecutionPolicy Bypass -File "$baseDir\tools\build_parallel_test.ps1"

# Resultados
Write-Host "`n" + ("="*70) -ForegroundColor Cyan
Write-Host "🎉 WORKFLOW BEAST MODE CONCLUÍDO!" -ForegroundColor Green
Write-Host ("="*70) -ForegroundColor Cyan

Write-Host "`n📊 Verificar resultados:" -ForegroundColor Cyan
Write-Host "   - Monitor CPU: Receive-Job -Id $($monitorJob.Id)" -ForegroundColor Gray
Write-Host "   - Emuladores:  Receive-Job -Id $($emuJob.Id)" -ForegroundColor Gray

Write-Host "`n🎯 Próximos Passos:" -ForegroundColor Yellow
Write-Host "   1. Analisar CPU usage (meta: 90-95%)" -ForegroundColor Gray
Write-Host "   2. Ajustar concurrency se necessário" -ForegroundColor Gray
Write-Host "   3. Deploy para todos os 152 apps!" -ForegroundColor Gray
