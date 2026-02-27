# reconcile_tests.ps1
# Injects the Ultimate Testing Blitz into all apps in /apps/

$AppDirs = Get-ChildItem -Path "apps" -Directory -Recurse | Where-Object { Test-Path "$($_.FullName)\pubspec.yaml" }

foreach ($AppDir in $AppDirs) {
    Write-Host "Reconciling tests for: $($AppDir.Name)" -ForegroundColor Cyan
    
    # 1. Update pubspec.yaml dev_dependencies
    $PubspecPath = "$($AppDir.FullName)\pubspec.yaml"
    $Content = Get-Content $PubspecPath -Raw
    
    if ($Content -notmatch "testing_factory") {
        $Search = "dev_dependencies:"
        $Replace = "dev_dependencies:`n  testing_factory:`n    path: ../../../packages/core/testing_factory`n  golden_toolkit: ^0.15.0`n  mocktail: ^1.0.4`n  riverpod_test: ^2.6.1"
        $Content = $Content -replace [regex]::Escape($Search), $Replace
        Set-Content -Path $PubspecPath -Value $Content
    }

    # 2. Create standardized folders
    New-Item -ItemType Directory -Force -Path "$($AppDir.FullName)\test\visual"
    New-Item -ItemType Directory -Force -Path "$($AppDir.FullName)\test\functional"
    New-Item -ItemType Directory -Force -Path "$($AppDir.FullName)\test\performance"
    New-Item -ItemType Directory -Force -Path "$($AppDir.FullName)\test\a11y"
}

Write-Host "✅ All apps reconciled for Testing Blitz!" -ForegroundColor Green
