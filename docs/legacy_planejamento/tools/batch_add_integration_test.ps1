# Batch Add Integration Test Dependency - Beast Mode 5.2
# Usage: pwsh tools/batch_add_integration_test.ps1 -Apps "app1,app2,app3" -Category "productivity"

param(
    [Parameter(Mandatory=$false)]
    [string]$Apps,

    [Parameter(Mandatory=$false)]
    [string]$Category,

    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$script:updated = @()
$script:skipped = @()
$script:failed = @()

function Write-Header {
    param([string]$Text)
    Write-Host "`n$('=' * 80)" -ForegroundColor Cyan
    Write-Host "  $Text" -ForegroundColor Cyan
    Write-Host "$('=' * 80)`n" -ForegroundColor Cyan
}

function Get-AppList {
    if ($Apps) {
        return $Apps -split ','
    }

    if ($Category) {
        $categoryPath = "apps/$Category"
        if (!(Test-Path $categoryPath)) {
            Write-Host "❌ Category path not found: $categoryPath" -ForegroundColor Red
            exit 1
        }

        $appDirs = Get-ChildItem $categoryPath -Directory
        return $appDirs | ForEach-Object { $_.Name }
    }

    Write-Host "❌ Must specify either -Apps or -Category" -ForegroundColor Red
    exit 1
}

function Add-IntegrationTestDependency {
    param(
        [string]$AppName,
        [string]$Category
    )

    $appPath = if ($Category) { "apps/$Category/$AppName" } else { "apps/productivity/$AppName" }
    $pubspecPath = "$appPath/pubspec.yaml"

    if (!(Test-Path $pubspecPath)) {
        Write-Host "  ⚠️  Skipped: pubspec.yaml not found" -ForegroundColor Yellow
        $script:skipped += $AppName
        return
    }

    $content = Get-Content $pubspecPath -Raw

    # Check if already has integration_test
    if ($content -match "integration_test:\s*\n\s*sdk:\s*flutter") {
        Write-Host "  ✅ Already has integration_test" -ForegroundColor Green
        $script:skipped += $AppName
        return
    }

    Write-Host "  📝 Adding integration_test..." -ForegroundColor White

    # Find dev_dependencies section
    if ($content -notmatch "dev_dependencies:") {
        Write-Host "  ❌ No dev_dependencies section found" -ForegroundColor Red
        $script:failed += $AppName
        return
    }

    # Add integration_test after dev_dependencies:
    # Strategy: Add after flutter_test or at the end of dev_dependencies
    $newContent = $content

    # Try to add after flutter_test
    if ($content -match "(dev_dependencies:.*?flutter_test:\s*\n\s*sdk:\s*flutter\s*\n)") {
        $replacement = $Matches[1] + "  integration_test:`n    sdk: flutter`n"
        $newContent = $content -replace [regex]::Escape($Matches[1]), $replacement
    }
    # Try to add after flutter_lints
    elseif ($content -match "(dev_dependencies:.*?flutter_lints:\s*[^\n]+\n)") {
        $replacement = $Matches[1] + "  integration_test:`n    sdk: flutter`n"
        $newContent = $content -replace [regex]::Escape($Matches[1]), $replacement
    }
    # Add right after dev_dependencies:
    else {
        $newContent = $content -replace "(dev_dependencies:\s*\n)", "`$1  integration_test:`n    sdk: flutter`n"
    }

    if ($DryRun) {
        Write-Host "  🔍 DRY RUN - Would update pubspec.yaml" -ForegroundColor Cyan
        $script:updated += $AppName
    } else {
        try {
            Set-Content -Path $pubspecPath -Value $newContent -NoNewline
            Write-Host "  ✅ Updated pubspec.yaml" -ForegroundColor Green
            $script:updated += $AppName
        } catch {
            Write-Host "  ❌ Failed to update: $_" -ForegroundColor Red
            $script:failed += $AppName
        }
    }
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

Write-Header "BATCH ADD INTEGRATION_TEST - BEAST MODE 5.2"

$appList = Get-AppList
$totalApps = $appList.Count
$currentCategory = if ($Category) { $Category } else { "productivity" }

Write-Host "📋 Apps to update: $totalApps" -ForegroundColor White
Write-Host "📁 Category: $currentCategory" -ForegroundColor White

if ($DryRun) {
    Write-Host "🔍 DRY RUN MODE - No files will be modified" -ForegroundColor Cyan
}

Write-Host ""

# Process each app
foreach ($app in $appList) {
    Write-Host "Processing: $app" -ForegroundColor White
    Add-IntegrationTestDependency -AppName $app -Category $currentCategory
}

# =============================================================================
# SUMMARY
# =============================================================================

Write-Header "SUMMARY"

Write-Host "✅ Updated:  $($script:updated.Count)/$totalApps" -ForegroundColor Green
Write-Host "⚠️  Skipped:  $($script:skipped.Count)/$totalApps" -ForegroundColor Yellow
Write-Host "❌ Failed:   $($script:failed.Count)/$totalApps" -ForegroundColor Red
Write-Host ""

if ($script:updated.Count -gt 0) {
    Write-Host "Updated apps:" -ForegroundColor Green
    $script:updated | ForEach-Object { Write-Host "  • $_" -ForegroundColor Green }
    Write-Host ""
}

if ($script:skipped.Count -gt 0) {
    Write-Host "Skipped apps:" -ForegroundColor Yellow
    $script:skipped | ForEach-Object { Write-Host "  • $_" -ForegroundColor Yellow }
    Write-Host ""
}

if ($script:failed.Count -gt 0) {
    Write-Host "Failed apps:" -ForegroundColor Red
    $script:failed | ForEach-Object { Write-Host "  • $_" -ForegroundColor Red }
    Write-Host ""
}

# Next steps
Write-Header "NEXT STEPS"

if ($script:updated.Count -gt 0 -and !$DryRun) {
    Write-Host "Run flutter pub get for updated apps:" -ForegroundColor White
    Write-Host "  pwsh tools/batch_pub_get.ps1 -Apps '$($script:updated -join ',')' -Category '$currentCategory'" -ForegroundColor Gray
    Write-Host ""
}

if ($DryRun) {
    Write-Host "Remove -DryRun flag to apply changes" -ForegroundColor Cyan
}

# Exit code
if ($script:failed.Count -gt 0) {
    exit 1
} else {
    exit 0
}
