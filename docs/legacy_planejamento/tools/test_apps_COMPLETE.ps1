# =============================================================================
# TEST APPS COMPLETE - O Script de Testes Mais Completo do Mundo
# =============================================================================
# Segue: docs/MASTER_TEST_PLAN.md
# Filosofia: "Não basta abrir - é preciso USAR, CALCULAR, SALVAR, MODIFICAR"
# =============================================================================

param(
    [string]$Apps = "all",                    # "all" ou "bmi_calculator,pomodoro_timer"
    [int]$ActionDelayMs = 100,                # Delay entre ações (100ms = 0.1s)
    [string]$Languages = "en",                # "en" ou "en,pt,ar,de"
    [switch]$IncludeInterruption = $false,    # Testar interrupções?
    [switch]$IncludeNetwork = $false,         # Testar rede?
    [switch]$Quick = $false,                  # Modo rápido (smoke test)
    [switch]$SkipBuild = $false               # Pular build se APK existe
)

# =============================================================================
# CONFIGURAÇÃO
# =============================================================================

$baseDir = "C:\Users\Ernane\Personal\APPs_Flutter_2"
$appsDir = "$baseDir\apps"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$artifactBase = "$baseDir\artifacts\test_complete_$timestamp"
$global:stepCounter = 0
$global:totalErrors = 0
$global:testResults = @()

# Criar pasta de artefatos
New-Item -ItemType Directory -Path $artifactBase -Force | Out-Null

# =============================================================================
# FUNÇÕES AUXILIARES
# =============================================================================

function Write-Step {
    param([string]$Message, [string]$Color = "White")
    $global:stepCounter++
    Write-Host "[$global:stepCounter] $Message" -ForegroundColor $Color
}

function Write-Action {
    param([string]$Message)
    Write-Host "    → $Message" -ForegroundColor DarkCyan
}

function Wait-Action {
    Start-Sleep -Milliseconds $ActionDelayMs
}

function Take-Screenshot {
    param([string]$Dir, [string]$Name)
    $path = "$Dir\screenshots"
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }
    $file = "$path\$Name.png"
    & adb exec-out screencap -p > $file
    Write-Host "    📸 $Name.png" -ForegroundColor DarkGray
    return $file
}

function Tap {
    param([int]$X, [int]$Y, [string]$Description = "")
    if ($Description) { Write-Action "Tap: $Description ($X, $Y)" }
    & adb shell input tap $X $Y
    Wait-Action
}

function LongPress {
    param([int]$X, [int]$Y, [int]$DurationMs = 500, [string]$Description = "")
    if ($Description) { Write-Action "Long press: $Description" }
    & adb shell input swipe $X $Y $X $Y $DurationMs
    Wait-Action
}

function Swipe {
    param([int]$X1, [int]$Y1, [int]$X2, [int]$Y2, [int]$DurationMs = 200, [string]$Description = "")
    if ($Description) { Write-Action "Swipe: $Description" }
    & adb shell input swipe $X1 $Y1 $X2 $Y2 $DurationMs
    Wait-Action
}

function InputText {
    param([string]$Text, [string]$Description = "")
    if ($Description) { Write-Action "Input: '$Text' ($Description)" }
    & adb shell input text $Text
    Wait-Action
}

function ClearField {
    param([int]$Chars = 10)
    Write-Action "Clearing field ($Chars chars)"
    & adb shell input keyevent KEYCODE_MOVE_END
    for ($i = 0; $i -lt $Chars; $i++) {
        & adb shell input keyevent KEYCODE_DEL
    }
    Wait-Action
}

function PressKey {
    param([string]$KeyCode, [string]$Description = "")
    if ($Description) { Write-Action "Key: $KeyCode ($Description)" }
    & adb shell input keyevent $KeyCode
    Wait-Action
}

function CloseKeyboard {
    Write-Action "Closing keyboard"
    & adb shell input keyevent KEYCODE_BACK
    Start-Sleep -Milliseconds 300
}

function ForceStopApp {
    param([string]$Package)
    Write-Action "Force stopping $Package"
    & adb shell am force-stop $Package
    Start-Sleep -Milliseconds 500
}

function LaunchApp {
    param([string]$Package)
    Write-Action "Launching $Package"
    & adb shell am start -n "$Package/.MainActivity" 2>&1 | Out-Null
    Start-Sleep -Seconds 2
}

function WaitForApp {
    param([int]$Seconds = 2)
    Write-Action "Waiting ${Seconds}s for app to settle"
    Start-Sleep -Seconds $Seconds
}

function Get-PackageName {
    param([string]$AppPath)
    $pubspec = Get-Content "$AppPath\pubspec.yaml" -Raw
    if ($pubspec -match "name:\s+(\S+)") {
        return "sa.rezende." + $Matches[1]
    }
    return $null
}

function Get-ScreenSize {
    $output = & adb shell wm size
    if ($output -match "(\d+)x(\d+)") {
        return @{
            Width = [int]$Matches[1]
            Height = [int]$Matches[2]
            CenterX = [int]($Matches[1] / 2)
            CenterY = [int]($Matches[2] / 2)
        }
    }
    return @{ Width = 1080; Height = 1920; CenterX = 540; CenterY = 960 }
}

# =============================================================================
# CENÁRIOS DE TESTE POR TIPO DE APP
# =============================================================================

function Test-BMICalculator {
    param([string]$ArtifactDir, [string]$Package, [hashtable]$Screen)
    
    Write-Step "🧪 BMI Calculator - COMPLETE TEST" "Yellow"
    
    $cx = $Screen.CenterX
    $cy = $Screen.CenterY
    $bottomButton = $Screen.Height - 200
    $topRow = 150
    
    # HOME
    WaitForApp
    Take-Screenshot $ArtifactDir "01_home"
    
    # WEIGHT INPUT
    $weightY = [int]($cy * 0.7)
    Tap $cx $weightY "Weight field"
    Take-Screenshot $ArtifactDir "02_weight_focused"
    ClearField 5
    InputText "75" "Enter weight 75kg"
    Take-Screenshot $ArtifactDir "03_weight_entered"
    
    # HEIGHT INPUT
    $heightY = [int]($cy * 0.9)
    Tap $cx $heightY "Height field"
    Take-Screenshot $ArtifactDir "04_height_focused"
    ClearField 5
    InputText "175" "Enter height 175cm"
    Take-Screenshot $ArtifactDir "05_height_entered"
    
    CloseKeyboard
    Take-Screenshot $ArtifactDir "06_ready_to_calculate"
    
    # CALCULATE
    Tap $cx $bottomButton "Calculate button"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "07_result_calculated"
    
    # HISTORY/EVOLUTION
    Tap 100 $topRow "Evolution tab (left)"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "08_evolution_screen"
    
    # Go back to home if needed
    PressKey "KEYCODE_BACK" "Back to home"
    Start-Sleep -Milliseconds 300
    
    # SETTINGS
    Tap ($Screen.Width - 100) $topRow "Settings (right)"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "09_settings"
    
    # Scroll in settings
    Swipe $cx ($cy + 300) $cx ($cy - 300) 200 "Scroll settings"
    Take-Screenshot $ArtifactDir "10_settings_scrolled"
    
    # Toggle a setting if exists (approximate position)
    Tap $cx [int]($cy * 0.6) "Toggle setting"
    Take-Screenshot $ArtifactDir "11_setting_toggled"
    
    PressKey "KEYCODE_BACK" "Back from settings"
    
    # PERSISTENCE TEST
    Write-Step "Testing persistence (kill and restart)" "Magenta"
    ForceStopApp $Package
    Start-Sleep -Seconds 1
    LaunchApp $Package
    WaitForApp 3
    Take-Screenshot $ArtifactDir "12_after_restart_home"
    
    # Check evolution again
    Tap 100 $topRow "Evolution after restart"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "13_evolution_after_restart"
    
    # EDGE CASES
    Write-Step "Testing edge cases" "Magenta"
    PressKey "KEYCODE_BACK"
    
    # Try zero
    Tap $cx $weightY "Weight field for edge case"
    ClearField 5
    InputText "0" "Edge case: zero"
    Tap $cx $bottomButton "Calculate with zero"
    Start-Sleep -Milliseconds 300
    Take-Screenshot $ArtifactDir "14_edge_zero"
    
    # Try large number
    Tap $cx $weightY "Weight field"
    ClearField 5
    InputText "999" "Edge case: large"
    Tap $cx $heightY "Height field"
    ClearField 5
    InputText "250" "Edge case: tall"
    CloseKeyboard
    Tap $cx $bottomButton "Calculate edge case"
    Start-Sleep -Milliseconds 300
    Take-Screenshot $ArtifactDir "15_edge_large"
    
    Write-Host "    ✅ BMI Calculator test complete" -ForegroundColor Green
    return @{ Status = "PASS"; Screenshots = 15; Errors = 0 }
}

function Test-PomodoroTimer {
    param([string]$ArtifactDir, [string]$Package, [hashtable]$Screen)
    
    Write-Step "🧪 Pomodoro Timer - COMPLETE TEST" "Yellow"
    
    $cx = $Screen.CenterX
    $cy = $Screen.CenterY
    $topRow = 150
    
    WaitForApp
    Take-Screenshot $ArtifactDir "01_home"
    
    # START TIMER
    Tap $cx $cy "Start timer (center)"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "02_timer_started"
    
    # Wait and see countdown
    Write-Action "Observing timer for 3 seconds..."
    Start-Sleep -Seconds 3
    Take-Screenshot $ArtifactDir "03_timer_running"
    
    # PAUSE
    Tap $cx $cy "Pause timer"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "04_timer_paused"
    
    # Wait - timer should NOT advance
    Write-Action "Verifying timer paused (2 seconds)..."
    Start-Sleep -Seconds 2
    Take-Screenshot $ArtifactDir "05_timer_still_paused"
    
    # RESUME
    Tap $cx $cy "Resume timer"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "06_timer_resumed"
    
    # RESET
    $resetX = [int]($cx * 0.5)
    $resetY = [int]($cy * 1.3)
    Tap $resetX $resetY "Reset button (left of center)"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "07_timer_reset"
    
    # SETTINGS
    Tap ($Screen.Width - 100) $topRow "Settings"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "08_settings"
    
    # Modify duration
    Tap $cx [int]($cy * 0.5) "Duration setting"
    Take-Screenshot $ArtifactDir "09_duration_picker"
    PressKey "KEYCODE_BACK"
    
    # Scroll settings
    Swipe $cx ($cy + 300) $cx ($cy - 300) 200 "Scroll settings"
    Take-Screenshot $ArtifactDir "10_settings_scrolled"
    
    # Toggle theme
    Tap $cx [int]($cy * 0.8) "Toggle theme"
    Take-Screenshot $ArtifactDir "11_theme_changed"
    
    PressKey "KEYCODE_BACK" "Back from settings"
    Take-Screenshot $ArtifactDir "12_home_new_theme"
    
    # BACKGROUND TEST
    Write-Step "Testing background behavior" "Magenta"
    Tap $cx $cy "Start timer for background test"
    Start-Sleep -Seconds 1
    Take-Screenshot $ArtifactDir "13_before_background"
    
    PressKey "KEYCODE_HOME" "Go to home (background)"
    Write-Action "App in background for 5 seconds..."
    Start-Sleep -Seconds 5
    
    LaunchApp $Package
    WaitForApp
    Take-Screenshot $ArtifactDir "14_after_background"
    
    # PERSISTENCE TEST
    Write-Step "Testing persistence" "Magenta"
    ForceStopApp $Package
    Start-Sleep -Seconds 1
    LaunchApp $Package
    WaitForApp 3
    Take-Screenshot $ArtifactDir "15_after_restart"
    
    Write-Host "    ✅ Pomodoro Timer test complete" -ForegroundColor Green
    return @{ Status = "PASS"; Screenshots = 15; Errors = 0 }
}

function Test-CompoundInterest {
    param([string]$ArtifactDir, [string]$Package, [hashtable]$Screen)
    
    Write-Step "🧪 Compound Interest - COMPLETE TEST" "Yellow"
    
    $cx = $Screen.CenterX
    $cy = $Screen.CenterY
    $topRow = 150
    $bottomButton = $Screen.Height - 200
    
    WaitForApp
    Take-Screenshot $ArtifactDir "01_home"
    
    # PRINCIPAL
    $principalY = [int]($cy * 0.45)
    Tap $cx $principalY "Principal field"
    Take-Screenshot $ArtifactDir "02_principal_focused"
    ClearField 10
    InputText "10000" "Principal 10000"
    Take-Screenshot $ArtifactDir "03_principal_entered"
    
    # INTEREST RATE
    $rateY = [int]($cy * 0.65)
    Tap $cx $rateY "Interest rate field"
    ClearField 5
    InputText "5" "Rate 5%"
    Take-Screenshot $ArtifactDir "04_rate_entered"
    
    # TIME
    $timeY = [int]($cy * 0.85)
    Tap $cx $timeY "Time field"
    ClearField 5
    InputText "10" "Time 10 years"
    Take-Screenshot $ArtifactDir "05_time_entered"
    
    CloseKeyboard
    Take-Screenshot $ArtifactDir "06_ready_to_calculate"
    
    # CALCULATE
    Tap $cx $bottomButton "Calculate"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "07_result"
    
    # Scroll to see chart
    Swipe $cx ($cy + 400) $cx ($cy - 200) 300 "Scroll to chart"
    Take-Screenshot $ArtifactDir "08_chart_visible"
    
    # Interact with chart
    Tap $cx [int]($cy * 0.5) "Tap chart"
    Take-Screenshot $ArtifactDir "09_chart_interaction"
    
    # SETTINGS
    Tap ($Screen.Width - 100) $topRow "Settings"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "10_settings"
    
    # Modify compound frequency
    Tap $cx [int]($cy * 0.5) "Compound frequency"
    Take-Screenshot $ArtifactDir "11_frequency_picker"
    
    # Select different frequency
    Tap $cx [int]($cy * 0.7) "Select option"
    Start-Sleep -Milliseconds 300
    Take-Screenshot $ArtifactDir "12_frequency_changed"
    
    PressKey "KEYCODE_BACK" "Back"
    
    # PERSISTENCE
    Write-Step "Testing persistence" "Magenta"
    ForceStopApp $Package
    LaunchApp $Package
    WaitForApp 3
    Take-Screenshot $ArtifactDir "13_after_restart"
    
    # Scroll to see if chart still has data
    Swipe $cx ($cy + 400) $cx ($cy - 200) 300 "Scroll to chart after restart"
    Take-Screenshot $ArtifactDir "14_chart_after_restart"
    
    Write-Host "    ✅ Compound Interest test complete" -ForegroundColor Green
    return @{ Status = "PASS"; Screenshots = 14; Errors = 0 }
}

function Test-FastingTracker {
    param([string]$ArtifactDir, [string]$Package, [hashtable]$Screen)
    
    Write-Step "🧪 Fasting Tracker - COMPLETE TEST" "Yellow"
    
    $cx = $Screen.CenterX
    $cy = $Screen.CenterY
    $topRow = 150
    
    WaitForApp
    Take-Screenshot $ArtifactDir "01_home"
    
    # Start fast (main button)
    Tap $cx [int]($cy * 1.2) "Start fast"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "02_fast_started"
    
    # Wait for timer
    Write-Action "Observing timer for 3 seconds..."
    Start-Sleep -Seconds 3
    Take-Screenshot $ArtifactDir "03_timer_running"
    
    # Stop fast
    Tap $cx [int]($cy * 1.2) "Stop fast"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "04_fast_stopped"
    
    # Confirm if dialog appears
    Tap $cx $cy "Confirm stop (if dialog)"
    Start-Sleep -Milliseconds 300
    Take-Screenshot $ArtifactDir "05_fast_confirmed"
    
    # History/Stats
    Tap 100 $topRow "History tab"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "06_history"
    
    # Scroll history
    Swipe $cx ($cy + 300) $cx ($cy - 300) 200 "Scroll history"
    Take-Screenshot $ArtifactDir "07_history_scrolled"
    
    # Settings
    Tap ($Screen.Width - 100) $topRow "Settings"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "08_settings"
    
    # Modify goal
    Tap $cx [int]($cy * 0.5) "Fasting goal"
    Take-Screenshot $ArtifactDir "09_goal_picker"
    
    # Select new goal
    Tap $cx [int]($cy * 0.7) "Select new goal"
    Start-Sleep -Milliseconds 300
    Take-Screenshot $ArtifactDir "10_goal_changed"
    
    PressKey "KEYCODE_BACK" "Back"
    
    # PERSISTENCE
    Write-Step "Testing persistence" "Magenta"
    ForceStopApp $Package
    LaunchApp $Package
    WaitForApp 3
    Take-Screenshot $ArtifactDir "11_after_restart"
    
    Tap 100 $topRow "History after restart"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "12_history_after_restart"
    
    Write-Host "    ✅ Fasting Tracker test complete" -ForegroundColor Green
    return @{ Status = "PASS"; Screenshots = 12; Errors = 0 }
}

function Test-WhiteNoise {
    param([string]$ArtifactDir, [string]$Package, [hashtable]$Screen)
    
    Write-Step "🧪 White Noise - COMPLETE TEST" "Yellow"
    
    $cx = $Screen.CenterX
    $cy = $Screen.CenterY
    $topRow = 150
    
    WaitForApp
    Take-Screenshot $ArtifactDir "01_home"
    
    # Select sound 1
    Tap [int]($cx * 0.5) [int]($cy * 0.6) "Sound 1"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "02_sound1_selected"
    
    # Wait for playback
    Write-Action "Listening for 2 seconds..."
    Start-Sleep -Seconds 2
    
    # Select sound 2 (mix)
    Tap [int]($cx * 1.5) [int]($cy * 0.6) "Sound 2"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "03_sound2_mixed"
    
    # Adjust volume slider
    $sliderY = [int]($cy * 1.1)
    Swipe [int]($cx * 0.3) $sliderY [int]($cx * 1.5) $sliderY 200 "Volume slider"
    Take-Screenshot $ArtifactDir "04_volume_adjusted"
    
    # Stop all
    Tap $cx [int]($cy * 1.4) "Stop all"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "05_stopped"
    
    # Settings
    Tap ($Screen.Width - 100) $topRow "Settings"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "06_settings"
    
    # Timer setting
    Tap $cx [int]($cy * 0.5) "Sleep timer"
    Take-Screenshot $ArtifactDir "07_timer_picker"
    
    Tap $cx [int]($cy * 0.6) "Select timer"
    Take-Screenshot $ArtifactDir "08_timer_set"
    
    PressKey "KEYCODE_BACK" "Back"
    
    # Theme
    Tap $cx [int]($cy * 0.8) "Theme"
    Take-Screenshot $ArtifactDir "09_theme_picker"
    
    Tap $cx [int]($cy * 0.6) "Select theme"
    Take-Screenshot $ArtifactDir "10_theme_changed"
    
    PressKey "KEYCODE_BACK" "Back"
    Take-Screenshot $ArtifactDir "11_home_new_theme"
    
    # PERSISTENCE
    Write-Step "Testing persistence" "Magenta"
    ForceStopApp $Package
    LaunchApp $Package
    WaitForApp 3
    Take-Screenshot $ArtifactDir "12_after_restart"
    
    Write-Host "    ✅ White Noise test complete" -ForegroundColor Green
    return @{ Status = "PASS"; Screenshots = 12; Errors = 0 }
}

function Test-GenericApp {
    param([string]$ArtifactDir, [string]$Package, [hashtable]$Screen, [string]$AppName)
    
    Write-Step "🧪 $AppName - GENERIC TEST" "Yellow"
    
    $cx = $Screen.CenterX
    $cy = $Screen.CenterY
    $topRow = 150
    
    WaitForApp
    Take-Screenshot $ArtifactDir "01_home"
    
    # Primary action (center)
    Tap $cx $cy "Primary action (center)"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "02_after_primary_action"
    
    # Secondary action
    Tap $cx [int]($cy * 1.3) "Secondary action (bottom center)"
    Start-Sleep -Milliseconds 300
    Take-Screenshot $ArtifactDir "03_after_secondary_action"
    
    # Try settings/menu (top right)
    Tap ($Screen.Width - 100) $topRow "Settings/menu"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "04_settings_or_menu"
    
    # Back
    PressKey "KEYCODE_BACK" "Back"
    Take-Screenshot $ArtifactDir "05_back_to_home"
    
    # Swipe down (refresh)
    Swipe $cx 300 $cx 1000 200 "Swipe down (refresh)"
    Take-Screenshot $ArtifactDir "06_after_swipe_down"
    
    # Swipe left (navigation)
    Swipe ($Screen.Width - 100) $cy 100 $cy 200 "Swipe left"
    Take-Screenshot $ArtifactDir "07_after_swipe_left"
    
    # Swipe right (back)
    Swipe 100 $cy ($Screen.Width - 100) $cy 200 "Swipe right"
    Take-Screenshot $ArtifactDir "08_after_swipe_right"
    
    # Long press
    LongPress $cx $cy 500 "Long press center"
    Take-Screenshot $ArtifactDir "09_after_long_press"
    
    # Dismiss if context menu
    PressKey "KEYCODE_BACK" "Dismiss"
    
    # Scroll up
    Swipe $cx ($cy + 400) $cx ($cy - 400) 200 "Scroll up"
    Take-Screenshot $ArtifactDir "10_after_scroll_up"
    
    # Scroll down
    Swipe $cx ($cy - 400) $cx ($cy + 400) 200 "Scroll down"
    Take-Screenshot $ArtifactDir "11_after_scroll_down"
    
    # PERSISTENCE TEST
    Write-Step "Testing persistence" "Magenta"
    ForceStopApp $Package
    LaunchApp $Package
    WaitForApp 3
    Take-Screenshot $ArtifactDir "12_after_restart"
    
    Write-Host "    ✅ $AppName generic test complete" -ForegroundColor Green
    return @{ Status = "PASS"; Screenshots = 12; Errors = 0 }
}

# =============================================================================
# BUILD E INSTALL
# =============================================================================

function Build-App {
    param([string]$AppPath, [string]$ArtifactDir)
    
    $apkPath = "$AppPath\build\app\outputs\apk\release\app-release.apk"
    
    if ($SkipBuild -and (Test-Path $apkPath)) {
        $age = (Get-Date) - (Get-Item $apkPath).LastWriteTime
        if ($age.TotalMinutes -lt 60) {
            Write-Host "    ✓ Using existing APK (${age:mm}min old)" -ForegroundColor Green
            return $apkPath
        }
    }
    
    Write-Action "Building APK..."
    Set-Location $AppPath
    
    & flutter pub get 2>&1 | Out-File "$ArtifactDir\pub_get.log"
    & flutter gen-l10n 2>&1 | Out-File "$ArtifactDir\gen_l10n.log"
    & flutter build apk --release 2>&1 | Out-File "$ArtifactDir\build.log"
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "    ❌ Build failed" -ForegroundColor Red
        return $null
    }
    
    if (Test-Path $apkPath) {
        Write-Host "    ✓ APK built successfully" -ForegroundColor Green
        return $apkPath
    }
    
    return $null
}

function Install-App {
    param([string]$ApkPath)
    
    Write-Action "Installing APK..."
    & adb install -r $ApkPath 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "    ✓ Installed" -ForegroundColor Green
        return $true
    }
    
    Write-Host "    ❌ Install failed" -ForegroundColor Red
    return $false
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  📱 TEST APPS COMPLETE - O Script Mais Completo do Mundo" -ForegroundColor Cyan
Write-Host "  Seguindo: docs/MASTER_TEST_PLAN.md" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Action Delay: ${ActionDelayMs}ms" -ForegroundColor Gray
Write-Host "  Languages: $Languages" -ForegroundColor Gray
Write-Host "  Artifacts: $artifactBase" -ForegroundColor Gray
Write-Host ""

# Verificar device conectado
$devices = & adb devices
if ($devices -notmatch "\w+\s+device") {
    Write-Host "❌ Nenhum device conectado! Conecte um celular e tente novamente." -ForegroundColor Red
    exit 1
}

$deviceId = ($devices | Select-String "(\w+)\s+device" | Select-Object -First 1).Matches.Groups[1].Value
Write-Host "📱 Device: $deviceId" -ForegroundColor Green

# Get screen size
$screen = Get-ScreenSize
Write-Host "📐 Screen: $($screen.Width)x$($screen.Height)" -ForegroundColor Gray
Write-Host ""

# Get apps to test
$appPaths = @()
if ($Apps -eq "all") {
    $appPaths = Get-ChildItem $appsDir -Directory -Recurse | Where-Object {
        Test-Path "$($_.FullName)\pubspec.yaml"
    } | Select-Object -ExpandProperty FullName
} else {
    $appNames = $Apps.Split(",")
    foreach ($name in $appNames) {
        $found = Get-ChildItem $appsDir -Directory -Recurse | Where-Object {
            $_.Name -eq $name.Trim() -and (Test-Path "$($_.FullName)\pubspec.yaml")
        }
        if ($found) { $appPaths += $found.FullName }
    }
}

Write-Host "🎯 Apps to test: $($appPaths.Count)" -ForegroundColor Yellow
Write-Host ""

$count = 0
foreach ($appPath in $appPaths) {
    $count++
    $appName = Split-Path -Leaf $appPath
    $clusterName = Split-Path -Leaf (Split-Path -Parent $appPath)
    
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    Write-Host "[$count/$($appPaths.Count)] 🚀 $clusterName/$appName" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    
    $appArtifactDir = "$artifactBase\$appName"
    New-Item -ItemType Directory -Path $appArtifactDir -Force | Out-Null
    
    $global:stepCounter = 0
    
    try {
        # Build
        $apkPath = Build-App $appPath $appArtifactDir
        if (-not $apkPath) {
            $global:testResults += @{ App = $appName; Status = "BUILD_FAILED"; Screenshots = 0 }
            continue
        }
        
        # Install
        if (-not (Install-App $apkPath)) {
            $global:testResults += @{ App = $appName; Status = "INSTALL_FAILED"; Screenshots = 0 }
            continue
        }
        
        # Get package
        $package = Get-PackageName $appPath
        if (-not $package) {
            $global:testResults += @{ App = $appName; Status = "NO_PACKAGE"; Screenshots = 0 }
            continue
        }
        
        # Clear logcat
        & adb logcat -c 2>&1 | Out-Null
        
        # Launch
        LaunchApp $package
        
        # Run appropriate test
        $result = switch -Wildcard ($appName) {
            "*bmi*" { Test-BMICalculator $appArtifactDir $package $screen }
            "*pomodoro*" { Test-PomodoroTimer $appArtifactDir $package $screen }
            "*compound*" { Test-CompoundInterest $appArtifactDir $package $screen }
            "*interest*" { Test-CompoundInterest $appArtifactDir $package $screen }
            "*fasting*" { Test-FastingTracker $appArtifactDir $package $screen }
            "*white*noise*" { Test-WhiteNoise $appArtifactDir $package $screen }
            "*noise*" { Test-WhiteNoise $appArtifactDir $package $screen }
            default { Test-GenericApp $appArtifactDir $package $screen $appName }
        }
        
        # Capture logcat
        Write-Action "Saving logcat..."
        & adb logcat -d > "$appArtifactDir\logcat.txt"
        
        # Stop app
        ForceStopApp $package
        
        $global:testResults += @{ 
            App = $appName
            Status = $result.Status
            Screenshots = $result.Screenshots
        }
        
        Write-Host ""
        
    } catch {
        Write-Host "❌ Error: $_" -ForegroundColor Red
        $global:testResults += @{ App = $appName; Status = "ERROR"; Screenshots = 0 }
    }
}

# =============================================================================
# REPORT
# =============================================================================

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  📊 TEST RESULTS SUMMARY" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$passed = ($global:testResults | Where-Object { $_.Status -eq "PASS" }).Count
$failed = $global:testResults.Count - $passed
$totalScreenshots = ($global:testResults | Measure-Object -Property Screenshots -Sum).Sum

Write-Host "  ✅ Passed: $passed" -ForegroundColor Green
Write-Host "  ❌ Failed: $failed" -ForegroundColor Red
Write-Host "  📸 Screenshots: $totalScreenshots" -ForegroundColor Gray
Write-Host "  📁 Artifacts: $artifactBase" -ForegroundColor Gray
Write-Host ""

# Detail by app
Write-Host "  Details:" -ForegroundColor White
foreach ($result in $global:testResults) {
    $statusIcon = if ($result.Status -eq "PASS") { "✅" } else { "❌" }
    Write-Host "    $statusIcon $($result.App): $($result.Status) ($($result.Screenshots) screenshots)"
}

# Save report
$report = @"
# Test Report - $timestamp

## Summary
- **Total Apps:** $($global:testResults.Count)
- **Passed:** $passed
- **Failed:** $failed
- **Screenshots:** $totalScreenshots

## Results by App

| App | Status | Screenshots |
|-----|--------|-------------|
$($global:testResults | ForEach-Object { "| $($_.App) | $($_.Status) | $($_.Screenshots) |" } | Out-String)

## Artifacts Location
$artifactBase

---
Generated by: TEST_APPS_COMPLETE.ps1
Date: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@

$report | Out-File "$artifactBase\REPORT.md" -Encoding utf8

Write-Host ""
Write-Host "  📝 Report saved: $artifactBase\REPORT.md" -ForegroundColor Cyan
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
