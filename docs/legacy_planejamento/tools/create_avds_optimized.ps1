# ========================================
# SCRIPT: Criar 4 AVDs Otimizados para RTX 3050 6GB
# Intel Core 7 240H (20 threads) + 32GB DDR5
# ========================================

$androidSdk = "C:\Users\Ernane\AppData\Local\Android\Sdk"
$sdkmanager = "$androidSdk\cmdline-tools\latest\bin\sdkmanager.bat"
$avdmanager = "$androidSdk\cmdline-tools\latest\bin\avdmanager.bat"

Write-Host "🚀 CRIAÇÃO DE AVDs OTIMIZADOS - RTX 3050 6GB" -ForegroundColor Cyan
Write-Host ("="*70) -ForegroundColor Cyan

# Verificar se sdkmanager existe
if (-not (Test-Path $sdkmanager)) {
    Write-Host "❌ SDKManager não encontrado em $sdkmanager" -ForegroundColor Red
    Write-Host "💡 Instale Android Command Line Tools primeiro" -ForegroundColor Yellow
    exit 1
}

# 1. Instalar System Images
Write-Host "`n📦 PASSO 1: Instalando System Images..." -ForegroundColor Yellow

$images = @(
    "system-images;android-35;google_apis;x86_64",
    "system-images;android-34;google_apis;x86_64"
)

foreach ($image in $images) {
    Write-Host "   Instalando $image..." -ForegroundColor Gray
    & $sdkmanager --install $image --sdk_root=$androidSdk
}

Write-Host "✅ System Images instalados!" -ForegroundColor Green

# 2. Aceitar Licenças
Write-Host "`n📜 PASSO 2: Aceitando licenças..." -ForegroundColor Yellow
echo "y" | & $sdkmanager --licenses --sdk_root=$androidSdk
Write-Host "✅ Licenças aceitas!" -ForegroundColor Green

# 3. Criar 4 AVDs
Write-Host "`n🔨 PASSO 3: Criando 4 AVDs otimizados..." -ForegroundColor Yellow

$avds = @(
    @{Name="Pixel7_API35_Primary"; API=35; Desc="Primary - Screenshots"},
    @{Name="Pixel7_API35_Worker1"; API=35; Desc="Worker 1 - Parallel Tests"},
    @{Name="Pixel7_API35_Worker2"; API=35; Desc="Worker 2 - Parallel Tests"},
    @{Name="Pixel7_API35_Worker3"; API=35; Desc="Worker 3 - Parallel Tests"}
)

foreach ($avd in $avds) {
    Write-Host "`n   Criando $($avd.Name) ($($avd.Desc))..." -ForegroundColor Cyan
    
    & $avdmanager create avd `
        --name $avd.Name `
        --package "system-images;android-$($avd.API);google_apis;x86_64" `
        --device "pixel_7" `
        --force
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✅ $($avd.Name) criado!" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Erro ao criar $($avd.Name)" -ForegroundColor Red
    }
}

# 4. Configurar AVDs com GPU RTX 3050
Write-Host "`n⚙️  PASSO 4: Configurando GPU Acceleration (RTX 3050 6GB)..." -ForegroundColor Yellow

$avdDir = "$env:USERPROFILE\.android\avd"

foreach ($avd in $avds) {
    $configFile = "$avdDir\$($avd.Name).avd\config.ini"
    
    if (Test-Path $configFile) {
        Write-Host "   Configurando $($avd.Name)..." -ForegroundColor Gray
        
        # Adicionar configurações otimizadas
        Add-Content $configFile "`n# RTX 3050 6GB Optimization"
        Add-Content $configFile "hw.gpu.enabled=yes"
        Add-Content $configFile "hw.gpu.mode=host"
        Add-Content $configFile "hw.ramSize=7168"
        Add-Content $configFile "hw.cpu.ncore=6"
        Add-Content $configFile "hw.cpu.arch=x86_64"
        Add-Content $configFile "disk.dataPartition.size=10G"
        Add-Content $configFile "fastboot.forceColdBoot=yes"
        Add-Content $configFile "hw.keyboard=yes"
        Add-Content $configFile "hw.mainKeys=yes"
        
        Write-Host "   ✅ $($avd.Name) configurado!" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Config não encontrado: $configFile" -ForegroundColor Yellow
    }
}

# Resumo
Write-Host "`n" + ("="*70) -ForegroundColor Cyan
Write-Host "🎉 AVDs CRIADOS COM SUCESSO!" -ForegroundColor Green
Write-Host "`n📊 Configuração:" -ForegroundColor Cyan
Write-Host "   Quantidade:     4 AVDs" -ForegroundColor Gray
Write-Host "   GPU:            RTX 3050 6GB (host mode)" -ForegroundColor Gray
Write-Host "   RAM por AVD:    7 GB (28 GB total)" -ForegroundColor Gray
Write-Host "   CPU por AVD:    6 P-cores" -ForegroundColor Gray
Write-Host "   Storage:        10 GB cada" -ForegroundColor Gray

Write-Host "`n💡 Próximo Passo:" -ForegroundColor Yellow
Write-Host "   Execute: pwsh tools/start_emulators_parallel.ps1" -ForegroundColor Cyan
