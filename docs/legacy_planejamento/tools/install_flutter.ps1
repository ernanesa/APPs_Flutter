# ============================================================================
# INSTALADOR FLUTTER SDK - BEAST MODE
# ============================================================================

Write-Host "`n🚀 PASSO 1/3: Instalando Flutter SDK...`n" -ForegroundColor Cyan

$flutterPath = "C:\dev\flutter"
$flutterZip = "$env:TEMP\flutter.zip"
$flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.5-stable.zip"

# Criar diretório C:\dev se não existir
if (!(Test-Path "C:\dev")) {
    Write-Host "📁 Criando diretório C:\dev..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path "C:\dev" -Force | Out-Null
}

# Verificar se Flutter já existe
if (Test-Path "$flutterPath\bin\flutter.bat") {
    Write-Host "✅ Flutter SDK já instalado em: $flutterPath" -ForegroundColor Green
    & "$flutterPath\bin\flutter.bat" --version
    exit 0
}

# Baixar Flutter SDK
Write-Host "📥 Baixando Flutter SDK (pode levar 5-10 minutos)..." -ForegroundColor Yellow
Write-Host "    URL: $flutterUrl" -ForegroundColor Gray

try {
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $flutterUrl -OutFile $flutterZip -UseBasicParsing -TimeoutSec 600
    $ProgressPreference = 'Continue'
    
    $size = [math]::Round((Get-Item $flutterZip).Length / 1MB, 2)
    Write-Host "✅ Download completo: $size MB" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro ao baixar Flutter SDK: $_" -ForegroundColor Red
    exit 1
}

# Extrair Flutter SDK
Write-Host "`n📦 Extraindo Flutter SDK para C:\dev..." -ForegroundColor Yellow

try {
    Expand-Archive -Path $flutterZip -DestinationPath "C:\dev" -Force
    Remove-Item $flutterZip -Force
    Write-Host "✅ Extração completa!" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro ao extrair Flutter SDK: $_" -ForegroundColor Red
    exit 1
}

# Verificar instalação
Write-Host "`n🔍 Verificando instalação..." -ForegroundColor Cyan

if (Test-Path "$flutterPath\bin\flutter.bat") {
    Write-Host "✅ Flutter SDK instalado com sucesso em: $flutterPath`n" -ForegroundColor Green
    
    # Executar flutter doctor (primeira execução baixa Dart SDK)
    Write-Host "🏥 Executando flutter doctor (primeira execução)...`n" -ForegroundColor Yellow
    & "$flutterPath\bin\flutter.bat" doctor
    
    Write-Host "`n✅ FLUTTER SDK PRONTO PARA USO!`n" -ForegroundColor Green
    Write-Host "💡 Adicione ao PATH: $flutterPath\bin" -ForegroundColor Cyan
} else {
    Write-Host "❌ Falha na instalação do Flutter SDK" -ForegroundColor Red
    exit 1
}
