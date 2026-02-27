# ========================================
# SCRIPT: Detectar e Configurar Flutter SDK
# Resolve problema de PATH
# ========================================

Write-Host "🔍 DETECTANDO FLUTTER SDK" -ForegroundColor Cyan
Write-Host ("="*70) -ForegroundColor Cyan

# Locais comuns do Flutter
$commonPaths = @(
    "C:\flutter\bin\flutter.bat",
    "C:\dev\flutter\bin\flutter.bat",
    "C:\src\flutter\bin\flutter.bat",
    "$env:USERPROFILE\flutter\bin\flutter.bat",
    "$env:LOCALAPPDATA\flutter\bin\flutter.bat"
)

$foundPath = $null

Write-Host "`n📂 Procurando Flutter SDK..." -ForegroundColor Yellow

foreach ($path in $commonPaths) {
    if (Test-Path $path) {
        Write-Host "   ✅ Encontrado: $path" -ForegroundColor Green
        $foundPath = $path
        break
    } else {
        Write-Host "   ❌ Não encontrado: $path" -ForegroundColor Gray
    }
}

if ($foundPath) {
    Write-Host "`n✅ FLUTTER SDK ENCONTRADO!" -ForegroundColor Green
    Write-Host "   Caminho: $foundPath" -ForegroundColor Cyan
    
    # Testar versão
    Write-Host "`n🔬 Testando Flutter..." -ForegroundColor Yellow
    try {
        $version = & $foundPath --version 2>&1 | Select-String "Flutter" | Select-Object -First 1
        Write-Host "   $version" -ForegroundColor Gray
        
        # Adicionar ao PATH da sessão
        $flutterBin = Split-Path $foundPath
        $env:Path = "$flutterBin;$env:Path"
        Write-Host "`n✅ Flutter adicionado ao PATH da sessão atual" -ForegroundColor Green
        
        # Criar arquivo de configuração
        $configFile = "C:\Users\Ernane\Personal\APPs_Flutter_2\tools\flutter_config.txt"
        Set-Content -Path $configFile -Value $foundPath
        Write-Host "✅ Caminho salvo em: $configFile" -ForegroundColor Green
        
        # Atualizar scripts automaticamente
        Write-Host "`n🔧 Atualizando scripts..." -ForegroundColor Yellow
        
        $scriptsToUpdate = @(
            "C:\Users\Ernane\Personal\APPs_Flutter_2\tools\build_parallel_test.ps1"
        )
        
        foreach ($script in $scriptsToUpdate) {
            if (Test-Path $script) {
                $content = Get-Content $script -Raw
                $content = $content -replace 'C:\\dev\\flutter\\bin\\flutter\.bat', $foundPath
                Set-Content -Path $script -Value $content
                Write-Host "   ✅ Atualizado: $(Split-Path $script -Leaf)" -ForegroundColor Green
            }
        }
        
    } catch {
        Write-Host "   ⚠️  Erro ao testar Flutter: $_" -ForegroundColor Yellow
    }
    
} else {
    Write-Host "`n❌ FLUTTER SDK NÃO ENCONTRADO!" -ForegroundColor Red
    Write-Host "`n💡 Opções:" -ForegroundColor Yellow
    Write-Host "   1. Instalar Flutter SDK:" -ForegroundColor Gray
    Write-Host "      https://docs.flutter.dev/get-started/install/windows" -ForegroundColor Cyan
    Write-Host "`n   2. Se já instalado, informar caminho manualmente:" -ForegroundColor Gray
    
    $manualPath = Read-Host "`n   Digite o caminho completo do flutter.bat (ou ENTER para pular)"
    
    if ($manualPath -and (Test-Path $manualPath)) {
        Write-Host "   ✅ Caminho válido!" -ForegroundColor Green
        $foundPath = $manualPath
        
        $configFile = "C:\Users\Ernane\Personal\APPs_Flutter_2\tools\flutter_config.txt"
        Set-Content -Path $configFile -Value $foundPath
        Write-Host "   ✅ Caminho salvo em: $configFile" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Caminho inválido ou não fornecido" -ForegroundColor Yellow
    }
}

# Resumo
Write-Host "`n" + ("="*70) -ForegroundColor Cyan
Write-Host "📋 RESUMO" -ForegroundColor Cyan
Write-Host ("="*70) -ForegroundColor Cyan

if ($foundPath) {
    Write-Host "✅ Status:        Flutter SDK configurado" -ForegroundColor Green
    Write-Host "📂 Caminho:       $foundPath" -ForegroundColor Gray
    Write-Host "💾 Config salvo:  tools\flutter_config.txt" -ForegroundColor Gray
    Write-Host "`n🎯 Próximo Passo: Execute workflow_beast_mode.ps1" -ForegroundColor Cyan
} else {
    Write-Host "❌ Status:        Flutter SDK não encontrado" -ForegroundColor Red
    Write-Host "💡 Ação:          Instale Flutter ou configure manualmente" -ForegroundColor Yellow
}
