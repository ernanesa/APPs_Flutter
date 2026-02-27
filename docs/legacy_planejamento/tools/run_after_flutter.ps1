# ============================================================================
# EXECUTAR APÓS FLUTTER INSTALADO - BEAST MODE LITE
# ============================================================================

Write-Host "`n🚀 BEAST MODE LITE - Teste Rápido de Build Paralelo`n" -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Gray

$flutterPath = "C:\dev\flutter\bin\flutter.bat"

# Verificar Flutter
if (!(Test-Path $flutterPath)) {
    Write-Host "❌ Flutter ainda não instalado. Aguarde o download concluir." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Flutter SDK encontrado!" -ForegroundColor Green
Write-Host ""

# Verificar versão
Write-Host "📦 Versão do Flutter:" -ForegroundColor Cyan
& $flutterPath --version
Write-Host ""

# Calcular paralelização
$os = Get-CimInstance Win32_OperatingSystem
$totalRAM = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
$freeRAM = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
$maxParallel = [math]::Max([math]::Min([math]::Floor(($totalRAM - 2) / 3), 6), 4)  # Mínimo 4, máximo 6

Write-Host "📊 RECURSOS DISPONÍVEIS:" -ForegroundColor Cyan
Write-Host "   RAM Total:          $totalRAM GB" -ForegroundColor White
Write-Host "   RAM Livre:          $freeRAM GB" -ForegroundColor Green
Write-Host "   Builds Paralelos:   $maxParallel simultâneos`n" -ForegroundColor Yellow

# Apps para teste rápido (6 apps menores)
$testApps = @(
    "apps\utility\tip_calculator",
    "apps\utility\percentage_calculator",
    "apps\utility\discount_calculator",
    "apps\utility\age_calculator",
    "apps\utility\temperature_converter",
    "apps\utility\bmi_calculator"
)

Write-Host "🏗️  INICIANDO BUILD PARALELO DE 6 APPS (TESTE)...`n" -ForegroundColor Cyan
$startTime = Get-Date

$results = $testApps | ForEach-Object -Parallel {
    $app = $_
    $flutterCmd = $using:flutterPath
    $appPath = "C:\Users\Ernane\Personal\APPs_Flutter_2\$app"
    
    if (Test-Path $appPath) {
        $appName = Split-Path -Leaf $app
        $appStart = Get-Date
        
        try {
            Set-Location $appPath
            
            Write-Host "   🔨 Building: $appName..." -ForegroundColor Yellow
            
            # Clean + Pub Get + Build
            & $flutterCmd clean 2>&1 | Out-Null
            & $flutterCmd pub get 2>&1 | Out-Null
            & $flutterCmd build appbundle --release 2>&1 | Out-Null
            
            $duration = ((Get-Date) - $appStart).TotalMinutes
            
            if (Test-Path "build\app\outputs\bundle\release\app-release.aab") {
                $size = [math]::Round((Get-Item "build\app\outputs\bundle\release\app-release.aab").Length / 1MB, 2)
                Write-Host "   ✅ $appName - $([math]::Round($duration, 2)) min - $size MB" -ForegroundColor Green
                
                [PSCustomObject]@{
                    App = $appName
                    Status = "✅ SUCCESS"
                    Duration = "$([math]::Round($duration, 2)) min"
                    Size = "$size MB"
                }
            } else {
                Write-Host "   ❌ $appName - Build falhou" -ForegroundColor Red
                [PSCustomObject]@{
                    App = $appName
                    Status = "❌ FAILED"
                    Duration = "$([math]::Round($duration, 2)) min"
                    Size = "N/A"
                }
            }
        } catch {
            Write-Host "   ❌ $appName - Erro: $_" -ForegroundColor Red
            [PSCustomObject]@{
                App = $appName
                Status = "❌ ERROR"
                Duration = "N/A"
                Size = "N/A"
            }
        }
    }
} -ThrottleLimit $maxParallel

$totalDuration = ((Get-Date) - $startTime).TotalMinutes

Write-Host "`n=====================================================================" -ForegroundColor Gray
Write-Host "📊 RESULTADOS DO BUILD PARALELO:" -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Gray

$results | Format-Table -AutoSize

$successCount = ($results | Where-Object { $_.Status -eq "✅ SUCCESS" }).Count
$totalApps = $results.Count

Write-Host "⏱️  Tempo Total:      $([math]::Round($totalDuration, 2)) minutos" -ForegroundColor Cyan
Write-Host "✅ Builds com Sucesso: $successCount / $totalApps" -ForegroundColor Green
Write-Host "🎯 Target:            < 3 minutos para 6 apps" -ForegroundColor Yellow

if ($totalDuration -le 3 -and $successCount -eq $totalApps) {
    Write-Host "`n🎉 PERFEITO! Beast Mode funcionando em capacidade máxima!" -ForegroundColor Green
    Write-Host "   Pronto para escalar para os 152 apps!" -ForegroundColor Green
} elseif ($totalDuration -le 5 -and $successCount -eq $totalApps) {
    Write-Host "`n✅ MUITO BOM! Performance dentro do esperado." -ForegroundColor Green
} else {
    Write-Host "`n⚠️  Verificar recursos ou otimizar gradle.properties" -ForegroundColor Yellow
}

# Monitor de CPU final
Write-Host "`n📊 VERIFICAÇÃO FINAL DE CPU:" -ForegroundColor Cyan
$cpu = (Get-CimInstance Win32_Processor).LoadPercentage
Write-Host "   CPU Usage: $cpu%" -ForegroundColor $(if ($cpu -ge 80) { "Green" } else { "Yellow" })

Write-Host "`n✅ TESTE BEAST MODE LITE CONCLUÍDO!`n" -ForegroundColor Green
Write-Host "💡 Próximo passo: Escalar para todos os 152 apps com Melos" -ForegroundColor Cyan
Write-Host "   Comando: melos run build:appbundle --concurrency=$maxParallel`n" -ForegroundColor White
