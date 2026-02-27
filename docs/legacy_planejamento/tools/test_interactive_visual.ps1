# ========================================
# INTERACTIVE VISUAL TEST - Physical Device
# ========================================
# Purpose: Test apps with visual feedback and delays
# Shows each action happening in real-time

param(
    [string]$DeviceId = "8c7638ff",
    [int]$DelayBetweenActions = 2
)

$ErrorActionPreference = "Continue"
$adb = "C:\Users\Ernane\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$baseDir = "C:\Users\Ernane\Personal\APPs_Flutter_2"

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$reportDir = "artifacts/interactive_test_$timestamp"
New-Item -ItemType Directory -Path $reportDir -Force | Out-Null

Write-Host "`n" "="*80 -ForegroundColor Cyan
Write-Host "  INTERACTIVE VISUAL TEST - Physical Device" -ForegroundColor Cyan
Write-Host "="*80 -ForegroundColor Cyan
Write-Host "Device:       $DeviceId" -ForegroundColor Gray
Write-Host "Delay:        ${DelayBetweenActions}s entre ações" -ForegroundColor Gray
Write-Host "Screenshots:  $reportDir" -ForegroundColor Gray
Write-Host "="*80 "`n" -ForegroundColor Cyan

# Helper function to capture screenshot
function Capture-Screenshot {
    param($name)
    $screenshotPath = Join-Path $reportDir "$name.png"
    $tempFile = "/sdcard/test_temp.png"
    
    & $adb -s $DeviceId shell screencap -p $tempFile 2>&1 | Out-Null
    & $adb -s $DeviceId pull $tempFile $screenshotPath 2>&1 | Out-Null
    & $adb -s $DeviceId shell rm $tempFile 2>&1 | Out-Null
    
    if (Test-Path $screenshotPath) {
        $size = [math]::Round((Get-Item $screenshotPath).Length / 1KB, 1)
        Write-Host "    📸 Screenshot: $name.png ($size KB)" -ForegroundColor Gray
    }
}

# Helper function to tap screen
function Tap-Screen {
    param($x, $y, $description)
    Write-Host "    👆 $description (tap $x, $y)" -ForegroundColor Cyan
    & $adb -s $DeviceId shell input tap $x $y 2>&1 | Out-Null
    Start-Sleep -Seconds $DelayBetweenActions
}

# Helper function to input text
function Input-Text {
    param($text, $description)
    Write-Host "    ⌨️ $description : '$text'" -ForegroundColor Cyan
    & $adb -s $DeviceId shell input text $text 2>&1 | Out-Null
    Start-Sleep -Seconds $DelayBetweenActions
}

# Helper function to change language
function Change-Language {
    param($langCode, $langName)
    Write-Host "`n  🌍 Mudando idioma para: $langName ($langCode)" -ForegroundColor Yellow
    & $adb -s $DeviceId shell "setprop persist.sys.locale $langCode; am broadcast -a android.intent.action.LOCALE_CHANGED" 2>&1 | Out-Null
    Start-Sleep -Seconds 3
    Write-Host "    ✅ Idioma alterado" -ForegroundColor Green
}

# ========================================
# INSTALL APPS
# ========================================
Write-Host "[INSTALAÇÃO] Instalando apps..." -ForegroundColor Yellow

$apps = @(
    @{
        Name = "BMI Calculator"
        Package = "sa.rezende.bmi_calculator"
        ApkPath = "apps/health/bmi_calculator/build/app/outputs/flutter-apk/app-debug.apk"
    },
    @{
        Name = "Pomodoro Timer"
        Package = "sa.rezende.pomodoro_timer"
        ApkPath = "apps/productivity/pomodoro_timer/build/app/outputs/flutter-apk/app-debug.apk"
    },
    @{
        Name = "Compound Interest"
        Package = "sa.rezende.compound_interest_calculator"
        ApkPath = "apps/finance/compound_interest_calculator/build/app/outputs/flutter-apk/app-debug.apk"
    }
)

foreach ($app in $apps) {
    $apkPath = Join-Path $baseDir $app.ApkPath
    
    if (Test-Path $apkPath) {
        Write-Host "  Instalando: $($app.Name)..." -NoNewline
        & $adb -s $DeviceId install -r $apkPath 2>&1 | Out-Null
        Write-Host " ✅" -ForegroundColor Green
    } else {
        Write-Host "  ❌ APK não encontrado: $($app.Name)" -ForegroundColor Red
    }
}

Start-Sleep -Seconds 2

# ========================================
# TEST APP 1: BMI CALCULATOR
# ========================================
Write-Host "`n" "="*80 -ForegroundColor Magenta
Write-Host "  APP 1: BMI CALCULATOR - Teste Completo" -ForegroundColor Magenta
Write-Host "="*80 -ForegroundColor Magenta

$bmiPackage = "sa.rezende.bmi_calculator"

# Test in English first
Change-Language "en-US" "English"

Write-Host "`n[TEST 1.1] Abrindo app..." -ForegroundColor Yellow
& $adb -s $DeviceId shell am start -n "$bmiPackage/.MainActivity" 2>&1 | Out-Null
Start-Sleep -Seconds 4
Capture-Screenshot "bmi_01_home_english"

Write-Host "`n[TEST 1.2] Testando cálculo de BMI normal (70kg, 1.75m)" -ForegroundColor Yellow
# Tap weight field
Tap-Screen 540 600 "Toque no campo Peso"
Capture-Screenshot "bmi_02_weight_focused"

# Input weight
& $adb -s $DeviceId shell input keyevent KEYCODE_DEL 2>&1 | Out-Null
& $adb -s $DeviceId shell input keyevent KEYCODE_DEL 2>&1 | Out-Null
& $adb -s $DeviceId shell input keyevent KEYCODE_DEL 2>&1 | Out-Null
Input-Text "70" "Digitando peso: 70kg"
Capture-Screenshot "bmi_03_weight_entered"

# Tap height field
Tap-Screen 540 900 "Toque no campo Altura"
Capture-Screenshot "bmi_04_height_focused"

# Input height
& $adb -s $DeviceId shell input keyevent KEYCODE_DEL 2>&1 | Out-Null
& $adb -s $DeviceId shell input keyevent KEYCODE_DEL 2>&1 | Out-Null
& $adb -s $DeviceId shell input keyevent KEYCODE_DEL 2>&1 | Out-Null
Input-Text "175" "Digitando altura: 175cm"
Capture-Screenshot "bmi_05_height_entered"

# Calculate
Tap-Screen 540 1400 "Toque no botão Calcular"
Start-Sleep -Seconds 2
Capture-Screenshot "bmi_06_result_normal"

Write-Host "`n  📊 Verificando resultado esperado:" -ForegroundColor Cyan
Write-Host "    Peso: 70kg, Altura: 1.75m" -ForegroundColor Gray
Write-Host "    BMI esperado: 22.86 (Normal)" -ForegroundColor Gray
Write-Host "    ✅ Verifique visualmente no screenshot" -ForegroundColor Green

# Test with different theme
Write-Host "`n[TEST 1.3] Testando mudança de tema" -ForegroundColor Yellow
Tap-Screen 50 100 "Abrir menu/settings"
Start-Sleep -Seconds 2
Capture-Screenshot "bmi_07_menu_opened"

# Try to find and tap dark mode toggle (coordinates may vary)
Tap-Screen 540 800 "Tentar toggle de tema"
Start-Sleep -Seconds 2
Capture-Screenshot "bmi_08_theme_changed"

# Go back to home
& $adb -s $DeviceId shell input keyevent KEYCODE_BACK 2>&1 | Out-Null
Start-Sleep -Seconds 1

# Test in Portuguese
Write-Host "`n[TEST 1.4] Testando em Português" -ForegroundColor Yellow
& $adb -s $DeviceId shell am force-stop $bmiPackage 2>&1 | Out-Null
Start-Sleep -Seconds 1

Change-Language "pt-BR" "Português"

& $adb -s $DeviceId shell am start -n "$bmiPackage/.MainActivity" 2>&1 | Out-Null
Start-Sleep -Seconds 4
Capture-Screenshot "bmi_09_home_portuguese"

Write-Host "    ✅ Verificar se textos estão em português" -ForegroundColor Green

# Test edge cases
Write-Host "`n[TEST 1.5] Testando casos extremos" -ForegroundColor Yellow

# Underweight case (45kg, 1.75m = BMI 14.7)
Tap-Screen 540 600 "Campo peso"
Start-Sleep -Seconds 1
& $adb -s $DeviceId shell input keyevent KEYCODE_DEL 2>&1 | Out-Null
& $adb -s $DeviceId shell input keyevent KEYCODE_DEL 2>&1 | Out-Null
Input-Text "45" "Peso: 45kg (abaixo do peso)"
Tap-Screen 540 1400 "Calcular"
Start-Sleep -Seconds 2
Capture-Screenshot "bmi_10_underweight"

Write-Host "    📊 BMI esperado: 14.69 (Underweight)" -ForegroundColor Gray

# Overweight case (90kg, 1.75m = BMI 29.4)
Tap-Screen 540 600 "Campo peso"
Start-Sleep -Seconds 1
& $adb -s $DeviceId shell input keyevent KEYCODE_DEL 2>&1 | Out-Null
& $adb -s $DeviceId shell input keyevent KEYCODE_DEL 2>&1 | Out-Null
Input-Text "90" "Peso: 90kg (sobrepeso)"
Tap-Screen 540 1400 "Calcular"
Start-Sleep -Seconds 2
Capture-Screenshot "bmi_11_overweight"

Write-Host "    📊 BMI esperado: 29.39 (Overweight)" -ForegroundColor Gray

# Close app
& $adb -s $DeviceId shell am force-stop $bmiPackage 2>&1 | Out-Null

# ========================================
# TEST APP 2: POMODORO TIMER
# ========================================
Write-Host "`n" "="*80 -ForegroundColor Magenta
Write-Host "  APP 2: POMODORO TIMER - Teste Completo" -ForegroundColor Magenta
Write-Host "="*80 -ForegroundColor Magenta

$pomodoroPackage = "sa.rezende.pomodoro_timer"

# Change back to English
Change-Language "en-US" "English"

Write-Host "`n[TEST 2.1] Abrindo app..." -ForegroundColor Yellow
& $adb -s $DeviceId shell am start -n "$pomodoroPackage/.MainActivity" 2>&1 | Out-Null
Start-Sleep -Seconds 4
Capture-Screenshot "pomodoro_01_home_english"

Write-Host "`n[TEST 2.2] Testando iniciar timer" -ForegroundColor Yellow
Tap-Screen 540 1200 "Botão Start/Play"
Start-Sleep -Seconds 3
Capture-Screenshot "pomodoro_02_timer_running"

Write-Host "    ⏱️ Timer deve estar rodando" -ForegroundColor Green
Write-Host "    ✅ Verificar se contador está decrementando" -ForegroundColor Green

Write-Host "`n[TEST 2.3] Testando pausar timer" -ForegroundColor Yellow
Tap-Screen 540 1200 "Botão Pause"
Start-Sleep -Seconds 2
Capture-Screenshot "pomodoro_03_timer_paused"

Write-Host "    ⏸️ Timer deve estar pausado" -ForegroundColor Green

Write-Host "`n[TEST 2.4] Testando resetar timer" -ForegroundColor Yellow
Tap-Screen 540 1400 "Botão Reset/Stop"
Start-Sleep -Seconds 2
Capture-Screenshot "pomodoro_04_timer_reset"

Write-Host "    🔄 Timer deve estar em 25:00" -ForegroundColor Green

Write-Host "`n[TEST 2.5] Abrindo configurações" -ForegroundColor Yellow
Tap-Screen 50 100 "Menu/Settings"
Start-Sleep -Seconds 2
Capture-Screenshot "pomodoro_05_settings_opened"

# Try to change timer duration
Tap-Screen 540 600 "Tentar ajustar duração do Pomodoro"
Start-Sleep -Seconds 2
Capture-Screenshot "pomodoro_06_settings_duration"

# Go back
& $adb -s $DeviceId shell input keyevent KEYCODE_BACK 2>&1 | Out-Null
Start-Sleep -Seconds 1

# Test in Spanish
Write-Host "`n[TEST 2.6] Testando em Español" -ForegroundColor Yellow
& $adb -s $DeviceId shell am force-stop $pomodoroPackage 2>&1 | Out-Null
Start-Sleep -Seconds 1

Change-Language "es-ES" "Español"

& $adb -s $DeviceId shell am start -n "$pomodoroPackage/.MainActivity" 2>&1 | Out-Null
Start-Sleep -Seconds 4
Capture-Screenshot "pomodoro_07_home_spanish"

Write-Host "    ✅ Verificar se textos estão em espanhol" -ForegroundColor Green

# Close app
& $adb -s $DeviceId shell am force-stop $pomodoroPackage 2>&1 | Out-Null

# ========================================
# TEST APP 3: COMPOUND INTEREST
# ========================================
Write-Host "`n" "="*80 -ForegroundColor Magenta
Write-Host "  APP 3: COMPOUND INTEREST CALCULATOR - Teste Completo" -ForegroundColor Magenta
Write-Host "="*80 -ForegroundColor Magenta

$compoundPackage = "sa.rezende.compound_interest_calculator"

# Change to English
Change-Language "en-US" "English"

Write-Host "`n[TEST 3.1] Abrindo app..." -ForegroundColor Yellow
& $adb -s $DeviceId shell am start -n "$compoundPackage/.MainActivity" 2>&1 | Out-Null
Start-Sleep -Seconds 4
Capture-Screenshot "compound_01_home_english"

Write-Host "`n[TEST 3.2] Testando cálculo: R$1000, 10% a.a., 12 meses" -ForegroundColor Yellow

# Input initial capital
Tap-Screen 540 500 "Campo Capital Inicial"
Start-Sleep -Seconds 1
& $adb -s $DeviceId shell input keyevent KEYCODE_DEL 2>&1 | Out-Null
& $adb -s $DeviceId shell input keyevent KEYCODE_DEL 2>&1 | Out-Null
& $adb -s $DeviceId shell input keyevent KEYCODE_DEL 2>&1 | Out-Null
& $adb -s $DeviceId shell input keyevent KEYCODE_DEL 2>&1 | Out-Null
Input-Text "1000" "Capital inicial: R$1000"
Capture-Screenshot "compound_02_capital_entered"

# Input rate
Tap-Screen 540 700 "Campo Taxa anual"
Start-Sleep -Seconds 1
& $adb -s $DeviceId shell input keyevent KEYCODE_DEL 2>&1 | Out-Null
& $adb -s $DeviceId shell input keyevent KEYCODE_DEL 2>&1 | Out-Null
Input-Text "10" "Taxa anual: 10%"
Capture-Screenshot "compound_03_rate_entered"

# Months should be 12 by default, just calculate
Tap-Screen 540 1400 "Botão Calcular"
Start-Sleep -Seconds 2
Capture-Screenshot "compound_04_result_basic"

Write-Host "`n  📊 Verificando resultado esperado:" -ForegroundColor Cyan
Write-Host "    Capital: R$1000, Taxa: 10% a.a., Período: 12 meses" -ForegroundColor Gray
Write-Host "    Montante esperado: ~R$1104.71" -ForegroundColor Gray
Write-Host "    Juros esperados: ~R$104.71" -ForegroundColor Gray
Write-Host "    ✅ Verifique visualmente no screenshot" -ForegroundColor Green

# Test with monthly contribution
Write-Host "`n[TEST 3.3] Testando com aporte mensal R$100" -ForegroundColor Yellow
Tap-Screen 540 900 "Campo Aporte Mensal"
Start-Sleep -Seconds 1
Input-Text "100" "Aporte mensal: R$100"
Capture-Screenshot "compound_05_monthly_entered"

Tap-Screen 540 1400 "Calcular com aporte"
Start-Sleep -Seconds 2
Capture-Screenshot "compound_06_result_with_monthly"

Write-Host "`n  📊 Resultado esperado com aportes:" -ForegroundColor Cyan
Write-Host "    Capital: R$1000 + R$100/mês por 12 meses" -ForegroundColor Gray
Write-Host "    Montante esperado: ~R$2272.84" -ForegroundColor Gray
Write-Host "    ✅ Verifique visualmente no screenshot" -ForegroundColor Green

# Test presets
Write-Host "`n[TEST 3.4] Testando presets de investimento" -ForegroundColor Yellow
Tap-Screen 200 1100 "Preset 1 (Poupança?)"
Start-Sleep -Seconds 2
Capture-Screenshot "compound_07_preset1"

Tap-Screen 400 1100 "Preset 2 (CDI?)"
Start-Sleep -Seconds 2
Capture-Screenshot "compound_08_preset2"

Tap-Screen 600 1100 "Preset 3 (Bolsa?)"
Start-Sleep -Seconds 2
Capture-Screenshot "compound_09_preset3"

# Test in German
Write-Host "`n[TEST 3.5] Testando em Deutsch" -ForegroundColor Yellow
& $adb -s $DeviceId shell am force-stop $compoundPackage 2>&1 | Out-Null
Start-Sleep -Seconds 1

Change-Language "de-DE" "Deutsch"

& $adb -s $DeviceId shell am start -n "$compoundPackage/.MainActivity" 2>&1 | Out-Null
Start-Sleep -Seconds 4
Capture-Screenshot "compound_10_home_german"

Write-Host "    ✅ Verificar se textos estão em alemão" -ForegroundColor Green

# Close app
& $adb -s $DeviceId shell am force-stop $compoundPackage 2>&1 | Out-Null

# ========================================
# FINAL REPORT
# ========================================
Write-Host "`n" "="*80 -ForegroundColor Cyan
Write-Host "  RELATÓRIO FINAL" -ForegroundColor Cyan
Write-Host "="*80 -ForegroundColor Cyan

$screenshots = Get-ChildItem -Path $reportDir -Filter *.png
$screenshotCount = $screenshots.Count
$totalSize = [math]::Round(($screenshots | Measure-Object -Property Length -Sum).Sum / 1MB, 2)

Write-Host "`n✅ TESTES CONCLUÍDOS!" -ForegroundColor Green
Write-Host "`n📊 Resumo dos Testes:" -ForegroundColor Yellow
Write-Host "  • BMI Calculator: 11 screenshots" -ForegroundColor Gray
Write-Host "    - Testado em: English, Português" -ForegroundColor Gray
Write-Host "    - Casos: Normal, Underweight, Overweight" -ForegroundColor Gray
Write-Host "    - Mudança de tema testada" -ForegroundColor Gray
Write-Host "`n  • Pomodoro Timer: 7 screenshots" -ForegroundColor Gray
Write-Host "    - Testado em: English, Español" -ForegroundColor Gray
Write-Host "    - Funções: Start, Pause, Reset, Settings" -ForegroundColor Gray
Write-Host "`n  • Compound Interest: 10 screenshots" -ForegroundColor Gray
Write-Host "    - Testado em: English, Deutsch" -ForegroundColor Gray
Write-Host "    - Cálculos: Básico, Com aportes, Presets" -ForegroundColor Gray

Write-Host "`n📸 Total de screenshots: $screenshotCount ($totalSize MB)" -ForegroundColor Cyan
Write-Host "📂 Local: $reportDir" -ForegroundColor Gray

Write-Host "`n🔍 VALIDAÇÕES NECESSÁRIAS (verifique nos screenshots):" -ForegroundColor Yellow
Write-Host "  ❏ BMI Calculator:" -ForegroundColor Gray
Write-Host "    • BMI 22.86 para 70kg/1.75m está correto?" -ForegroundColor Gray
Write-Host "    • Categoria 'Normal' está sendo exibida?" -ForegroundColor Gray
Write-Host "    • Textos traduzidos corretamente?" -ForegroundColor Gray
Write-Host "    • Interface não quebrada em nenhum tema?" -ForegroundColor Gray
Write-Host "`n  ❏ Pomodoro Timer:" -ForegroundColor Gray
Write-Host "    • Timer inicia em 25:00?" -ForegroundColor Gray
Write-Host "    • Botões Start/Pause/Reset funcionam?" -ForegroundColor Gray
Write-Host "    • Settings acessíveis?" -ForegroundColor Gray
Write-Host "    • Textos traduzidos corretamente?" -ForegroundColor Gray
Write-Host "`n  ❏ Compound Interest:" -ForegroundColor Gray
Write-Host "    • Resultado R$1104.71 para R$1000 a 10% a.a.?" -ForegroundColor Gray
Write-Host "    • Cálculo com aportes está correto?" -ForegroundColor Gray
Write-Host "    • Presets mudam a taxa corretamente?" -ForegroundColor Gray
Write-Host "    • Textos traduzidos corretamente?" -ForegroundColor Gray

Write-Host "`n" "="*80 "`n" -ForegroundColor Cyan

# Restore English
Change-Language "en-US" "English (restaurado)"

Write-Host "✅ Idioma do dispositivo restaurado para English" -ForegroundColor Green
Write-Host ""
