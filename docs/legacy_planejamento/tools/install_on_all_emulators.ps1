# Install and Run on All Emulators - Ultra Simple
param(
    [Parameter(Mandatory=$true)]
    [string]$AppPath
)

$ErrorActionPreference = "Continue"

# Colors
$GREEN = "`e[32m"
$RED = "`e[31m"
$YELLOW = "`e[33m"
$BLUE = "`e[34m"
$CYAN = "`e[36m"
$RESET = "`e[0m"
$BOLD = "`e[1m"

Write-Host ""
Write-Host "${BOLD}${CYAN}Installing and Running on All Emulators${RESET}"
Write-Host ""

# Get devices
$devices = adb devices | Select-String "emulator-\d+" | ForEach-Object { $_.Matches.Value }

if ($devices.Count -eq 0)
{
    Write-Host "${RED}No emulators running!${RESET}"
    exit 1
}

Write-Host "${BLUE}Found $($devices.Count) emulators: $($devices -join ', ')${RESET}"
Write-Host ""

# Navigate to app
Push-Location $AppPath

# Build
Write-Host "${YELLOW}Building APK...${RESET}"
flutter build apk --debug

if ($LASTEXITCODE -ne 0)
{
    Write-Host "${RED}Build failed!${RESET}"
    Pop-Location
    exit 1
}

$apk = "build/app/outputs/flutter-apk/app-debug.apk"

if (-not (Test-Path $apk))
{
    Write-Host "${RED}APK not found!${RESET}"
    Pop-Location
    exit 1
}

Write-Host "${GREEN}✓ Build successful${RESET}"
Write-Host ""

# Get package name
$packageName = aapt dump badging $apk | Select-String "package: name='([^']+)'" | ForEach-Object { $_.Matches.Groups[1].Value }
$launchActivity = aapt dump badging $apk | Select-String "launchable-activity: name='([^']+)'" | ForEach-Object { $_.Matches.Groups[1].Value }

Write-Host "${BLUE}Package: $packageName${RESET}"
Write-Host "${BLUE}Activity: $launchActivity${RESET}"
Write-Host ""

# Install on all devices in parallel
Write-Host "${YELLOW}Installing on all emulators...${RESET}"

$jobs = @()
foreach ($device in $devices)
{
    $job = Start-Job -ScriptBlock {
        param($dev, $apkPath, $pkg, $activity)

        # Install
        $output = adb -s $dev install -r $apkPath 2>&1 | Out-String
        $installSuccess = $LASTEXITCODE -eq 0

        # Launch if successful
        if ($installSuccess -and $pkg -and $activity)
        {
            Start-Sleep -Seconds 1
            adb -s $dev shell am start -n "$pkg/$activity" 2>&1 | Out-Null
        }

        return @{
            Device = $dev
            Success = $installSuccess
            Output = $output
        }
    } -ArgumentList $device, $apk, $packageName, $launchActivity

    $jobs += $job
}

# Wait and collect results
Wait-Job -Job $jobs | Out-Null

foreach ($job in $jobs)
{
    $result = Receive-Job -Job $job

    if ($result.Success)
    {
        Write-Host "${GREEN}✓ $($result.Device) - Installed & Launched${RESET}"
    } else
    {
        Write-Host "${RED}✗ $($result.Device) - Failed${RESET}"
    }

    Remove-Job -Job $job
}

Pop-Location

Write-Host ""
Write-Host "${BOLD}${GREEN}Done! Check your emulators - app should be running on all of them${RESET}"
Write-Host ""
