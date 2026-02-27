# Pre-Build Validation Script - Beast Mode 5.2
# Usage: pwsh tools/pre_build_check.ps1 -AppPath "apps/productivity/my_app"

param(
    [Parameter(Mandatory=$true)]
    [string]$AppPath,

    [switch]$DetailedOutput,
    [switch]$AutoFix
)

$ErrorActionPreference = "Stop"
$script:errors = @()
$script:warnings = @()
$script:fixes = @()

function Write-Status {
    param([string]$Message, [string]$Type = "INFO")

    $color = switch ($Type) {
        "SUCCESS" { "Green" }
        "ERROR" { "Red" }
        "WARNING" { "Yellow" }
        default { "White" }
    }

    $prefix = switch ($Type) {
        "SUCCESS" { "✅" }
        "ERROR" { "❌" }
        "WARNING" { "⚠️" }
        default { "ℹ️" }
    }

    Write-Host "$prefix $Message" -ForegroundColor $color
}

function Test-FileExists {
    param([string]$Path)
    return Test-Path (Join-Path $AppPath $Path)
}

function Get-FileContent {
    param([string]$Path)
    $fullPath = Join-Path $AppPath $Path
    if (Test-Path $fullPath) {
        return Get-Content $fullPath -Raw
    }
    return $null
}

function Get-AppLinesOfCode {
    $libPath = Join-Path $AppPath "lib"
    if (!(Test-Path $libPath)) {
        return 0
    }

    $dartFiles = Get-ChildItem $libPath -Recurse -Filter "*.dart" -File
    if ($dartFiles.Count -eq 0) {
        return 0
    }

    $totalBytes = ($dartFiles | Measure-Object -Property Length -Sum).Sum

    # Aproximação: 100 bytes ≈ 1 LOC
    return [int]($totalBytes / 100)
}

# =============================================================================
# CHECK 1: Pubspec.yaml validation
# =============================================================================
function Test-PubspecYaml {
    if ($DetailedOutput) { Write-Host "Checking pubspec.yaml..." -ForegroundColor Gray }

    if (!(Test-FileExists "pubspec.yaml")) {
        $script:errors += "pubspec.yaml not found"
        return
    }

    $pubspec = Get-FileContent "pubspec.yaml"

    # Check integration_test
    if ($pubspec -notmatch "integration_test:") {
        $script:warnings += "integration_test dependency missing"
        if ($AutoFix) {
            $script:fixes += "Add integration_test to dev_dependencies"
        }
    }

    # Check flutter_riverpod version
    if ($pubspec -match "flutter_riverpod:\s*\^\s*2\.") {
        $script:errors += "Riverpod 2.x detected - migrate to 3.x (Notifier pattern)"
    }

    # Check for code generation in simple apps
    $hasCodegen = ($pubspec -match "riverpod_annotation") -or
                  ($pubspec -match "freezed:") -or
                  ($pubspec -match "build_runner:")

    if ($hasCodegen) {
        $loc = Get-AppLinesOfCode
        if ($loc -lt 1000) {
            $script:errors += "Code generation (riverpod_annotation/freezed) in simple app (<1000 LOC = $loc LOC)"
            $script:errors += "  → Use manual Notifier pattern instead (see copilot-instructions.md Section 72.1)"
        } else {
            Write-Status "Code generation OK (app has $loc LOC)" "SUCCESS"
        }
    }

    # Check package name
    if ($pubspec -match "name:\s*(\w+)") {
        $packageName = $Matches[1]
        if ($DetailedOutput) {
            Write-Status "Package name: $packageName" "INFO"
        }
    }
}

# =============================================================================
# CHECK 2: L10n configuration
# =============================================================================
function Test-L10nSetup {
    if ($DetailedOutput) { Write-Host "Checking l10n setup..." -ForegroundColor Gray }

    if (!(Test-FileExists "l10n.yaml")) {
        $script:errors += "l10n.yaml missing - run 'flutter gen-l10n' will fail"
        return
    }

    # Check for .arb files
    $l10nPath = Join-Path $AppPath "lib/l10n"
    if (Test-Path $l10nPath) {
        $arbFiles = Get-ChildItem $l10nPath -Filter "*.arb"
        if ($arbFiles.Count -lt 11) {
            $script:warnings += "Only $($arbFiles.Count) .arb files found (expected 11 languages)"
        }
    }
}

# =============================================================================
# CHECK 3: Invalid test boilerplate
# =============================================================================
function Test-TestBoilerplate {
    if ($DetailedOutput) { Write-Host "Checking test files..." -ForegroundColor Gray }

    $testFile = "test/widget_test.dart"
    if (Test-FileExists $testFile) {
        $content = Get-FileContent $testFile

        if ($content -match "MyApp|UnitConverterApp") {
            $script:warnings += "Invalid test boilerplate detected in $testFile"
            $script:warnings += "  → Delete file or create valid test"

            if ($AutoFix) {
                $fullPath = Join-Path $AppPath $testFile
                Remove-Item $fullPath -Force
                $script:fixes += "Deleted invalid $testFile"
            }
        }
    }

    # Check integration_test
    $integrationFile = "integration_test/app_test.dart"
    if (Test-FileExists $integrationFile) {
        $content = Get-FileContent $integrationFile
        if ($content -match "MyApp|example") {
            $script:warnings += "Invalid integration test in $integrationFile"

            if ($AutoFix) {
                $fullPath = Join-Path $AppPath $integrationFile
                Remove-Item $fullPath -Force
                $script:fixes += "Deleted invalid $integrationFile"
            }
        }
    }
}

# =============================================================================
# CHECK 4: Provider pattern validation
# =============================================================================
function Test-ProviderPattern {
    if ($DetailedOutput) { Write-Host "Checking provider patterns..." -ForegroundColor Gray }

    $providersPath = Join-Path $AppPath "lib/src/providers"
    if (!(Test-Path $providersPath)) {
        # No providers folder - might be Clean Architecture
        return
    }

    $providerFiles = Get-ChildItem $providersPath -Filter "*_provider.dart" -Recurse

    foreach ($file in $providerFiles) {
        $content = Get-Content $file.FullName -Raw

        # Check for StateNotifier (Riverpod 2.x)
        if ($content -match "extends\s+StateNotifier") {
            $script:errors += "$($file.Name): Using StateNotifier (Riverpod 2.x)"
            $script:errors += "  → Migrate to Notifier (Riverpod 3.x)"
        }

        # Check for StateNotifierProvider
        if ($content -match "StateNotifierProvider") {
            $script:errors += "$($file.Name): Using StateNotifierProvider (Riverpod 2.x)"
            $script:errors += "  → Use NotifierProvider instead"
        }

        # Check for missing part directive with .g.dart
        if (($content -match "part\s+'.*\.g\.dart'") -and
            !(Test-Path $file.FullName.Replace(".dart", ".g.dart"))) {
            $script:warnings += "$($file.Name): References .g.dart but file not generated"
            $script:warnings += "  → Run 'flutter pub run build_runner build'"
        }
    }
}

# =============================================================================
# CHECK 5: Android build configuration
# =============================================================================
function Test-AndroidConfig {
    if ($DetailedOutput) { Write-Host "Checking Android configuration..." -ForegroundColor Gray }

    $buildGradle = "android/app/build.gradle"
    if (Test-FileExists $buildGradle) {
        $content = Get-FileContent $buildGradle

        # Check targetSdk
        if ($content -match "targetSdk\s+(\d+)") {
            $targetSdk = [int]$Matches[1]
            if ($targetSdk -lt 35) {
                $script:warnings += "targetSdk is $targetSdk (recommended: 35)"
            }
        }

        # Check for ProGuard
        if ($content -notmatch "minifyEnabled\s+true") {
            $script:warnings += "ProGuard not enabled (release builds will be larger)"
        }
    }

    # Check AndroidManifest.xml
    $manifest = "android/app/src/main/AndroidManifest.xml"
    if (Test-FileExists $manifest) {
        $content = Get-FileContent $manifest

        # Check package name
        if ($content -match 'package="([^"]+)"') {
            $packageName = $Matches[1]
            if ($packageName -notmatch "^sa\.rezende\.") {
                $script:warnings += "Package name '$packageName' doesn't follow sa.rezende.* pattern"
            }
        }
    }
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

Write-Host "`n🔍 Pre-Build Validation Check" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "App Path: $AppPath`n" -ForegroundColor White

if (!(Test-Path $AppPath)) {
    Write-Status "App path not found: $AppPath" "ERROR"
    exit 1
}

# Run all checks
Test-PubspecYaml
Test-L10nSetup
Test-TestBoilerplate
Test-ProviderPattern
Test-AndroidConfig

# Display results
Write-Host "`n📊 Validation Results:" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan

if ($script:errors.Count -eq 0 -and $script:warnings.Count -eq 0) {
    Write-Status "ALL CHECKS PASSED! App is ready for development." "SUCCESS"
    Write-Host ""
    exit 0
}

# Show errors
if ($script:errors.Count -gt 0) {
    Write-Host "`n❌ ERRORS ($($script:errors.Count)):" -ForegroundColor Red
    foreach ($error in $script:errors) {
        Write-Host "  • $error" -ForegroundColor Red
    }
}

# Show warnings
if ($script:warnings.Count -gt 0) {
    Write-Host "`n⚠️  WARNINGS ($($script:warnings.Count)):" -ForegroundColor Yellow
    foreach ($warning in $script:warnings) {
        Write-Host "  • $warning" -ForegroundColor Yellow
    }
}

# Show fixes applied
if ($script:fixes.Count -gt 0) {
    Write-Host "`n✅ FIXES APPLIED ($($script:fixes.Count)):" -ForegroundColor Green
    foreach ($fix in $script:fixes) {
        Write-Host "  • $fix" -ForegroundColor Green
    }
}

Write-Host "`n📋 Recommendations:" -ForegroundColor Cyan
Write-Host "  1. Fix all errors before proceeding"
Write-Host "  2. Review warnings and address if needed"
Write-Host "  3. Run 'flutter analyze' to validate code"
Write-Host "  4. See .github/copilot-instructions.md for patterns`n"

if ($script:errors.Count -gt 0) {
    exit 1
} else {
    exit 0
}
