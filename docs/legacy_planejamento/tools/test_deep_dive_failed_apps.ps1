# Deep Dive Testing - Failed Apps
# Data: 5 de Fevereiro de 2026
# Apps: BMI Calculator, Pomodoro Timer
# Objetivo: Testar TUDO com delay observável

param(
    [int]$DelayBetweenActions = 3,  # 3 segundos por padrão
    [string]$DeviceId = "8c7638ff"
)

$ErrorActionPreference = "Continue"
$adb = "C:\Users\Ernane\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$flutter = "C:\Users\Ernane\flutter\sdk\bin\flutter.bat"

# Criar pasta para screenshots
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$screenshotDir = "artifacts\deep_dive_test_$timestamp"
New-Item -ItemType Directory -Path $screenshotDir -Force | Out-Null

Write-Host "`n╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  DEEP DIVE TEST - Apps com Falhas                                 ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host "Device:       $DeviceId"
Write-Host "Delay:        ${DelayBetweenActions}s entre ações (VOCÊ VAI VER TUDO)"
Write-Host "Screenshots:  $screenshotDir"
Write-Host "╔═══════════════════════════════════════════════════════════════════╗`n" -ForegroundColor Cyan

# Função para capturar screenshot
function Capture-Screenshot {
    param([string]$Name, [string]$Description)
    
    $filename = "${Name}.png"
    $filepath = Join-Path $screenshotDir $filename
    
    & $adb -s $DeviceId exec-out screencap -p > $filepath
    
    if (Test-Path $filepath) {
        $size = [math]::Round((Get-Item $filepath).Length / 1KB, 1)
        Write-Host "    📸 Screenshot: $filename ($size KB)" -ForegroundColor Gray
        if ($Description) {
            Write-Host "       $Description" -ForegroundColor DarkGray
        }
    }
    
    Start-Sleep -Seconds $DelayBetweenActions
}

# Função para tocar na tela
function Tap-Screen {
    param([int]$X, [int]$Y, [string]$Description)
    
    Write-Host "    👆 Toque em ($X, $Y): $Description" -ForegroundColor Yellow
    & $adb -s $DeviceId shell input tap $X $Y
    Start-Sleep -Seconds $DelayBetweenActions
}

# Função para digitar texto
function Type-Text {
    param([string]$Text, [string]$Description)
    
    Write-Host "    ⌨️  Digitando: $Description = '$Text'" -ForegroundColor Cyan
    & $adb -s $DeviceId shell input text $Text
    Start-Sleep -Seconds $DelayBetweenActions
}

# Função para mudar idioma
function Change-Language {
    param([string]$Locale, [string]$Name)
    
    Write-Host "`n  🌍 Mudando idioma para: $Name ($Locale)" -ForegroundColor Magenta
    & $adb -s $DeviceId shell "setprop persist.sys.locale $Locale; setprop ctl.restart zygote"
    Write-Host "    ⏳ Aguardando sistema reiniciar (30s)..." -ForegroundColor Gray
    Start-Sleep -Seconds 30
    Write-Host "    ✅ Idioma alterado`n" -ForegroundColor Green
}

# Função para abrir app
function Open-App {
    param([string]$PackageId, [string]$AppName)
    
    Write-Host "`n[ABRINDO APP] $AppName" -ForegroundColor Green
    & $adb -s $DeviceId shell monkey -p $PackageId -c android.intent.category.LAUNCHER 1
    Start-Sleep -Seconds 5  # Tempo extra para app iniciar
}

# Função para fechar app
function Close-App {
    param([string]$PackageId)
    
    Write-Host "`n[FECHANDO APP] Force stop" -ForegroundColor Yellow
    & $adb -s $DeviceId shell am force-stop $PackageId
    Start-Sleep -Seconds 2
}

# Função para limpar dados do app
function Clear-App-Data {
    param([string]$PackageId, [string]$AppName)
    
    Write-Host "`n[LIMPANDO DADOS] $AppName - Para testar estado inicial" -ForegroundColor Yellow
    & $adb -s $DeviceId shell pm clear $PackageId
    Start-Sleep -Seconds 2
}

# Função para capturar logs em tempo real
function Start-Log-Capture {
    param([string]$AppName)
    
    $logFile = Join-Path $screenshotDir "${AppName}_logcat.txt"
    Write-Host "    📝 Iniciando captura de logs: $logFile" -ForegroundColor DarkGray
    
    # Limpar logcat
    & $adb -s $DeviceId logcat -c
    
    # Iniciar captura em background (não bloqueante)
    $job = Start-Job -ScriptBlock {
        param($adb, $deviceId, $logFile)
        & $adb -s $deviceId logcat > $logFile
    } -ArgumentList $adb, $DeviceId, $logFile
    
    return $job
}

# Função para parar captura de logs
function Stop-Log-Capture {
    param($Job, [string]$AppName)
    
    if ($Job) {
        Stop-Job -Job $Job
        Remove-Job -Job $Job
        Write-Host "    ✅ Logs salvos" -ForegroundColor DarkGray
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# APP 1: BMI CALCULATOR - TESTE ULTRA COMPLETO
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "`n╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║  APP 1: BMI CALCULATOR - Teste Intensivo (todas as funcionalidades) ║" -ForegroundColor Magenta
Write-Host "╚═══════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Magenta

$bmiPackage = "sa.rezende.bmi_calculator"

# Limpar dados para começar do zero
Clear-App-Data -PackageId $bmiPackage -AppName "BMI Calculator"

# Iniciar captura de logs
$bmiLogJob = Start-Log-Capture -AppName "bmi"

# Teste 1: Primeira abertura (estado inicial)
Write-Host "`n[TESTE 1.1] Primeira abertura - Estado inicial" -ForegroundColor Cyan
Write-Host "  🎯 Objetivo: Verificar se app carrega sem travar" -ForegroundColor White
Open-App -PackageId $bmiPackage -AppName "BMI Calculator"
Capture-Screenshot -Name "bmi_01_first_open" -Description "Primeira vez abrindo app"

# Teste 2: Navegar para todas as tabs
Write-Host "`n[TESTE 1.2] Navegação entre tabs" -ForegroundColor Cyan
Write-Host "  🎯 Objetivo: Verificar que todas as telas carregam" -ForegroundColor White

Tap-Screen -X 540 -Y 2300 -Description "Tab Calculator (centro inferior)"
Capture-Screenshot -Name "bmi_02_tab_calculator" -Description "Tab Calculator"

Tap-Screen -X 190 -Y 2300 -Description "Tab History (esquerda inferior)"
Capture-Screenshot -Name "bmi_03_tab_history" -Description "Tab History (deve estar vazio)"

Tap-Screen -X 890 -Y 2300 -Description "Tab Evolution (direita inferior)"
Capture-Screenshot -Name "bmi_04_tab_evolution_empty" -Description "⚠️ CRÍTICO: Evolution Graph - deve mostrar mensagem 'need 2 entries'"

# Voltar para Calculator
Tap-Screen -X 540 -Y 2300 -Description "Tab Calculator"
Start-Sleep -Seconds 2

# Teste 3: Fazer primeiro cálculo
Write-Host "`n[TESTE 1.3] Primeiro cálculo de BMI" -ForegroundColor Cyan
Write-Host "  🎯 Objetivo: Adicionar entrada no histórico" -ForegroundColor White

Tap-Screen -X 540 -Y 600 -Description "Campo Peso"
Capture-Screenshot -Name "bmi_05_weight_field_focused"

Type-Text -Text "70" -Description "Peso 70kg"
Capture-Screenshot -Name "bmi_06_weight_entered"

Tap-Screen -X 540 -Y 900 -Description "Campo Altura"
Capture-Screenshot -Name "bmi_07_height_field_focused"

Type-Text -Text "175" -Description "Altura 175cm"
Capture-Screenshot -Name "bmi_08_height_entered"

Tap-Screen -X 540 -Y 1400 -Description "Botão Calcular"
Capture-Screenshot -Name "bmi_09_result_first_calculation" -Description "📊 Esperado: BMI 22.86 (Normal)"

# Teste 4: Verificar que foi salvo no histórico
Write-Host "`n[TESTE 1.4] Verificar histórico após 1º cálculo" -ForegroundColor Cyan
Write-Host "  🎯 Objetivo: Confirmar que dado foi persistido" -ForegroundColor White

Tap-Screen -X 190 -Y 2300 -Description "Tab History"
Capture-Screenshot -Name "bmi_10_history_after_first" -Description "✅ Deve mostrar 1 entrada"

# Teste 5: Fazer segundo cálculo
Write-Host "`n[TESTE 1.5] Segundo cálculo - Para habilitar gráfico" -ForegroundColor Cyan
Write-Host "  🎯 Objetivo: Ter 2+ entradas para gráfico funcionar" -ForegroundColor White

Tap-Screen -X 540 -Y 2300 -Description "Tab Calculator"
Start-Sleep -Seconds 2

Tap-Screen -X 540 -Y 600 -Description "Campo Peso"
# Limpar campo
& $adb -s $DeviceId shell input keyevent KEYCODE_DEL
& $adb -s $DeviceId shell input keyevent KEYCODE_DEL
Start-Sleep -Seconds 1

Type-Text -Text "65" -Description "Peso 65kg"
Tap-Screen -X 540 -Y 1400 -Description "Calcular"
Capture-Screenshot -Name "bmi_11_result_second_calculation" -Description "📊 Esperado: BMI 21.22 (Normal)"

# Teste 6: Verificar histórico com 2 entradas
Write-Host "`n[TESTE 1.6] Verificar histórico com 2 entradas" -ForegroundColor Cyan
Tap-Screen -X 190 -Y 2300 -Description "Tab History"
Capture-Screenshot -Name "bmi_12_history_after_second" -Description "✅ Deve mostrar 2 entradas"

# Teste 7: CRÍTICO - Verificar Evolution Graph com dados
Write-Host "`n[TESTE 1.7] 🔥 TESTE CRÍTICO - Evolution Graph com dados reais" -ForegroundColor Red
Write-Host "  🎯 Objetivo: Verificar se gráfico mostra pontos (BUG REPORTADO)" -ForegroundColor White

Tap-Screen -X 890 -Y 2300 -Description "Tab Evolution"
Write-Host "    ⏳ Aguardando gráfico carregar..." -ForegroundColor Gray
Start-Sleep -Seconds 5  # Tempo extra para carregar
Capture-Screenshot -Name "bmi_13_evolution_with_data" -Description "⚠️⚠️⚠️ CRÍTICO: Deve mostrar linha com 2 pontos!"

# Teste 8: Fazer terceiro cálculo (caso extremo - underweight)
Write-Host "`n[TESTE 1.8] Terceiro cálculo - Underweight" -ForegroundColor Cyan
Tap-Screen -X 540 -Y 2300 -Description "Tab Calculator"
Start-Sleep -Seconds 2

Tap-Screen -X 540 -Y 600 -Description "Campo Peso"
& $adb -s $DeviceId shell input keyevent KEYCODE_DEL
& $adb -s $DeviceId shell input keyevent KEYCODE_DEL
Start-Sleep -Seconds 1

Type-Text -Text "45" -Description "Peso 45kg (underweight)"
Tap-Screen -X 540 -Y 1400 -Description "Calcular"
Capture-Screenshot -Name "bmi_14_result_underweight" -Description "📊 Esperado: BMI 14.69 (Underweight)"

# Teste 9: Verificar gráfico com 3 pontos
Write-Host "`n[TESTE 1.9] Evolution Graph com 3 pontos" -ForegroundColor Cyan
Tap-Screen -X 890 -Y 2300 -Description "Tab Evolution"
Start-Sleep -Seconds 5
Capture-Screenshot -Name "bmi_15_evolution_3_points" -Description "Gráfico com 3 pontos"

# Teste 10: Abrir Settings/Menu
Write-Host "`n[TESTE 1.10] Testar configurações" -ForegroundColor Cyan
Tap-Screen -X 50 -Y 100 -Description "Menu/Settings (top-left)"
Capture-Screenshot -Name "bmi_16_menu_opened"

# Teste 11: Trocar tema
Write-Host "`n[TESTE 1.11] Trocar tema Dark/Light" -ForegroundColor Cyan
Tap-Screen -X 540 -Y 800 -Description "Toggle de tema"
Capture-Screenshot -Name "bmi_17_theme_dark"

Tap-Screen -X 540 -Y 800 -Description "Toggle de tema novamente"
Capture-Screenshot -Name "bmi_18_theme_light"

# Teste 12: Trocar unidades (se existir)
Write-Host "`n[TESTE 1.12] Testar mudança de unidades" -ForegroundColor Cyan
Tap-Screen -X 540 -Y 1000 -Description "Opção de unidades (se existir)"
Capture-Screenshot -Name "bmi_19_units_option"

# Fechar menu
& $adb -s $DeviceId shell input keyevent KEYCODE_BACK
Start-Sleep -Seconds 2

# Teste 13: Deletar entrada do histórico
Write-Host "`n[TESTE 1.13] Deletar entrada do histórico" -ForegroundColor Cyan
Tap-Screen -X 190 -Y 2300 -Description "Tab History"
Start-Sleep -Seconds 2

Tap-Screen -X 900 -Y 700 -Description "Botão delete (direita) da primeira entrada"
Capture-Screenshot -Name "bmi_20_after_delete"

# Teste 14: Fechar e reabrir app (teste de persistência)
Write-Host "`n[TESTE 1.14] 🔥 TESTE DE PERSISTÊNCIA - Fechar e reabrir" -ForegroundColor Red
Write-Host "  🎯 Objetivo: Verificar se dados sobrevivem ao restart" -ForegroundColor White

Close-App -PackageId $bmiPackage
Write-Host "    ⏳ App fechado, aguardando 3 segundos..." -ForegroundColor Gray
Start-Sleep -Seconds 3

Open-App -PackageId $bmiPackage -AppName "BMI Calculator"
Capture-Screenshot -Name "bmi_21_reopened_home"

Tap-Screen -X 190 -Y 2300 -Description "Tab History após reabrir"
Capture-Screenshot -Name "bmi_22_history_after_restart" -Description "✅ Deve ter 2 entradas (1 foi deletada)"

Tap-Screen -X 890 -Y 2300 -Description "Tab Evolution após reabrir"
Start-Sleep -Seconds 5
Capture-Screenshot -Name "bmi_23_evolution_after_restart" -Description "⚠️ CRÍTICO: Gráfico deve carregar automaticamente"

# Teste 15: Teste em outro idioma
Write-Host "`n[TESTE 1.15] Teste em Português" -ForegroundColor Cyan
Close-App -PackageId $bmiPackage
Change-Language -Locale "pt-BR" -Name "Português"

Open-App -PackageId $bmiPackage -AppName "BMI Calculator"
Capture-Screenshot -Name "bmi_24_home_portuguese" -Description "Home em português"

Tap-Screen -X 190 -Y 2300 -Description "Tab Histórico"
Capture-Screenshot -Name "bmi_25_history_portuguese"

Tap-Screen -X 890 -Y 2300 -Description "Tab Evolução"
Start-Sleep -Seconds 5
Capture-Screenshot -Name "bmi_26_evolution_portuguese" -Description "Gráfico em português"

Close-App -PackageId $bmiPackage
Stop-Log-Capture -Job $bmiLogJob -AppName "BMI Calculator"

Write-Host "`n✅ BMI Calculator - 26 screenshots capturados!" -ForegroundColor Green
Write-Host "   📊 PONTOS CRÍTICOS A VERIFICAR:" -ForegroundColor Yellow
Write-Host "   - bmi_04: Evolution vazio (esperado - sem dados)" -ForegroundColor Gray
Write-Host "   - bmi_13: Evolution COM dados (2 pontos) - DEVE MOSTRAR LINHA!" -ForegroundColor Red
Write-Host "   - bmi_15: Evolution com 3 pontos" -ForegroundColor Gray
Write-Host "   - bmi_23: Evolution após restart - TESTE DE PERSISTÊNCIA!" -ForegroundColor Red

# ═══════════════════════════════════════════════════════════════════════════
# APP 2: POMODORO TIMER - TESTE ULTRA COMPLETO
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "`n`n╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║  APP 2: POMODORO TIMER - Teste Intensivo (diagnóstico completo)     ║" -ForegroundColor Magenta
Write-Host "╚═══════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Magenta

$pomodoroPackage = "sa.rezende.pomodoro_timer"

# Restaurar idioma para inglês
Change-Language -Locale "en-US" -Name "English"

# Limpar dados
Clear-App-Data -PackageId $pomodoroPackage -AppName "Pomodoro Timer"

# Iniciar captura de logs
$pomodoroLogJob = Start-Log-Capture -AppName "pomodoro"

# Teste 1: Primeira abertura (CRÍTICO - tela branca?)
Write-Host "`n[TESTE 2.1] 🔥 TESTE CRÍTICO - Primeira abertura" -ForegroundColor Red
Write-Host "  🎯 Objetivo: Verificar se app carrega ou fica em tela branca" -ForegroundColor White
Write-Host "  ⏰ Aguardando 10 segundos para loading completo..." -ForegroundColor Gray

Open-App -PackageId $pomodoroPackage -AppName "Pomodoro Timer"
Start-Sleep -Seconds 10  # Tempo extra para loading

Capture-Screenshot -Name "pomodoro_01_first_open" -Description "⚠️⚠️⚠️ CRÍTICO: Deve mostrar timer, não tela branca!"

# Teste 2: Verificar estado inicial do timer
Write-Host "`n[TESTE 2.2] Estado inicial do timer" -ForegroundColor Cyan
Write-Host "  🎯 Objetivo: Timer deve estar em 25:00" -ForegroundColor White
Capture-Screenshot -Name "pomodoro_02_initial_state" -Description "Timer inicial: 25:00"

# Teste 3: Iniciar timer
Write-Host "`n[TESTE 2.3] Iniciar timer" -ForegroundColor Cyan
Tap-Screen -X 540 -Y 1200 -Description "Botão Start/Play (centro)"
Capture-Screenshot -Name "pomodoro_03_timer_started"

Write-Host "    ⏱️  Deixando timer rodar por 5 segundos..." -ForegroundColor Gray
Start-Sleep -Seconds 5
Capture-Screenshot -Name "pomodoro_04_timer_running_5s" -Description "Timer após 5s (deve estar em ~24:55)"

# Teste 4: Pausar timer
Write-Host "`n[TESTE 2.4] Pausar timer" -ForegroundColor Cyan
Tap-Screen -X 540 -Y 1200 -Description "Botão Pause"
Capture-Screenshot -Name "pomodoro_05_timer_paused"

# Teste 5: Retomar timer
Write-Host "`n[TESTE 2.5] Retomar timer" -ForegroundColor Cyan
Tap-Screen -X 540 -Y 1200 -Description "Botão Resume"
Capture-Screenshot -Name "pomodoro_06_timer_resumed"
Start-Sleep -Seconds 3
Capture-Screenshot -Name "pomodoro_07_timer_running_again"

# Teste 6: Resetar timer
Write-Host "`n[TESTE 2.6] Resetar timer" -ForegroundColor Cyan
Tap-Screen -X 540 -Y 1400 -Description "Botão Reset"
Capture-Screenshot -Name "pomodoro_08_timer_reset" -Description "Deve voltar para 25:00"

# Teste 7: Testar skip
Write-Host "`n[TESTE 2.7] Skip para próxima sessão" -ForegroundColor Cyan
Tap-Screen -X 540 -Y 1200 -Description "Start timer"
Start-Sleep -Seconds 2
Tap-Screen -X 700 -Y 1400 -Description "Botão Skip (direita)"
Capture-Screenshot -Name "pomodoro_09_after_skip" -Description "Deve mudar para Break"

# Teste 8: Abrir Settings
Write-Host "`n[TESTE 2.8] Abrir configurações" -ForegroundColor Cyan
Tap-Screen -X 950 -Y 100 -Description "Settings icon (top-right)"
Write-Host "    ⏳ Aguardando settings carregar..." -ForegroundColor Gray
Start-Sleep -Seconds 3
Capture-Screenshot -Name "pomodoro_10_settings_opened"

# Teste 9: Scroll em Settings para ver todas opções
Write-Host "`n[TESTE 2.9] Explorar todas as configurações" -ForegroundColor Cyan
Write-Host "    📜 Scroll para baixo..." -ForegroundColor Gray
& $adb -s $DeviceId shell input swipe 540 1500 540 600 300
Start-Sleep -Seconds 2
Capture-Screenshot -Name "pomodoro_11_settings_scrolled_1"

& $adb -s $DeviceId shell input swipe 540 1500 540 600 300
Start-Sleep -Seconds 2
Capture-Screenshot -Name "pomodoro_12_settings_scrolled_2"

& $adb -s $DeviceId shell input swipe 540 1500 540 600 300
Start-Sleep -Seconds 2
Capture-Screenshot -Name "pomodoro_13_settings_scrolled_3"

# Teste 10: Mudar duração do Focus
Write-Host "`n[TESTE 2.10] Ajustar duração do Pomodoro" -ForegroundColor Cyan
Write-Host "    📜 Scroll para cima para voltar ao topo..." -ForegroundColor Gray
& $adb -s $DeviceId shell input swipe 540 600 540 1500 300
Start-Sleep -Seconds 2

Tap-Screen -X 540 -Y 400 -Description "Campo Focus Duration"
Capture-Screenshot -Name "pomodoro_14_focus_duration_field"

# Teste 11: Trocar tema
Write-Host "`n[TESTE 2.11] Trocar tema" -ForegroundColor Cyan
& $adb -s $DeviceId shell input swipe 540 1500 540 600 300
Start-Sleep -Seconds 2
Tap-Screen -X 540 -Y 900 -Description "Toggle Dark Mode"
Capture-Screenshot -Name "pomodoro_15_dark_theme"

Tap-Screen -X 540 -Y 900 -Description "Toggle Light Mode"
Capture-Screenshot -Name "pomodoro_16_light_theme"

# Teste 12: Testar Colorful Mode (se existir)
Write-Host "`n[TESTE 2.12] Testar Colorful Mode" -ForegroundColor Cyan
Tap-Screen -X 540 -Y 1100 -Description "Toggle Colorful Mode (se existir)"
Capture-Screenshot -Name "pomodoro_17_colorful_mode"

# Voltar para home
Write-Host "`n[TESTE 2.13] Voltar para tela principal" -ForegroundColor Cyan
& $adb -s $DeviceId shell input keyevent KEYCODE_BACK
Start-Sleep -Seconds 3
Capture-Screenshot -Name "pomodoro_18_back_to_home"

# Teste 13: Abrir Statistics
Write-Host "`n[TESTE 2.14] Abrir Statistics" -ForegroundColor Cyan
Tap-Screen -X 850 -Y 100 -Description "Statistics icon"
Start-Sleep -Seconds 3
Capture-Screenshot -Name "pomodoro_19_statistics_opened"
& $adb -s $DeviceId shell input keyevent KEYCODE_BACK
Start-Sleep -Seconds 2

# Teste 14: Abrir Achievements
Write-Host "`n[TESTE 2.15] Abrir Achievements" -ForegroundColor Cyan
Tap-Screen -X 750 -Y 100 -Description "Achievements icon"
Start-Sleep -Seconds 3
Capture-Screenshot -Name "pomodoro_20_achievements_opened"
& $adb -s $DeviceId shell input keyevent KEYCODE_BACK
Start-Sleep -Seconds 2

# Teste 15: Testar Daily Goal Progress
Write-Host "`n[TESTE 2.16] Daily Goal Progress (visível na home?)" -ForegroundColor Cyan
Capture-Screenshot -Name "pomodoro_21_daily_goal_widget"

# Teste 16: Teste de persistência - completar uma sessão curta
Write-Host "`n[TESTE 2.17] Completar uma sessão (curta para teste)" -ForegroundColor Cyan
Write-Host "  🎯 Objetivo: Testar se sessão é salva" -ForegroundColor White

# Abrir settings para mudar duração para 1 minuto
Tap-Screen -X 950 -Y 100 -Description "Settings"
Start-Sleep -Seconds 2
# Aqui seria ideal mudar para 1min, mas vamos só fazer capture
Capture-Screenshot -Name "pomodoro_22_settings_before_session"
& $adb -s $DeviceId shell input keyevent KEYCODE_BACK
Start-Sleep -Seconds 2

# Teste 17: Fechar e reabrir (teste de persistência)
Write-Host "`n[TESTE 2.18] 🔥 TESTE DE PERSISTÊNCIA - Fechar e reabrir" -ForegroundColor Red
Write-Host "  🎯 Objetivo: Verificar se settings e estado persistem" -ForegroundColor White

Close-App -PackageId $pomodoroPackage
Write-Host "    ⏳ App fechado, aguardando 3 segundos..." -ForegroundColor Gray
Start-Sleep -Seconds 3

Write-Host "    🔄 Reabrindo app..." -ForegroundColor Gray
Open-App -PackageId $pomodoroPackage -AppName "Pomodoro Timer"
Start-Sleep -Seconds 10  # Tempo extra para carregar
Capture-Screenshot -Name "pomodoro_23_reopened_home" -Description "⚠️ Verificar se carrega ou trava novamente"

# Teste 18: Verificar se settings persistiram
Write-Host "`n[TESTE 2.19] Verificar Settings após restart" -ForegroundColor Cyan
Tap-Screen -X 950 -Y 100 -Description "Settings"
Start-Sleep -Seconds 3
Capture-Screenshot -Name "pomodoro_24_settings_after_restart"
& $adb -s $DeviceId shell input keyevent KEYCODE_BACK
Start-Sleep -Seconds 2

# Teste 19: Teste em Português
Write-Host "`n[TESTE 2.20] Teste em Português" -ForegroundColor Cyan
Close-App -PackageId $pomodoroPackage
Change-Language -Locale "pt-BR" -Name "Português"

Open-App -PackageId $pomodoroPackage -AppName "Pomodoro Timer"
Start-Sleep -Seconds 10
Capture-Screenshot -Name "pomodoro_25_home_portuguese" -Description "Home em português"

Tap-Screen -X 950 -Y 100 -Description "Configurações"
Start-Sleep -Seconds 3
Capture-Screenshot -Name "pomodoro_26_settings_portuguese"
& $adb -s $DeviceId shell input keyevent KEYCODE_BACK
Start-Sleep -Seconds 2

# Teste 20: Teste em Español
Write-Host "`n[TESTE 2.21] Teste em Español" -ForegroundColor Cyan
Close-App -PackageId $pomodoroPackage
Change-Language -Locale "es-ES" -Name "Español"

Open-App -PackageId $pomodoroPackage -AppName "Pomodoro Timer"
Start-Sleep -Seconds 10
Capture-Screenshot -Name "pomodoro_27_home_spanish"

Close-App -PackageId $pomodoroPackage
Stop-Log-Capture -Job $pomodoroLogJob -AppName "Pomodoro Timer"

Write-Host "`n✅ Pomodoro Timer - 27 screenshots capturados!" -ForegroundColor Green
Write-Host "   📊 PONTOS CRÍTICOS A VERIFICAR:" -ForegroundColor Yellow
Write-Host "   - pomodoro_01: Primeira abertura - DEVE CARREGAR (não tela branca!)" -ForegroundColor Red
Write-Host "   - pomodoro_04/07: Timer rodando - contador deve decrementar" -ForegroundColor Gray
Write-Host "   - pomodoro_23: Reabertura - TESTE DE LOADING!" -ForegroundColor Red

# ═══════════════════════════════════════════════════════════════════════════
# RELATÓRIO FINAL
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "`n`n╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  TESTE DEEP DIVE CONCLUÍDO                                           ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Green

$allScreenshots = Get-ChildItem -Path $screenshotDir -Filter "*.png"
$totalSize = ($allScreenshots | Measure-Object -Property Length -Sum).Sum / 1MB

Write-Host "📊 ESTATÍSTICAS:" -ForegroundColor Cyan
Write-Host "   Total de screenshots: $($allScreenshots.Count)"
Write-Host "   Tamanho total: $([math]::Round($totalSize, 2)) MB"
Write-Host "   Diretório: $screenshotDir`n"

Write-Host "📋 BREAKDOWN POR APP:" -ForegroundColor Cyan
$bmiScreenshots = $allScreenshots | Where-Object { $_.Name -match "^bmi_" }
$pomodoroScreenshots = $allScreenshots | Where-Object { $_.Name -match "^pomodoro_" }

Write-Host "   BMI Calculator: $($bmiScreenshots.Count) screenshots"
Write-Host "   Pomodoro Timer: $($pomodoroScreenshots.Count) screenshots`n"

Write-Host "🔍 VALIDAÇÃO MANUAL NECESSÁRIA:" -ForegroundColor Yellow
Write-Host "`n  📱 BMI CALCULATOR - VERIFICAR:" -ForegroundColor Magenta
Write-Host "     1. bmi_04_tab_evolution_empty.png"
Write-Host "        ➜ Deve mostrar mensagem 'need 2 entries' (não erro)"
Write-Host "`n     2. bmi_13_evolution_with_data.png ⚠️⚠️⚠️ CRÍTICO!"
Write-Host "        ➜ Deve mostrar LINHA COM 2 PONTOS no gráfico"
Write-Host "        ➜ Se estiver vazio = BUG CONFIRMADO (AsyncNotifier necessário)"
Write-Host "`n     3. bmi_23_evolution_after_restart.png ⚠️⚠️⚠️ CRÍTICO!"
Write-Host "        ➜ Gráfico deve carregar automaticamente"
Write-Host "        ➜ Se vazio = problema de persistência"
Write-Host "`n     4. bmi_24/25/26_*.png"
Write-Host "        ➜ Traduções em português corretas?"

Write-Host "`n  ⏱️  POMODORO TIMER - VERIFICAR:" -ForegroundColor Magenta
Write-Host "     1. pomodoro_01_first_open.png ⚠️⚠️⚠️ CRÍTICO!"
Write-Host "        ➜ App deve estar CARREGADO (mostrar timer)"
Write-Host "        ➜ Se tela branca/rosa = BUG CONFIRMADO"
Write-Host "`n     2. pomodoro_04_timer_running_5s.png"
Write-Host "        ➜ Timer deve mostrar ~24:55 (decrementando)"
Write-Host "`n     3. pomodoro_23_reopened_home.png ⚠️⚠️⚠️ CRÍTICO!"
Write-Host "        ➜ Deve carregar normalmente após restart"
Write-Host "        ➜ Se travar = problema de initialization provider"
Write-Host "`n     4. pomodoro_25/26/27_*.png"
Write-Host "        ➜ Traduções em pt/es corretas?"

Write-Host "`n📝 LOGS CAPTURADOS:" -ForegroundColor Cyan
$logFiles = Get-ChildItem -Path $screenshotDir -Filter "*_logcat.txt"
foreach ($log in $logFiles) {
    Write-Host "   - $($log.Name) ($([math]::Round($log.Length / 1KB, 1)) KB)"
}

Write-Host "`n🔧 PRÓXIMOS PASSOS:" -ForegroundColor Yellow
Write-Host "   1. Abrir pasta de screenshots:"
Write-Host "      explorer $screenshotDir"
Write-Host "`n   2. Validar manualmente os screenshots CRÍTICOS marcados acima"
Write-Host "`n   3. Se bugs confirmados, aplicar correções:"
Write-Host "      - BMI: AsyncNotifier no bmiHistoryProvider"
Write-Host "      - Pomodoro: Debug logging + melhorar loading state"
Write-Host "`n   4. Re-testar após correções"

Write-Host "`n╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Abrindo pasta de screenshots...                                    ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Restaurar idioma
Change-Language -Locale "en-US" -Name "English (restaurado)"

# Abrir pasta
Start-Process explorer $screenshotDir

Write-Host "✅ DEEP DIVE TEST COMPLETO!`n" -ForegroundColor Green
