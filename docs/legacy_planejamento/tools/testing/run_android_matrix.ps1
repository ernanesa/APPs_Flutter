[CmdletBinding(PositionalBinding = $false)]
param(
  [string]$ConfigPath = "tools/testing/android_apps.json",
  [string]$OutDir = "artifacts/android_matrix",
  [string[]]$Avds = @("Phone_UltraFast", "Phone_API24", "Tablet7_API36", "Tablet7_API24", "Tablet10_API36", "Tablet10_API24"),
  [string[]]$AppIds = @(),
  [string[]]$Locales = @("en", "pt", "ar"),
  [ValidateSet("light","dark")]
  [string[]]$Themes = @("light","dark"),
  [string]$AvdsCsv = "",
  [string]$AppIdsCsv = "",
  [string]$LocalesCsv = "",
  [string]$ThemesCsv = "",
  [switch]$SkipBuild,
  [switch]$SkipEmulator,
  [switch]$KeepEmulatorRunning
)

$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\\..")).Path
$ConfigPath = (Resolve-Path (Join-Path $RepoRoot $ConfigPath)).Path
$OutDir = (Join-Path $RepoRoot $OutDir)

function Split-Csv([string]$value) {
  if ([string]::IsNullOrWhiteSpace($value)) { return @() }
  return ($value -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

if ($AvdsCsv) { $Avds = Split-Csv $AvdsCsv }
if ($AppIdsCsv) { $AppIds = Split-Csv $AppIdsCsv }
if ($LocalesCsv) { $Locales = Split-Csv $LocalesCsv }
if ($ThemesCsv) { $Themes = Split-Csv $ThemesCsv }

function Get-FlutterBat() {
  $flutter = "C:\Users\Ernane\flutter\sdk\bin\flutter.bat"
  if (Test-Path $flutter) { return $flutter }
  throw "flutter.bat not found at expected path: $flutter"
}

function Get-AdbExe() {
  $sdk = $env:ANDROID_HOME
  if ([string]::IsNullOrWhiteSpace($sdk)) {
    $sdk = "C:\Users\Ernane\AppData\Local\Android\Sdk"
  }
  $adb = Join-Path $sdk "platform-tools\\adb.exe"
  if (Test-Path $adb) { return $adb }
  throw "adb.exe not found. Set ANDROID_HOME or install Android SDK. Tried: $adb"
}

function Get-EmulatorExe() {
  $sdk = $env:ANDROID_HOME
  if ([string]::IsNullOrWhiteSpace($sdk)) {
    $sdk = "C:\Users\Ernane\AppData\Local\Android\Sdk"
  }
  $emu = Join-Path $sdk "emulator\\emulator.exe"
  if (Test-Path $emu) { return $emu }
  throw "emulator.exe not found. Set ANDROID_HOME or install Android SDK. Tried: $emu"
}

function Exec([string]$File, [string[]]$ArgList) {
  # In some environments (notably when launching Windows PowerShell from WSL),
  # `$LASTEXITCODE` can be `$null`. Use the native Process API to get ExitCode.
  $psi = New-Object System.Diagnostics.ProcessStartInfo
  $psi.FileName = $File
  $psi.UseShellExecute = $false
  $psi.RedirectStandardOutput = $true
  $psi.RedirectStandardError = $true
  $psi.CreateNoWindow = $true

  $escaped = @()
  foreach ($a in $ArgList) {
    $s = [string]$a
    if ($s -match '[\s"]') {
      $escaped += '"' + ($s -replace '"','\\"') + '"'
    } else {
      $escaped += $s
    }
  }
  $psi.Arguments = ($escaped -join " ")

  $p = [System.Diagnostics.Process]::Start($psi)
  $stdout = $p.StandardOutput.ReadToEnd()
  $stderr = $p.StandardError.ReadToEnd()
  $p.WaitForExit()

  return [PSCustomObject]@{ Code = $p.ExitCode; Out = $stdout; Err = $stderr }
}

function Exec-Adb([string[]]$AdbArgList) {
  $adb = Get-AdbExe
  $r = Exec $adb $AdbArgList
  if ($r.Code -ne 0) { throw "adb failed: $($AdbArgList -join ' ')\n$($r.Out)\n$($r.Err)" }
  return $r.Out
}

function Exec-AdbWithStdin([string[]]$AdbArgList, [string]$Stdin) {
  $adb = Get-AdbExe
  $psi = New-Object System.Diagnostics.ProcessStartInfo
  $psi.FileName = $adb
  $psi.UseShellExecute = $false
  $psi.RedirectStandardInput = $true
  $psi.RedirectStandardOutput = $true
  $psi.RedirectStandardError = $true
  $psi.CreateNoWindow = $true

  $escaped = @()
  foreach ($a in $AdbArgList) {
    $s = [string]$a
    if ($s -match '[\s"]') {
      $escaped += '"' + ($s -replace '"','\\"') + '"'
    } else {
      $escaped += $s
    }
  }
  $psi.Arguments = ($escaped -join " ")

  $p = [System.Diagnostics.Process]::Start($psi)
  $p.StandardInput.Write($Stdin)
  $p.StandardInput.Close()

  $stdout = $p.StandardOutput.ReadToEnd()
  $stderr = $p.StandardError.ReadToEnd()
  $p.WaitForExit()
  if ($p.ExitCode -ne 0) {
    throw "adb failed: $($AdbArgList -join ' ')\n$stdout\n$stderr"
  }
  return $stdout
}

function Ensure-DeviceReady() {
  Exec-Adb @("wait-for-device")
  for ($i=0; $i -lt 180; $i++) {
    try {
      $boot = (Exec-Adb @("shell","getprop","sys.boot_completed")).Trim()
      if ($boot -eq "1") { break }
    } catch {
      # Device can transiently drop the adb connection during boot.
    }
    Start-Sleep -Seconds 1
  }
  # Unlock (best-effort)
  try { Exec-Adb @("shell","input","keyevent","82") | Out-Null } catch {}
}

function Kill-AllEmulators() {
  try {
    $devices = (Exec-Adb @("devices")) -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -match "^emulator-" }
    foreach ($d in $devices) {
      $serial = ($d -split "\\s+")[0]
      try { Exec-Adb @("-s",$serial,"emu","kill") | Out-Null } catch {}
    }
  } catch {}
}

function Start-Avd([string]$AvdName) {
  $emu = Get-EmulatorExe
  Write-Host "==> Starting AVD: $AvdName"
  # Start emulator detached (Windows GUI app)
  $args = @("-avd", $AvdName, "-gpu", "host", "-no-audio", "-no-boot-anim")
  Start-Process -FilePath $emu -ArgumentList $args | Out-Null
  Ensure-DeviceReady
}

function Write-FlutterPrefsXml([string]$PackageId, [hashtable]$StringPrefs) {
  $lines = @()
  $lines += "<?xml version='1.0' encoding='utf-8' standalone='yes' ?>"
  $lines += "<map>"
  foreach ($k in $StringPrefs.Keys) {
    $v = $StringPrefs[$k]
    $ek = $k.Replace('&','&amp;').Replace('<','&lt;').Replace('>','&gt;')
    $ev = $v.Replace('&','&amp;').Replace('<','&lt;').Replace('>','&gt;')
    # Use single-quotes for the attribute value so we don't have to escape quotes.
    $lines += "  <string name='$ek'>$ev</string>"
  }
  $lines += "</map>"
  $xml = ($lines -join "`n")

  # Write file using run-as (debug builds only).
  Exec-Adb @("shell","run-as",$PackageId,"/system/bin/mkdir","-p","shared_prefs") | Out-Null
  Exec-AdbWithStdin @("shell","run-as",$PackageId,"/system/bin/tee","shared_prefs/FlutterSharedPreferences.xml") ($xml + "`n") | Out-Null
}

function Resolve-LaunchComponent([string]$PackageId) {
  $out = Exec-Adb @("shell","cmd","package","resolve-activity","--brief",$PackageId)
  $lines = $out -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ }
  return $lines[-1]
}

function Launch-And-Measure([string]$Component) {
  $out = Exec-Adb @("shell","am","start","-W","-n",$Component)
  $total = ($out -split "`n" | Where-Object { $_ -match "^TotalTime:" } | ForEach-Object { ($_ -split ":")[1].Trim() })[0]
  $wait = ($out -split "`n" | Where-Object { $_ -match "^WaitTime:" } | ForEach-Object { ($_ -split ":")[1].Trim() })[0]
  return [PSCustomObject]@{ TotalTimeMs = $total; WaitTimeMs = $wait; Raw = $out }
}

function Take-Screenshot([string]$Path) {
  $adb = Get-AdbExe
  $dir = Split-Path -Parent $Path
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
  # Use exec-out to preserve PNG bytes
  & $adb exec-out screencap -p > $Path
}

function Capture-Perf([string]$PackageId, [string]$OutBase) {
  Exec-Adb @("shell","dumpsys","meminfo",$PackageId) | Out-File -FilePath "$OutBase.meminfo.txt" -Encoding utf8
  Exec-Adb @("shell","dumpsys","gfxinfo",$PackageId) | Out-File -FilePath "$OutBase.gfxinfo.txt" -Encoding utf8
}

function Build-DebugApk([string]$AppPath) {
  $flutter = Get-FlutterBat
  $winAppPath = (Resolve-Path (Join-Path $RepoRoot $AppPath)).Path
  Write-Host "==> Building: $AppPath"
  $envPrefix = 'set "PATH=C:\Windows\System32;C:\Windows;C:\Program Files\Git\cmd;%PATH%" && '
  $cmd = "cd /d `"$winAppPath`" && $envPrefix`"$flutter`" build apk --debug --dart-define=E2E_TEST=true"
  $r = Exec "cmd.exe" @("/c", $cmd)
  if ($r.Code -ne 0) { throw "flutter build failed for $AppPath`n$($r.Out)`n$($r.Err)" }
}

function Install-Apk([string]$ApkPath) {
  Exec-Adb @("install","-r","-d",$ApkPath) | Out-Null
}

function Get-ApkPath([string]$AppPath) {
  # Flutter Windows builds land under build/app/outputs/flutter-apk/app-debug.apk
  $p = Join-Path (Join-Path $RepoRoot $AppPath) "build\\app\\outputs\\flutter-apk\\app-debug.apk"
  if (!(Test-Path $p)) { throw "APK not found (build first): $p" }
  return (Resolve-Path $p).Path
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
$apps = $config.apps
if ($AppIds.Count -gt 0) {
  $apps = $apps | Where-Object { $AppIds -contains $_.id }
}

foreach ($avd in $Avds) {
  if (!$SkipEmulator) {
    if (!$KeepEmulatorRunning) {
      Kill-AllEmulators
      Start-Sleep -Seconds 2
    }
    Start-Avd $avd
  } else {
    Ensure-DeviceReady
  }

  foreach ($app in $apps) {
    $appId = $app.id
    $appPath = $app.path
    $pkg = $app.packageId

    if (!$SkipBuild) { Build-DebugApk $appPath }
    $apk = Get-ApkPath $appPath
    Install-Apk $apk

    $component = Resolve-LaunchComponent $pkg
    Write-Host "==> Installed: $appId ($pkg) -> $component"

    foreach ($variant in $app.variants) {
      $variantId = $variant.id

      foreach ($locale in $Locales) {
        foreach ($theme in $Themes) {
          # Force stop before applying prefs
          Exec-Adb @("shell","am","force-stop",$pkg) | Out-Null

          $prefs = @{}
          $prefs["flutter.$($app.prefs.localeKey)"] = $locale
          $prefs["flutter.$($app.prefs.themeModeKey)"] = $theme

          if ($null -ne $variant.extraPrefs) {
            foreach ($k in $variant.extraPrefs.PSObject.Properties.Name) {
              $prefs["flutter.$k"] = [string]$variant.extraPrefs.$k
            }
          }

          Write-FlutterPrefsXml $pkg $prefs

          $measure = Launch-And-Measure $component
          Start-Sleep -Seconds 2

          $baseDir = Join-Path $OutDir "$avd/$appId"
          $baseName = "${locale}_${theme}_${variantId}"
          $png = Join-Path $baseDir "$baseName.png"
          $perfBase = Join-Path $baseDir "$baseName"

          Take-Screenshot $png
          Capture-Perf $pkg $perfBase

          $result = [PSCustomObject]@{
            avd = $avd
            app = $appId
            packageId = $pkg
            variant = $variantId
            locale = $locale
            theme = $theme
            totalTimeMs = $measure.TotalTimeMs
            waitTimeMs = $measure.WaitTimeMs
            screenshot = $png
          }
          $result | ConvertTo-Json -Depth 6 | Out-File -FilePath (Join-Path $baseDir "$baseName.result.json") -Encoding utf8
          Write-Host ("    OK {0} {1} {2} {3} Total={4}ms" -f $appId, $variantId, $locale, $theme, $measure.TotalTimeMs)
        }
      }
    }
  }
}

Write-Host "Done. Artifacts in: $OutDir"
