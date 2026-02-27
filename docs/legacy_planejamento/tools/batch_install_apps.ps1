# BATCH INSTALL APPS - Install multiple apps on all emulators with screenshots
# Runs apps sequentially on all available emulators in parallel

param(
    [Parameter(Mandatory=$true)]
    [string[]]$AppPaths,

    [switch]$TakeScreenshots,
    [string]$ScreenshotDir,
    [int]$WaitSeconds = 5
)

$ErrorActionPreference = "Continue"

# Colors
$GREEN = "`e[32m"
$RED = "`e[31m"
$YELLOW = "`e[33m"
$BLUE = "`e[34m"
$CYAN = "`e[36m"
$MAGENTA = "`e[35m"
$RESET = "`e[0m"
$BOLD = "`e[1m"

Write-Host ""
Write-Host "${BOLD}${MAGENTA}╔════════════════════════════════════════════════════════════╗${RESET}"
Write-Host "${BOLD}${MAGENTA}║  BATCH INSTALL - Multi-App Multi-Emulator Runner 🔥       ║${RESET}"
Write-Host "${BOLD}${MAGENTA}╚════════════════════════════════════════════════════════════╝${RESET}"
Write-Host ""

$startTime = Get-Date

# Setup screenshot directory
if ($TakeScreenshots -and -not $ScreenshotDir)
{
    $ScreenshotDir = "C:\Users\Ernane\Personal\APPs_Flutter_2\screenshots_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
}

if ($TakeScreenshots)
{
    New-Item -ItemType Directory -Path $ScreenshotDir -Force | Out-Null
    Write-Host "${BLUE}📸 Screenshots will be saved to: $ScreenshotDir${RESET}"
}

# Get devices
$devices = adb devices | Select-String "emulator-\d+" | ForEach-Object { $_.Matches.Value }

if ($devices.Count -eq 0)
{
    Write-Host "${RED}❌ No emulators running!${RESET}"
    Write-Host "${YELLOW}Start emulators first:${RESET}"
    Write-Host "  emulator -avd Phone_UltraFast &"
    Write-Host "  emulator -avd Phone_Fast &"
    exit 1
}

Write-Host "${GREEN}✓ Found $($devices.Count) emulators: $($devices -join ', ')${RESET}"
Write-Host "${BLUE}📦 Apps to install: $($AppPaths.Count)${RESET}"
Write-Host ""

$results = @()
$appCounter = 0

foreach ($appPath in $AppPaths)
{
    $appCounter++
    $appName = Split-Path $appPath -Leaf

    Write-Host "${BOLD}${CYAN}[$appCounter/$($AppPaths.Count)] Processing: $appName${RESET}"

    # Build APK
    Push-Location $appPath

    Write-Host "  ${YELLOW}Building APK...${RESET}"
    $buildStart = Get-Date
    $buildOutput = flutter build apk --debug 2>&1 | Out-String
    $buildSuccess = $LASTEXITCODE -eq 0
    $buildTime = ((Get-Date) - $buildStart).TotalSeconds

    if (-not $buildSuccess)
    {
        Write-Host "  ${RED}✗ Build failed ($([Math]::Round($buildTime, 1))s)${RESET}"
        Pop-Location

        foreach ($device in $devices)
        {
            $results += @{
                App = $appName
                Device = $device
                BuildSuccess = $false
                InstallSuccess = $false
                BuildTime = $buildTime
                Screenshot = $null
            }
        }

        Write-Host ""
        continue
    }

    Write-Host "  ${GREEN}✓ Build successful ($([Math]::Round($buildTime, 1))s)${RESET}"

    $apk = "build/app/outputs/flutter-apk/app-debug.apk"

    # Get package info
    $packageName = $null
    $launchActivity = $null

    try
    {
        # Try to extract from AndroidManifest
        $manifestPath = "android/app/src/main/AndroidManifest.xml"
        if (Test-Path $manifestPath)
        {
            $manifest = Get-Content $manifestPath -Raw
            if ($manifest -match 'package="([^"]+)"')
            {
                $packageName = $matches[1]
            }
            if ($manifest -match '<activity[^>]*android:name="([^"]+)"[^>]*>')
            {
                $launchActivity = $matches[1]
                if ($launchActivity -notmatch '\.')
                {
                    $launchActivity = "$packageName.$launchActivity"
                }
            }
        }
    } catch
    {
        # Silent
    }

    Write-Host "  ${CYAN}Installing on all emulators...${RESET}"

    # Install on all devices in parallel
    $jobs = @()

    foreach ($device in $devices)
    {
        $job = Start-Job -ScriptBlock {
            param($dev, $apkPath, $pkg, $activity, $appName, $screenshotDir, $takeScreenshots, $waitSec)

            $result = @{
                Device = $dev
                Success = $false
                InstallTime = 0
                Screenshot = $null
            }

            try
            {
                # Install
                $installStart = Get-Date
                $installOutput = adb -s $dev install -r $apkPath 2>&1 | Out-String
                $result.InstallTime = ((Get-Date) - $installStart).TotalSeconds

                if ($installOutput -match "Success")
                {
                    $result.Success = $true

                    # Try to launch
                    if ($pkg -and $activity)
                    {
                        Start-Sleep -Seconds 1
                        adb -s $dev shell am start -n "$pkg/$activity" 2>&1 | Out-Null
                        Start-Sleep -Seconds $waitSec
                    } elseif ($pkg)
                    {
                        # Try monkey launch
                        adb -s $dev shell monkey -p $pkg -c android.intent.category.LAUNCHER 1 2>&1 | Out-Null
                        Start-Sleep -Seconds $waitSec
                    }

                    # Take screenshot
                    if ($takeScreenshots -and $screenshotDir)
                    {
                        $screenshotPath = Join-Path $screenshotDir "${appName}_${dev}.png"
                        adb -s $dev shell screencap -p /sdcard/screen.png 2>&1 | Out-Null
                        adb -s $dev pull /sdcard/screen.png $screenshotPath 2>&1 | Out-Null

                        if (Test-Path $screenshotPath)
                        {
                            $result.Screenshot = $screenshotPath
                        }
                    }
                }
            } catch
            {
                # Silent
            }

            return $result

        } -ArgumentList $device, $apk, $packageName, $launchActivity, $appName, $ScreenshotDir, $TakeScreenshots, $WaitSeconds

        $jobs += $job
    }

    # Wait for all installations
    Wait-Job -Job $jobs | Out-Null

    foreach ($job in $jobs)
    {
        $deviceResult = Receive-Job -Job $job

        if ($deviceResult.Success)
        {
            $msg = "  ${GREEN}✓${RESET} $($deviceResult.Device) - Installed ($([Math]::Round($deviceResult.InstallTime, 1))s)"
            if ($deviceResult.Screenshot)
            {
                $msg += " ${BLUE}📸${RESET}"
            }
            Write-Host $msg
        } else
        {
            Write-Host "  ${RED}✗${RESET} $($deviceResult.Device) - Failed"
        }

        $results += @{
            App = $appName
            Device = $deviceResult.Device
            BuildSuccess = $buildSuccess
            InstallSuccess = $deviceResult.Success
            BuildTime = $buildTime
            InstallTime = $deviceResult.InstallTime
            Screenshot = $deviceResult.Screenshot
        }

        Remove-Job -Job $job
    }

    Pop-Location
    Write-Host ""
}

# Final statistics
$endTime = Get-Date
$totalTime = ($endTime - $startTime).TotalSeconds

Write-Host ""
Write-Host "${BOLD}${MAGENTA}╔════════════════════════════════════════════════════════════╗${RESET}"
Write-Host "${BOLD}${MAGENTA}║                   FINAL RESULTS                            ║${RESET}"
Write-Host "${BOLD}${MAGENTA}╚════════════════════════════════════════════════════════════╝${RESET}"
Write-Host ""

$totalTests = $results.Count
$successful = ($results | Where-Object { $_.InstallSuccess }).Count
$failed = $totalTests - $successful
$screenshots = ($results | Where-Object { $_.Screenshot }).Count

Write-Host "${GREEN}✓ Successful Installs: $successful / $totalTests${RESET}"
Write-Host "${RED}✗ Failed: $failed${RESET}"
Write-Host "${BLUE}📸 Screenshots Taken: $screenshots${RESET}"
Write-Host "${CYAN}⏱️  Total Time: $([Math]::Round($totalTime, 1))s${RESET}"
Write-Host ""

# Per-app summary
Write-Host "${BOLD}${CYAN}Per-App Results:${RESET}"
$results | Group-Object App | ForEach-Object {
    $appResults = $_.Group
    $appSuccess = ($appResults | Where-Object { $_.InstallSuccess }).Count
    $appTotal = $appResults.Count
    $appScreenshots = ($appResults | Where-Object { $_.Screenshot }).Count

    $status = if ($appSuccess -eq $appTotal)
    { "${GREEN}✓${RESET}" 
    } elseif ($appSuccess -gt 0)
    { "${YELLOW}⚠${RESET}" 
    } else
    { "${RED}✗${RESET}" 
    }

    $msg = "$status $($_.Name): $appSuccess/$appTotal devices"
    if ($appScreenshots -gt 0)
    {
        $msg += " ${BLUE}($appScreenshots screenshots)${RESET}"
    }
    Write-Host $msg
}
Write-Host ""

# Save JSON report
if ($ScreenshotDir)
{
    $jsonPath = Join-Path $ScreenshotDir "batch_results.json"
} else
{
    $outputDir = "C:\Users\Ernane\Personal\APPs_Flutter_2\batch_results_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
    $jsonPath = Join-Path $outputDir "batch_results.json"
}

$results | ConvertTo-Json -Depth 10 | Out-File -FilePath $jsonPath -Encoding UTF8
Write-Host "${BLUE}💾 Report saved: $jsonPath${RESET}"
Write-Host ""

if ($failed -eq 0)
{
    Write-Host "${BOLD}${GREEN}🎉 ALL APPS INSTALLED SUCCESSFULLY ON ALL EMULATORS!${RESET}"
    exit 0
} else
{
    Write-Host "${BOLD}${YELLOW}⚠️  $failed tests failed - check details above${RESET}"
    exit 1
}
