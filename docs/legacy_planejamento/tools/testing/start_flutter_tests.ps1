param(
  [string]$RepoRoot = "C:\Users\Ernane\Personal\APPs_Flutter_2",
  [string]$FlutterBat = "C:\Users\Ernane\flutter\sdk\bin\flutter.bat",
  [string]$OutDir = "artifacts\\test_logs",
  [int]$Concurrency = 6,
  [switch]$NoPub
)

$ErrorActionPreference = "Stop"

$logs = Join-Path $RepoRoot $OutDir
New-Item -ItemType Directory -Force -Path $logs | Out-Null

$apps = @(
  "apps\\health\\bmi_calculator",
  "apps\\health\\fasting_tracker",
  "apps\\productivity\\pomodoro_timer",
  "apps\\media\\white_noise",
  "apps\\finance\\compound_interest_calculator"
)

foreach ($rel in $apps) {
  $name = Split-Path $rel -Leaf
  $wd = Join-Path $RepoRoot $rel
  $out = Join-Path $logs ($name + ".out.txt")
  $err = Join-Path $logs ($name + ".err.txt")

  $args = @("test", "--concurrency=$Concurrency")
  if ($NoPub) { $args += "--no-pub" }
  $argStr = ($args -join " ")

  $envPrefix = 'set "PATH=C:\Windows\System32;C:\Windows;C:\Program Files\Git\cmd;%PATH%" && '

  Start-Process -FilePath "cmd.exe" `
    -WorkingDirectory $wd `
    -ArgumentList @("/c", $envPrefix + "`"$FlutterBat`" " + $argStr) `
    -RedirectStandardOutput $out `
    -RedirectStandardError $err `
    -NoNewWindow | Out-Null
}

Write-Host "Started flutter test for all apps (parallel). Logs in $logs"
