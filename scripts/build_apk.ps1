# Habit Garden - Build Release APK (PowerShell)
# This script builds a signed release APK for distribution

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Green
Write-Host "Habit Garden - Build Release APK" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

# Check if keystore exists
if (!(Test-Path "android\keystore.jks") -or !(Test-Path "android\key.properties")) {
    Write-Host "⚠️  Release signing not set up!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please run .\scripts\setup_signing.ps1 first to create your keystore."
    Write-Host ""
    Write-Host "Building with debug signature instead..." -ForegroundColor Yellow
    Write-Host ""
}

# Clean previous builds
Write-Host "🧹 Cleaning previous builds..." -ForegroundColor Cyan
flutter clean

# Get dependencies
Write-Host "📦 Getting dependencies..." -ForegroundColor Cyan
flutter pub get

# Build release APK
Write-Host "🔨 Building release APK..." -ForegroundColor Cyan
flutter build apk --release

# Check if build succeeded
$APK_PATH = "build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $APK_PATH) {
    $APK_SIZE = (Get-Item $APK_PATH).Length / 1MB
    $APK_SIZE_TEXT = "{0:N2} MB" -f $APK_SIZE
    
    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Green
    Write-Host "✅ Build Successful!" -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "APK Location: $APK_PATH" -ForegroundColor Cyan
    Write-Host "APK Size: $APK_SIZE_TEXT" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "You can now distribute this APK file."
    Write-Host "To host on a website, serve with MIME type: application/vnd.android.package-archive"
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "❌ Build failed! APK not found at expected location." -ForegroundColor Red
    Write-Host ""
    exit 1
}

