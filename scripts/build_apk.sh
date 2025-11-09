#!/bin/bash
set -e

echo "🏗️  Building Habit Garden APK..."

# Check if keystore exists
if [ ! -f "android/app/keystore/upload-keystore.jks" ]; then
    echo "❌ Keystore not found at android/app/keystore/upload-keystore.jks"
    echo "   Run keystore generation first. See DEPLOYMENT.md for instructions."
    exit 1
fi

# Check if key.properties exists
if [ ! -f "android/key.properties" ]; then
    echo "❌ key.properties not found."
    echo "   Create android/key.properties with signing configuration."
    exit 1
fi

echo "🧹 Cleaning previous builds..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🔨 Building release APK..."
flutter build apk --release

# Create releases directory
mkdir -p releases

# Get version from pubspec.yaml
VERSION=$(grep 'version:' pubspec.yaml | cut -d' ' -f2 | cut -d'+' -f1)
OUTPUT_FILE="releases/habit-garden-v${VERSION}.apk"

# Copy APK to releases folder
cp build/app/outputs/flutter-apk/app-release.apk "$OUTPUT_FILE"

echo "✅ APK built successfully!"
echo "   📱 Output: $OUTPUT_FILE"
echo "   📊 Size: $(du -h "$OUTPUT_FILE" | cut -f1)"

# Verify APK if jarsigner is available
if command -v jarsigner >/dev/null 2>&1; then
    echo "🔐 Verifying APK signature..."
    if jarsigner -verify -quiet "$OUTPUT_FILE" 2>/dev/null; then
        echo "   ✅ APK signature verified"
    else
        echo "   ❌ APK signature verification failed"
    fi
fi

echo ""
echo "🚀 Ready for distribution!"
echo "   See DEPLOYMENT.md for upload instructions."