# Build Habit Garden APK
# This script builds a Flutter APK for distribution

Write-Host "=== Habit Garden - APK Build Script ===" -ForegroundColor Green
Write-Host ""

# Navigate to project root
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

# Check if Flutter is available
try {
    $flutterVersion = flutter --version 2>&1 | Select-String "Flutter"
    Write-Host "Flutter found: $flutterVersion" -ForegroundColor Cyan
} catch {
    Write-Host "ERROR: Flutter not found in PATH!" -ForegroundColor Red
    Write-Host "Please install Flutter and add it to your PATH" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Check for signing configuration
$keyPropertiesFile = Join-Path $projectRoot "android\key.properties"
$keystoreFile = Join-Path $projectRoot "android\keystore.jks"

if ((Test-Path $keyPropertiesFile) -and (Test-Path $keystoreFile)) {
    Write-Host "Release signing configured - building signed release APK" -ForegroundColor Green
    $buildType = "release"
} else {
    Write-Host "WARNING: Release signing not configured" -ForegroundColor Yellow
    Write-Host "Building with debug signing (suitable for testing only)" -ForegroundColor Yellow
    Write-Host "To set up release signing, run: .\scripts\setup_signing_windows.ps1" -ForegroundColor Cyan
    Write-Host ""
    $buildType = "debug"
}

# Clean previous builds
Write-Host "Cleaning previous builds..." -ForegroundColor Yellow
flutter clean

# Get dependencies
Write-Host "Getting dependencies..." -ForegroundColor Yellow
flutter pub get

# Build APK
Write-Host ""
Write-Host "Building APK..." -ForegroundColor Yellow

if ($buildType -eq "release") {
    flutter build apk --release
    $apkPath = "build\app\outputs\flutter-apk\app-release.apk"
    $outputName = "habit-garden-v1.0.0-release.apk"
} else {
    flutter build apk --debug
    $apkPath = "build\app\outputs\flutter-apk\app-debug.apk"
    $outputName = "habit-garden-v1.0.0-debug.apk"
}

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "ERROR: Build failed!" -ForegroundColor Red
    exit 1
}

# Copy APK to project root for easy access
if (Test-Path $apkPath) {
    Copy-Item $apkPath -Destination $outputName
    Write-Host ""
    Write-Host "=== Build Successful! ===" -ForegroundColor Green
    Write-Host ""
    Write-Host "APK Location:" -ForegroundColor Cyan
    Write-Host "  - $apkPath" -ForegroundColor White
    Write-Host "  - $outputName (copy in project root)" -ForegroundColor White
    Write-Host ""
    
    $apkSize = (Get-Item $apkPath).Length / 1MB
    Write-Host "APK Size: $([math]::Round($apkSize, 2)) MB" -ForegroundColor Cyan
    Write-Host ""
    
    if ($buildType -eq "debug") {
        Write-Host "NOTE: This is a debug build. For production:" -ForegroundColor Yellow
        Write-Host "  1. Run: .\scripts\setup_signing_windows.ps1" -ForegroundColor White
        Write-Host "  2. Then rebuild to get a release-signed APK" -ForegroundColor White
    } else {
        Write-Host "This APK is signed and ready for distribution!" -ForegroundColor Green
    }
} else {
    Write-Host ""
    Write-Host "ERROR: APK not found at expected location" -ForegroundColor Red
    exit 1
}

