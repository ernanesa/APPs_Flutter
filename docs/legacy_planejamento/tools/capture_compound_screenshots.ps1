# Script para capturar screenshots reais do Compound Interest Calculator para Play Store
# Executa após instalar o APK no dispositivo

param(
    [string]$DeviceId = "8c7638ff",
    [string]$PackageName = "sa.rezende.compound_interest_calculator",
    [string]$OutputDir = "apps/finance/compound_interest_calculator/publishing/store_assets"
)

$adbPath = "C:\Users\Ernane\AppData\Local\Android\Sdk\platform-tools\adb.exe"

Write-Host "📸 CAPTURA DE SCREENSHOTS PARA PLAY STORE" -ForegroundColor Magenta
Write-Host "📱 Dispositivo: $DeviceId" -ForegroundColor Cyan
Write-Host "📦 Pacote: $PackageName" -ForegroundColor Cyan
Write-Host "📂 Saída: $OutputDir" -ForegroundColor Cyan
Write-Host ""

# Verificar se dispositivo está conectado
$devices = & $adbPath devices | Select-String -Pattern "$DeviceId\s+device"
if (-not $devices) {
    Write-Host "❌ Dispositivo $DeviceId não encontrado ou não está em modo device" -ForegroundColor Red
    exit 1
}

# Criar diretório de saída se não existir
New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

# Função para capturar screenshot
function Capture-Screenshot {
    param(
        [string]$Name,
        [string]$Description,
        [int]$DelaySeconds = 3
    )
    
    Write-Host "📸 Capturando: $Description" -ForegroundColor Yellow
    
    # Aguardar para a tela estabilizar
    Start-Sleep -Seconds $DelaySeconds
    
    # Capturar screenshot
    $remotePath = "/sdcard/${Name}.png"
    $localPath = "$OutputDir/${Name}.png"
    
    & $adbPath -s $DeviceId shell screencap -p $remotePath 2>&1 | Out-Null
    & $adbPath -s $DeviceId pull $remotePath $localPath 2>&1 | Out-Null
    
    if (Test-Path $localPath) {
        $size = (Get-Item $localPath).Length
        $sizeKB = [math]::Round($size/1KB, 1)
        Write-Host "   ✅ $localPath ($sizeKB KB)" -ForegroundColor Green
        return $true
    } else {
        Write-Host "   ❌ Falha ao capturar $Name" -ForegroundColor Red
        return $false
    }
}

# 1. Iniciar app na tela principal
Write-Host "🚀 Iniciando app..." -ForegroundColor Cyan
& $adbPath -s $DeviceId shell am start -n "$PackageName/.MainActivity" 2>&1 | Out-Null
Start-Sleep -Seconds 5

# Screenshot 1: Tela inicial (com campos vazios)
$success1 = Capture-Screenshot -Name "screenshot_01_phone" -Description "Tela inicial - campos vazios"

# 2. Preencher alguns valores para cálculo
Write-Host "🧮 Preenchendo valores para cálculo..." -ForegroundColor Cyan
# Clicar no campo principal amount (posição aproximada)
& $adbPath -s $DeviceId shell input tap 200 300 2>&1 | Out-Null
Start-Sleep -Seconds 1
# Inserir valor 1000
& $adbPath -s $DeviceId shell input text "1000" 2>&1 | Out-Null
Start-Sleep -Seconds 1
# Clicar fora (tecla Enter)
& $adbPath -s $DeviceId shell input keyevent 66 2>&1 | Out-Null
Start-Sleep -Seconds 2

# Screenshot 2: Tela com cálculo realizado
$success2 = Capture-Screenshot -Name "screenshot_02_phone" -Description "Tela com cálculo - valor inserido"

# 3. Navegar para a tela de histórico
Write-Host "📊 Navegando para histórico..." -ForegroundColor Cyan
# Clicar no botão de histórico (posição aproximada inferior)
& $adbPath -s $DeviceId shell input tap 500 1200 2>&1 | Out-Null
Start-Sleep -Seconds 3

# Screenshot 3: Tela de histórico (opcional, se quiser mais screenshots)
# $success3 = Capture-Screenshot -Name "screenshot_03_phone" -Description "Tela de histórico"

# 4. Voltar para tela principal e preencher valores diferentes
Write-Host "↩️ Voltando para tela principal..." -ForegroundColor Cyan
& $adbPath -s $DeviceId shell input keyevent 4 2>&1 | Out-Null  # Back button
Start-Sleep -Seconds 2

# Limpar campo
& $adbPath -s $DeviceId shell input tap 200 300 2>&1 | Out-Null
Start-Sleep -Seconds 1
& $adbPath -s $DeviceId shell input keyevent 67 67 67 67 2>&1 | Out-Null  # Clear
Start-Sleep -Seconds 1
# Inserir valor diferente
& $adbPath -s $DeviceId shell input text "5000" 2>&1 | Out-Null
Start-Sleep -Seconds 1
& $adbPath -s $DeviceId shell input keyevent 66 2>&1 | Out-Null
Start-Sleep -Seconds 2

# Screenshot 4: Tela com outro cálculo (opcional)
# $success4 = Capture-Screenshot -Name "screenshot_04_phone" -Description "Tela com cálculo alternativo"

# Resumo
Write-Host ""
Write-Host "📊 RESUMO DA CAPTURA" -ForegroundColor Magenta
Write-Host "-------------------" -ForegroundColor Magenta

$screenshots = Get-ChildItem "$OutputDir/*.png" -ErrorAction SilentlyContinue
if ($screenshots) {
    $totalSize = ($screenshots | Measure-Object -Property Length -Sum).Sum
    Write-Host "✅ $($screenshots.Count) screenshots capturados (Total: $([math]::Round($totalSize/1KB, 1)) KB):" -ForegroundColor Green
    $screenshots | ForEach-Object { 
        $sizeKB = [math]::Round($_.Length/1KB, 1)
        Write-Host "   • $($_.Name) ($sizeKB KB)" -ForegroundColor Gray
    }
    
    # Verificar se os screenshots são grandes o suficiente (não são placeholders)
    $smallScreenshots = $screenshots | Where-Object { $_.Length -lt 10000 }  # Menos de 10KB
    if ($smallScreenshots) {
        Write-Host "⚠️  AVISO: Os seguintes screenshots podem ser placeholders (tamanho < 10KB):" -ForegroundColor Yellow
        $smallScreenshots | ForEach-Object { Write-Host "   • $($_.Name)" -ForegroundColor Yellow }
        Write-Host "   Considere verificar se a captura foi bem-sucedida." -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Nenhum screenshot foi capturado" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎯 Próximos passos:" -ForegroundColor Cyan
Write-Host "   1. Verifique os screenshots em $OutputDir" -ForegroundColor Gray
Write-Host "   2. Execute o script de validação: melos run check:store_assets" -ForegroundColor Gray
Write-Host "   3. Se necessário, ajuste as posições de toque para seu dispositivo" -ForegroundColor Gray