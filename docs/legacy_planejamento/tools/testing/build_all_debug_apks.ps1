[CmdletBinding(PositionalBinding = $false)]
param(
  [string]$RepoRoot = "C:\Users\Ernane\Personal\APPs_Flutter_2",
  [string]$FlutterBat = "C:\Users\Ernane\flutter\sdk\bin\flutter.bat",
  [string]$OutDir = "artifacts\\build_logs",
  [int]$MaxParallel = 2
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

function Start-Build([string]$rel) {
  $name = Split-Path $rel -Leaf
  $wd = Join-Path $RepoRoot $rel
  $out = Join-Path $logs ($name + ".out.txt")
  $err = Join-Path $logs ($name + ".err.txt")

  $envPrefix = 'set "PATH=C:\Windows\System32;C:\Windows;C:\Program Files\Git\cmd;%PATH%" && '
  $cmd = $envPrefix + "`"$FlutterBat`" build apk --debug --dart-define=E2E_TEST=true"
  return Start-Process -FilePath "cmd.exe" `
    -WorkingDirectory $wd `
    -ArgumentList @("/c", $cmd) `
    -RedirectStandardOutput $out `
    -RedirectStandardError $err `
    -NoNewWindow `
    -PassThru
}

$running = New-Object System.Collections.Generic.List[System.Diagnostics.Process]

foreach ($rel in $apps) {
  while ($running.Count -ge $MaxParallel) {
    Start-Sleep -Seconds 1
    $running = New-Object System.Collections.Generic.List[System.Diagnostics.Process] ($running | Where-Object { -not $_.HasExited })
  }
  $p = Start-Build $rel
  $running.Add($p) | Out-Null
  Write-Host "Started build: $rel (pid=$($p.Id))"
}

while ($running.Count -gt 0) {
  Start-Sleep -Seconds 1
  $running = New-Object System.Collections.Generic.List[System.Diagnostics.Process] ($running | Where-Object { -not $_.HasExited })
}

Write-Host "Builds finished. Logs in $logs"
