# Launch Persistent Chrome for Play Console (CDP port 9222)
# Run this FIRST before any Playwright automation to reuse browser/tabs/login

$profileDir = Join-Path $PSScriptRoot 'play-console-profile'
$chromeExe = &quot;$env:ProgramFiles\Google\Chrome\Application\chrome.exe&quot;

if (!(Test-Path $chromeExe)) {
    $chromeExe = &quot;$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe&quot;
}

if (!(Test-Path $chromeExe)) {
    Write-Error &quot;Chrome not found. Install Google Chrome.&quot;
    exit 1
}

# Check if port 9222 is in use (Chrome debugging)
$portInUse = Test-NetConnection -ComputerName localhost -Port 9222 -InformationLevel Quiet -WarningAction SilentlyContinue

if ($portInUse) {
    Write-Host &quot;✅ Chrome already running on port 9222 (profile: $profileDir). Reusing existing browser/tabs.&quot;
    Write-Host &quot;   Tip: Open new tab manually if needed: https://play.google.com/console&quot;
} else {
    Write-Host &quot;🚀 Launching persistent Chrome on port 9222 with dedicated profile: $profileDir&quot;
    
    # Create profile dir if not exists
    if (!(Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    }
    
    Start-Process -FilePath $chromeExe -ArgumentList @(
        '--remote-debugging-port=9222',
        &quot;--user-data-dir=`&quot;$profileDir`&quot;&quot;,
        '--disable-blink-features=AutomationControlled',
        'https://play.google.com/console'
    ) -WindowStyle Normal
        
    Write-Host &quot;⏳ Waiting 5s for Chrome to start...&quot;
    Start-Sleep 5
    
    Write-Host &quot;✅ Persistent browser launched! Login manually (one-time).&quot;
    Write-Host &quot;   Playwright scripts will connect via connectOverCDP('http://localhost:9222')&quot;
}

Write-Host &quot;\n📋 RULE: Always run this task BEFORE automation. Keeps login/tabs persistent across runs.&quot;