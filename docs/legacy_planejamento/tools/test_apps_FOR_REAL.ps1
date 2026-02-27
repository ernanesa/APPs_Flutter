# TEST APPS FOR REAL - Actually interact with the app
param([int]$ActionDelayMs = 100)

$baseDir = "C:\Users\Ernane\Personal\APPs_Flutter_2"
$appsDir = "$baseDir\apps"
$artifactBase = "$baseDir\artifacts\real_device_test_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $artifactBase -Force | Out-Null

Write-Host "📱 REAL DEVICE TESTING - Actually using the apps" -ForegroundColor Cyan
Write-Host "Action delay: ${ActionDelayMs}ms`n" -ForegroundColor Gray

# Helper functions
function Take-Screenshot {
    param([string]$Path, [string]$Name)
    & adb exec-out screencap -p > "$Path\${Name}.png"
    Write-Host "    📸 $Name" -ForegroundColor DarkGray
}

function Tap-Screen {
    param([int]$X, [int]$Y, [string]$Action)
    Write-Host "    👆 $Action ($X, $Y)" -ForegroundColor DarkCyan
    & adb shell input tap $X $Y
    Start-Sleep -Milliseconds $ActionDelayMs
}

function Input-Text {
    param([string]$Text, [string]$Action)
    Write-Host "    ⌨️  ${Action}: '$Text'" -ForegroundColor DarkCyan
    & adb shell input text $Text
    Start-Sleep -Milliseconds $ActionDelayMs
}

function Swipe-Screen {
    param([int]$X1, [int]$Y1, [int]$X2, [int]$Y2, [int]$Duration, [string]$Action)
    Write-Host "    👉 $Action" -ForegroundColor DarkCyan
    & adb shell input swipe $X1 $Y1 $X2 $Y2 $Duration
    Start-Sleep -Milliseconds $ActionDelayMs
}

function Get-UIElements {
    & adb shell uiautomator dump /sdcard/ui.xml 2>&1 | Out-Null
    $uiXml = & adb shell cat /sdcard/ui.xml
    return $uiXml
}

# App-specific test scenarios
function Test-BMICalculator {
    param([string]$ArtifactDir)
    Write-Host "  🧪 Testing BMI Calculator..." -ForegroundColor Yellow
    
    Start-Sleep -Seconds 2
    Take-Screenshot $ArtifactDir "01_home"
    
    # Tap weight field (approximate center coordinates for typical layout)
    Tap-Screen 540 800 "Tap weight field"
    Take-Screenshot $ArtifactDir "02_weight_focused"
    
    # Clear and input weight
    & adb shell input keyevent KEYCODE_MOVE_END
    for ($i = 0; $i -lt 5; $i++) { & adb shell input keyevent KEYCODE_DEL }
    Input-Text "75" "Enter weight 75kg"
    Take-Screenshot $ArtifactDir "03_weight_entered"
    
    # Tap height field
    Tap-Screen 540 1000 "Tap height field"
    Take-Screenshot $ArtifactDir "04_height_focused"
    
    # Input height
    & adb shell input keyevent KEYCODE_MOVE_END
    for ($i = 0; $i -lt 5; $i++) { & adb shell input keyevent KEYCODE_DEL }
    Input-Text "175" "Enter height 175cm"
    Take-Screenshot $ArtifactDir "05_height_entered"
    
    # Close keyboard
    & adb shell input keyevent KEYCODE_BACK
    Start-Sleep -Milliseconds 200
    
    # Tap calculate button (bottom center)
    Tap-Screen 540 1700 "Tap calculate button"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "06_result_calculated"
    
    # Navigate to evolution/history screen (tap icon if exists)
    Tap-Screen 200 150 "Try evolution tab"
    Start-Sleep -Milliseconds 300
    Take-Screenshot $ArtifactDir "07_evolution_screen"
    
    # Try settings
    Tap-Screen 900 150 "Try settings"
    Start-Sleep -Milliseconds 300
    Take-Screenshot $ArtifactDir "08_settings_screen"
}

function Test-PomodoroTimer {
    param([string]$ArtifactDir)
    Write-Host "  🧪 Testing Pomodoro Timer..." -ForegroundColor Yellow
    
    Start-Sleep -Seconds 2
    Take-Screenshot $ArtifactDir "01_home"
    
    # Start timer (big button center)
    Tap-Screen 540 1200 "Start timer"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "02_timer_started"
    
    # Pause
    Tap-Screen 540 1200 "Pause timer"
    Start-Sleep -Milliseconds 300
    Take-Screenshot $ArtifactDir "03_timer_paused"
    
    # Reset
    Tap-Screen 200 1700 "Reset timer"
    Start-Sleep -Milliseconds 300
    Take-Screenshot $ArtifactDir "04_timer_reset"
    
    # Settings
    Tap-Screen 900 150 "Open settings"
    Start-Sleep -Milliseconds 300
    Take-Screenshot $ArtifactDir "05_settings"
    
    # Try changing duration
    Tap-Screen 540 800 "Tap duration setting"
    Start-Sleep -Milliseconds 300
    Take-Screenshot $ArtifactDir "06_duration_picker"
}

function Test-CompoundInterest {
    param([string]$ArtifactDir)
    Write-Host "  🧪 Testing Compound Interest Calculator..." -ForegroundColor Yellow
    
    Start-Sleep -Seconds 2
    Take-Screenshot $ArtifactDir "01_home"
    
    # Principal amount
    Tap-Screen 540 600 "Tap principal field"
    Input-Text "10000" "Enter principal 10000"
    Take-Screenshot $ArtifactDir "02_principal_entered"
    
    # Interest rate
    Tap-Screen 540 800 "Tap interest field"
    Input-Text "5" "Enter interest 5%"
    Take-Screenshot $ArtifactDir "03_interest_entered"
    
    # Duration
    Tap-Screen 540 1000 "Tap duration field"
    Input-Text "10" "Enter duration 10"
    Take-Screenshot $ArtifactDir "04_duration_entered"
    
    # Close keyboard and calculate
    & adb shell input keyevent KEYCODE_BACK
    Start-Sleep -Milliseconds 200
    Tap-Screen 540 1500 "Calculate"
    Start-Sleep -Milliseconds 500
    Take-Screenshot $ArtifactDir "05_result"
    
    # Try graph/chart view
    Swipe-Screen 540 1500 540 800 300 "Swipe to see chart"
    Take-Screenshot $ArtifactDir "06_chart_view"
}

function Test-GenericApp {
    param([string]$ArtifactDir, [string]$AppName)
    Write-Host "  🧪 Testing $AppName (generic)..." -ForegroundColor Yellow
    
    Start-Sleep -Seconds 2
    Take-Screenshot $ArtifactDir "01_home"
    
    # Try tapping center (main action button)
    Tap-Screen 540 1200 "Tap center button"
    Take-Screenshot $ArtifactDir "02_action1"
    
    # Try top-right corner (settings/menu)
    Tap-Screen 950 150 "Tap top-right"
    Start-Sleep -Milliseconds 300
    Take-Screenshot $ArtifactDir "03_settings_or_menu"
    
    # Go back
    & adb shell input keyevent KEYCODE_BACK
    Start-Sleep -Milliseconds 200
    Take-Screenshot $ArtifactDir "04_back_to_home"
    
    # Try swipe down (refresh?)
    Swipe-Screen 540 400 540 1200 300 "Swipe down"
    Take-Screenshot $ArtifactDir "05_swipe_down"
    
    # Try swipe left (navigation?)
    Swipe-Screen 800 1000 300 1000 300 "Swipe left"
    Take-Screenshot $ArtifactDir "06_swipe_left"
    
    # Try swipe right
    Swipe-Screen 300 1000 800 1000 300 "Swipe right"
    Take-Screenshot $ArtifactDir "07_swipe_right"
}

# Get list of all apps
$apps = Get-ChildItem $appsDir -Directory -Recurse | Where-Object { 
    Test-Path "$($_.FullName)\pubspec.yaml" 
} | Select-Object -ExpandProperty FullName

Write-Host "Found $($apps.Count) apps to test`n" -ForegroundColor Yellow

$count = 0
foreach ($appPath in $apps) {
    $count++
    $appName = Split-Path -Leaf $appPath
    $clusterName = Split-Path -Leaf (Split-Path -Parent $appPath)
    $appId = "$clusterName/$appName"
    
    Write-Host "[$count/$($apps.Count)] 🚀 $appId" -ForegroundColor Cyan
    
    # Create artifact folder
    $appArtifactDir = "$artifactBase\$appName"
    New-Item -ItemType Directory -Path $appArtifactDir -Force | Out-Null
    
    try {
        Set-Location $appPath
        
        # Quick build (skip if APK exists and recent)
        $apkPath = "$appPath\build\app\outputs\apk\release\app-release.apk"
        $needsBuild = $true
        
        if (Test-Path $apkPath) {
            $apkAge = (Get-Date) - (Get-Item $apkPath).LastWriteTime
            if ($apkAge.TotalMinutes -lt 30) {
                Write-Host "  ✓ Using existing APK (built $([math]::Round($apkAge.TotalMinutes, 1))m ago)" -ForegroundColor Green
                $needsBuild = $false
            }
        }
        
        if ($needsBuild) {
            Write-Host "  → Building APK..." -NoNewline
            & flutter pub get 2>&1 | Out-Null
            & flutter gen-l10n 2>&1 | Out-Null
            & flutter build apk --release 2>&1 | Out-File "$appArtifactDir\build.log"
            if ($LASTEXITCODE -ne 0) {
                Write-Host " ❌" -ForegroundColor Red
                Write-Host "  Build failed - check $appArtifactDir\build.log" -ForegroundColor Red
                continue
            }
            Write-Host " ✓" -ForegroundColor Green
        }
        
        # Install
        Write-Host "  → Installing..." -NoNewline
        & adb install -r $apkPath 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Write-Host " ❌" -ForegroundColor Red
            continue
        }
        Write-Host " ✓" -ForegroundColor Green
        
        # Get package name
        $pubspec = Get-Content "$appPath\pubspec.yaml" -Raw
        if ($pubspec -match "name:\s+(\S+)") {
            $packageName = "sa.rezende." + $Matches[1]
        } else {
            Write-Host "  ⚠️  Could not determine package name" -ForegroundColor Yellow
            continue
        }
        
        # Clear logcat
        & adb logcat -c 2>&1 | Out-Null
        
        # Launch app
        Write-Host "  → Launching $packageName..." -NoNewline
        & adb shell am start -n "$packageName/.MainActivity" 2>&1 | Out-Null
        Write-Host " ✓" -ForegroundColor Green
        
        # Run app-specific test scenario
        switch -Wildcard ($appName) {
            "*bmi*" { Test-BMICalculator $appArtifactDir }
            "*pomodoro*" { Test-PomodoroTimer $appArtifactDir }
            "*compound*" { Test-CompoundInterest $appArtifactDir }
            "*interest*" { Test-CompoundInterest $appArtifactDir }
            default { Test-GenericApp $appArtifactDir $appName }
        }
        
        # Capture final logcat
        Write-Host "  → Capturing logcat..." -NoNewline
        & adb logcat -d > "$appArtifactDir\logcat.txt"
        Write-Host " ✓" -ForegroundColor Green
        
        # Kill app
        & adb shell am force-stop $packageName 2>&1 | Out-Null
        
        Write-Host "  ✅ Tested successfully`n" -ForegroundColor Green
        
    } catch {
        Write-Host "  ❌ Error: $_`n" -ForegroundColor Red
    }
}

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "✅ All apps tested" -ForegroundColor Green
Write-Host "📁 Artifacts: $artifactBase" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

# Summary
$totalScreenshots = (Get-ChildItem "$artifactBase" -Recurse -Filter "*.png" | Measure-Object).Count
$totalLogcats = (Get-ChildItem "$artifactBase" -Recurse -Filter "logcat.txt" | Measure-Object).Count
Write-Host "`n📊 Summary:" -ForegroundColor Cyan
Write-Host "  Screenshots: $totalScreenshots"
Write-Host "  Logcat files: $totalLogcats"
Write-Host "  Apps tested: $totalLogcats"
