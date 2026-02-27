# Run apps on physical device - SIMPLE VERSION
param([int]$DelaySeconds = 30)

$baseDir = "C:\Users\Ernane\Personal\APPs_Flutter_2"
$appsDir = "$baseDir\apps"
$artifactBase = "$baseDir\artifacts\run_on_device_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $artifactBase -Force | Out-Null

Write-Host "📱 Running apps on physical device" -ForegroundColor Cyan
Write-Host "Device delay: $DelaySeconds seconds`n" -ForegroundColor Gray

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
    
    Write-Host "[$count/$($apps.Count)] 🚀 Building and running: $appId" -ForegroundColor Cyan
    
    # Create artifact folder for this app
    $appArtifactDir = "$artifactBase\$appName"
    New-Item -ItemType Directory -Path $appArtifactDir -Force | Out-Null
    
    try {
        # Go to app directory
        Set-Location $appPath
        
        # Clean and get dependencies
        Write-Host "  → pubget..." -NoNewline
        & flutter pub get 2>&1 | Out-Null
        Write-Host " ✓" -ForegroundColor Green
        
        # Generate l10n
        Write-Host "  → genl10n..." -NoNewline
        & flutter gen-l10n 2>&1 | Out-Null
        Write-Host " ✓" -ForegroundColor Green
        
        # Build APK
        Write-Host "  → build apk..." -NoNewline
        & flutter build apk --release 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Write-Host " ❌" -ForegroundColor Red
            continue
        }
        Write-Host " ✓" -ForegroundColor Green
        
        # Find APK
        $apkPath = Get-ChildItem "$appPath\build\app\outputs\apk\release\app-release.apk" -ErrorAction SilentlyContinue
        if (-not $apkPath) {
            Write-Host "  ⚠️  APK not found" -ForegroundColor Yellow
            continue
        }
        
        # Install
        Write-Host "  → install..." -NoNewline
        & adb install -r $apkPath.FullName 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Write-Host " ❌" -ForegroundColor Red
            continue
        }
        Write-Host " ✓" -ForegroundColor Green
        
        # Get package name from pubspec or manifest
        $pubspec = Get-Content "$appPath\pubspec.yaml"
        $packageMatch = $pubspec | Select-String "^name:\s+(\S+)" | Select-Object -First 1
        $packageName = "sa.rezende." + ($packageMatch -replace "^name:\s+", "")
        
        # Launch app
        Write-Host "  → launch app..." -NoNewline
        & adb shell am start -n "$packageName/.MainActivity" 2>&1 | Out-Null
        Write-Host " ✓" -ForegroundColor Green
        
        # Wait for observation
        Write-Host "  → waiting $DelaySeconds seconds for observation..." -NoNewline
        Start-Sleep -Seconds $DelaySeconds
        Write-Host " done" -ForegroundColor Gray
        
        # Screenshot
        Write-Host "  → screenshot..." -NoNewline
        & adb exec-out screencap -p > "$appArtifactDir\screenshot.png"
        Write-Host " ✓" -ForegroundColor Green
        
        # Logcat (last 100 lines)
        Write-Host "  → logcat..." -NoNewline
        & adb logcat -d > "$appArtifactDir\logcat.txt"
        Write-Host " ✓" -ForegroundColor Green
        
        Write-Host "  ✅ Success`n" -ForegroundColor Green
        
    } catch {
        Write-Host " ❌" -ForegroundColor Red
        Write-Host "  Error: $_`n" -ForegroundColor Red
    }
}

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "✅ All apps processed" -ForegroundColor Green
Write-Host "📁 Artifacts saved to: $artifactBase" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

# Show summary
Write-Host "`n📊 Summary:`n" -ForegroundColor Cyan
$screenshots = Get-ChildItem "$artifactBase" -Recurse -Filter "screenshot.png" | Measure-Object | Select-Object -ExpandProperty Count
Write-Host "  Screenshots captured: $screenshots"
Write-Host "  Logcat files: $(Get-ChildItem "$artifactBase" -Recurse -Filter "logcat.txt" | Measure-Object | Select-Object -ExpandProperty Count)"
