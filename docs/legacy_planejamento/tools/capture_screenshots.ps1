# SCREENSHOT CAPTURE - TODOS OS APPS × TODOS OS DEVICES
# Versão corrigida usando adb pull

param(
    [int]$ThrottleLimit = 16
)

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outputDir = "artifacts/screenshots_$timestamp"
New-Item -ItemType Directory -Path $outputDir -Force | Out-Null

$adbPath = "C:\Users\Ernane\AppData\Local\Android\Sdk\platform-tools\adb.exe"
$devicesRaw = & $adbPath devices | Select-String "emulator-" | ForEach-Object { $_.ToString().Split()[0] }
$availableDevices = @($devicesRaw | Where-Object { $_ })

$apps = @(
    @{Name="bmi_calculator"; Package="sa.rezende.bmi_calculator"},
    @{Name="pomodoro_timer"; Package="sa.rezende.pomodoro_timer"},
    @{Name="compound_interest_calculator"; Package="sa.rezende.compound_interest_calculator"}
)

Write-Host "📸 SCREENSHOT CAPTURE - CORRIGIDO" -ForegroundColor Magenta
Write-Host "📱 Devices: $($availableDevices -join ', ')" -ForegroundColor Cyan
Write-Host ""

$jobs = @()

foreach ($app in $apps) {
    foreach ($device in $availableDevices) {
        # Home screenshot
        $jobs += Start-Job -ScriptBlock {
            param($package, $appName, $device, $adbPath, $outputDir)
            
            try {
                # Lançar app
                & $adbPath -s $device shell am start -n "$package/.MainActivity" 2>&1 | Out-Null
                Start-Sleep -Seconds 3
                
                # Capturar via screencap + pull
                $remotePath = "/sdcard/${appName}_home.png"
                $localPath = "$outputDir/${appName}_${device}_home.png"
                
                & $adbPath -s $device shell screencap -p $remotePath 2>&1 | Out-Null
                & $adbPath -s $device pull $remotePath $localPath 2>&1 | Out-Null
                
                if (Test-Path $localPath) {
                    $size = (Get-Item $localPath).Length
                    return @{Status="SUCCESS"; Screenshot=$localPath; Size=$size}
                } else {
                    return @{Status="FAILED"; Error="File not created"}
                }
            } catch {
                return @{Status="FAILED"; Error=$_.Exception.Message}
            }
        } -ArgumentList $app.Package, $app.Name, $device, $adbPath, $outputDir
        
        # After interaction screenshot
        $jobs += Start-Job -ScriptBlock {
            param($package, $appName, $device, $adbPath, $outputDir)
            
            try {
                # Garantir que app está aberto
                & $adbPath -s $device shell am start -n "$package/.MainActivity" 2>&1 | Out-Null
                Start-Sleep -Seconds 2
                
                # Interação básica
                & $adbPath -s $device shell input tap 400 800 2>&1 | Out-Null
                Start-Sleep -Seconds 2
                
                # Capturar via screencap + pull
                $remotePath = "/sdcard/${appName}_interaction.png"
                $localPath = "$outputDir/${appName}_${device}_after_interaction.png"
                
                & $adbPath -s $device shell screencap -p $remotePath 2>&1 | Out-Null
                & $adbPath -s $device pull $remotePath $localPath 2>&1 | Out-Null
                
                if (Test-Path $localPath) {
                    $size = (Get-Item $localPath).Length
                    return @{Status="SUCCESS"; Screenshot=$localPath; Size=$size}
                } else {
                    return @{Status="FAILED"; Error="File not created"}
                }
            } catch {
                return @{Status="FAILED"; Error=$_.Exception.Message}
            }
        } -ArgumentList $app.Package, $app.Name, $device, $adbPath, $outputDir
    }
}

Write-Host "⏳ Capturando $($jobs.Count) screenshots..." -ForegroundColor Cyan
$jobs | Wait-Job | Out-Null
$results = $jobs | Receive-Job
$jobs | Remove-Job -Force

Write-Host ""
$success = ($results | Where-Object { $_.Status -eq "SUCCESS" }).Count
$failed = ($results | Where-Object { $_.Status -eq "FAILED" }).Count

Write-Host "✅ Capturados: $success screenshots" -ForegroundColor Green
Write-Host "❌ Falhas: $failed" -ForegroundColor $(if ($failed -gt 0) { "Red" } else { "Gray" })
Write-Host ""
Write-Host "📂 Local: $outputDir" -ForegroundColor Cyan

# Listar arquivos criados
$screenshots = Get-ChildItem "$outputDir/*.png" -ErrorAction SilentlyContinue
if ($screenshots) {
    $totalSize = ($screenshots | Measure-Object -Property Length -Sum).Sum
    Write-Host ""
    Write-Host "📸 $($screenshots.Count) arquivos criados (Total: $([math]::Round($totalSize/1MB, 2)) MB):" -ForegroundColor Green
    $screenshots | ForEach-Object { 
        $sizeKB = [math]::Round($_.Length/1KB, 1)
        Write-Host "   • $($_.Name) ($sizeKB KB)" -ForegroundColor Gray
    }
}
