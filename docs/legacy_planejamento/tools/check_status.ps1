# ============================================================================
# VERIFICADOR DE STATUS - BEAST MODE
# ============================================================================

Write-Host "`n🔍 VERIFICANDO STATUS DA INSTALAÇÃO...`n" -ForegroundColor Cyan

# Verificar Flutter SDK
Write-Host "1. FLUTTER SDK:" -ForegroundColor Yellow
if (Test-Path "C:\dev\flutter\bin\flutter.bat") {
    Write-Host "   ✅ Instalado em: C:\dev\flutter" -ForegroundColor Green
    $version = & "C:\dev\flutter\bin\flutter.bat" --version 2>&1 | Select-Object -First 1
    Write-Host "   📦 Versão: $version" -ForegroundColor White
} else {
    Write-Host "   ❌ Não encontrado. Execute: tools\install_flutter.ps1" -ForegroundColor Red
}

# Verificar recursos
Write-Host "`n2. RECURSOS DO SISTEMA:" -ForegroundColor Yellow
$os = Get-CimInstance Win32_OperatingSystem
$totalRAM = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
$freeRAM = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
$disk = Get-PSDrive C
$freeSpace = [math]::Round($disk.Free / 1GB, 2)

Write-Host "   RAM Livre:      $freeRAM GB / $totalRAM GB" -ForegroundColor $(if ($freeRAM -ge 15) { "Green" } else { "Yellow" })
Write-Host "   Disco Livre:    $freeSpace GB" -ForegroundColor $(if ($freeSpace -ge 100) { "Green" } else { "Yellow" })

# Verificar AVDs
Write-Host "`n3. ANDROID VIRTUAL DEVICES:" -ForegroundColor Yellow
$avdPath = "$env:USERPROFILE\.android\avd"
if (Test-Path $avdPath) {
    $avds = Get-ChildItem -Path $avdPath -Filter "*.ini" | Select-Object -ExpandProperty BaseName
    if ($avds.Count -gt 0) {
        Write-Host "   ✅ AVDs encontrados: $($avds.Count)" -ForegroundColor Green
        foreach ($avd in $avds) {
            Write-Host "      • $avd" -ForegroundColor White
        }
    } else {
        Write-Host "   ⚠️  Nenhum AVD criado. Execute: tools\create_avds_optimized.ps1" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ⚠️  Diretório AVD não encontrado" -ForegroundColor Yellow
}

# Verificar emuladores ativos
Write-Host "`n4. EMULADORES ATIVOS:" -ForegroundColor Yellow
try {
    $devices = & adb devices 2>&1 | Select-String "device$"
    if ($devices.Count -gt 0) {
        Write-Host "   ✅ Emuladores online: $($devices.Count)" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Nenhum emulador ativo" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ⚠️  ADB não disponível" -ForegroundColor Yellow
}

# Verificar scripts
Write-Host "`n5. SCRIPTS BEAST MODE:" -ForegroundColor Yellow
$scripts = @(
    "install_flutter.ps1",
    "free_resources.ps1",
    "execute_beast_mode.ps1",
    "preflight_check.ps1",
    "create_avds_optimized.ps1"
)

$scriptsOk = 0
foreach ($script in $scripts) {
    $path = "C:\Users\Ernane\Personal\APPs_Flutter_2\tools\$script"
    if (Test-Path $path) {
        $scriptsOk++
    }
}
Write-Host "   ✅ Scripts criados: $scriptsOk / $($scripts.Count)" -ForegroundColor Green

# Decisão final
Write-Host "`n" + "="*70 -ForegroundColor Gray
Write-Host "📊 RESUMO DO STATUS:" -ForegroundColor Cyan
Write-Host "="*70 -ForegroundColor Gray

$flutterOk = Test-Path "C:\dev\flutter\bin\flutter.bat"
$ramOk = $freeRAM -ge 10
$diskOk = $freeSpace -ge 50

if ($flutterOk -and $ramOk -and $diskOk) {
    Write-Host "`n✅ PRONTO PARA EXECUTAR BEAST MODE!" -ForegroundColor Green
    Write-Host "`n🚀 Próximo passo:" -ForegroundColor Cyan
    Write-Host "   pwsh -File tools\execute_beast_mode.ps1`n" -ForegroundColor White
} elseif (!$flutterOk) {
    Write-Host "`n⏳ AGUARDANDO FLUTTER SDK..." -ForegroundColor Yellow
    Write-Host "   Reexecute este script após a instalação concluir." -ForegroundColor White
} else {
    Write-Host "`n⚠️  ATENÇÃO: Recursos insuficientes" -ForegroundColor Yellow
    if (!$ramOk) {
        Write-Host "   • Feche mais aplicativos (target: 15GB+ RAM livre)" -ForegroundColor White
    }
    if (!$diskOk) {
        Write-Host "   • Limpe mais espaço em disco (target: 100GB+)" -ForegroundColor White
    }
}

Write-Host ""
