#!/bin/bash
# Habit Garden - Build Release APK
# This script builds a signed release APK for distribution

set -e

echo "=========================================="
echo "Habit Garden - Build Release APK"
echo "=========================================="
echo ""

# Check if keystore exists
if [ ! -f "android/keystore.jks" ] || [ ! -f "android/key.properties" ]; then
    echo "⚠️  Release signing not set up!"
    echo ""
    echo "Please run ./scripts/setup_signing.sh first to create your keystore."
    echo ""
    echo "Building with debug signature instead..."
    echo ""
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build release APK
echo "🔨 Building release APK..."
flutter build apk --release

# Check if build succeeded
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
if [ -f "$APK_PATH" ]; then
    APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
    echo ""
    echo "=========================================="
    echo "✅ Build Successful!"
    echo "=========================================="
    echo ""
    echo "APK Location: $APK_PATH"
    echo "APK Size: $APK_SIZE"
    echo ""
    echo "You can now distribute this APK file."
    echo "To host on a website, serve with MIME type: application/vnd.android.package-archive"
    echo ""
else
    echo ""
    echo "❌ Build failed! APK not found at expected location."
    echo ""
    exit 1
fi

