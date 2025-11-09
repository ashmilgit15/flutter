# Habit Garden - Android Deployment Guide

## Overview
Habit Garden is a Flutter habit tracker app optimized for Android deployment. This guide provides step-by-step instructions for building, signing, and distributing the APK.

## Prerequisites
- Flutter SDK 3.35.7
- Dart SDK 3.9.2
- Android SDK with build tools
- Java JDK 11 or higher
- Git

## Quick Start Build Commands

### 1. Local Debug Build (Testing)
```bash
flutter clean
flutter pub get
flutter build apk --debug
```
**Output:** `build/app/outputs/flutter-apk/app-debug.apk`

### 2. Local Release Build (Production)
```bash
flutter clean
flutter pub get
flutter build apk --release
```
**Output:** `build/app/outputs/flutter-apk/app-release.apk`

## Signed Release APK (For Distribution)

### Step 1: Generate Keystore (One-time setup)
```bash
# Create keystore directory
mkdir -p android/app/keystore

# Generate keystore
keytool -genkey -v -keystore android/app/keystore/upload-keystore.jks \
  -storetype JKS \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload \
  -storepass YOUR_STORE_PASSWORD \
  -keypass YOUR_KEY_PASSWORD \
  -dname "CN=Your Name, OU=Your Organization, O=Your Company, L=Your City, ST=Your State, C=Your Country"
```

**⚠️ IMPORTANT:** Never commit the keystore file to version control!

### Step 2: Configure Signing
Create `android/key.properties` (local file, not committed):
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=keystore/upload-keystore.jks
```

Update `.gitignore` to exclude sensitive files:
```gitignore
# Keystore files
android/app/keystore/
*.jks
*.keystore

# Signing config
android/key.properties
```

### Step 3: Build Signed APK
```bash
flutter clean
flutter pub get
flutter build apk --release
```

**Output:** `build/app/outputs/flutter-apk/app-release.apk`

### Step 4: Verify APK
```bash
# Install on connected device
adb install -r build/app/outputs/flutter-apk/app-release.apk

# Or verify signature
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk
```

## Distribution Options

### Option 1: GitHub Releases (Recommended - Free)

#### Manual Upload
1. Create a GitHub Release:
   - Go to your repository
   - Click "Releases" → "Create a new release"
   - Tag: `v1.0.0` (increment for each release)
   - Title: `Habit Garden v1.0.0`
   - Description: Release notes
   - Attach: `app-release.apk`

2. Copy the download URL from the release assets

#### Website Integration
```html
<!-- Download button linking to GitHub Release -->
<a href="https://github.com/YOUR_USERNAME/YOUR_REPO/releases/download/v1.0.0/app-release.apk"
   download="habit-garden-v1.0.0.apk">
  <button>Download Habit Garden APK</button>
</a>
```

### Option 2: Self-Hosted (Requires web hosting)

#### Server Configuration
Ensure your server serves APK with correct MIME type:

**Apache (.htaccess):**
```apache
<Files "*.apk">
  Header set Content-Type "application/vnd.android.package-archive"
  Header set Content-Disposition "attachment; filename=\"habit-garden.apk\""
</Files>
```

**Nginx:**
```nginx
location ~* \.apk$ {
  add_header Content-Type "application/vnd.android.package-archive";
  add_header Content-Disposition "attachment; filename=\"habit-garden.apk\"";
}
```

#### Upload and Link
```html
<a href="https://yourwebsite.com/downloads/habit-garden.apk"
   download="habit-garden.apk">
  Download Habit Garden
</a>
```

## CI/CD with GitHub Actions (Optional - Free)

### Setup Instructions

1. **Configure Secrets** (GitHub → Repository → Settings → Secrets and variables → Actions):
   - `KEYSTORE_BASE64`: Base64 encoded keystore file
   - `KEYSTORE_PASSWORD`: Your keystore password
   - `KEY_ALIAS`: upload
   - `KEY_PASSWORD`: Your key password

2. **Generate Base64 Keystore**:
   ```bash
   # On your local machine
   base64 -i android/app/keystore/upload-keystore.jks
   # Copy the output to KEYSTORE_BASE64 secret
   ```

3. **The workflow** (`.github/workflows/android-release.yml`) will:
   - Build on every push to `main` branch
   - Create signed APK
   - Upload as release artifact
   - Optionally create GitHub Release

### Workflow Features
- ✅ Automatic builds on push/PR
- ✅ Signed APK generation
- ✅ Artifact uploads
- ✅ Release creation
- ✅ No cost (GitHub Actions free tier)

## Build Scripts

### Quick Build Script (`scripts/build_apk.sh`)
```bash
#!/bin/bash
set -e

echo "Building Habit Garden APK..."

# Check if keystore exists
if [ ! -f "android/app/keystore/upload-keystore.jks" ]; then
    echo "❌ Keystore not found. Run keystore generation first."
    exit 1
fi

# Clean and build
flutter clean
flutter pub get
flutter build apk --release

# Copy to releases folder
mkdir -p releases
cp build/app/outputs/flutter-apk/app-release.apk \
   releases/habit-garden-v$(grep 'version:' pubspec.yaml | cut -d' ' -f2 | cut -d'+' -f1).apk

echo "✅ APK built successfully: releases/habit-garden-v$(grep 'version:' pubspec.yaml | cut -d' ' -f2 | cut -d'+' -f1).apk"
```

### Windows Build Script (`scripts/build_apk_windows.ps1`)
```powershell
Write-Host "Building Habit Garden APK..."

# Check keystore
if (!(Test-Path "android/app/keystore/upload-keystore.jks")) {
    Write-Error "Keystore not found. Run keystore generation first."
    exit 1
}

# Clean and build
flutter clean
flutter pub get
flutter build apk --release

# Copy to releases
New-Item -ItemType Directory -Force -Path releases
$version = (Get-Content pubspec.yaml | Select-String "version:").ToString().Split(" ")[1].Split("+")[0]
Copy-Item "build/app/outputs/flutter-apk/app-release.apk" "releases/habit-garden-v$version.apk"

Write-Host "APK built successfully: releases/habit-garden-v$version.apk"
```

## Troubleshooting

### Build Issues
```bash
# Clean everything
flutter clean
flutter pub cache repair

# Check Flutter setup
flutter doctor

# Rebuild dependencies
flutter pub get
```

### Signing Issues
- Verify `key.properties` path is correct
- Ensure passwords don't contain special characters
- Check keystore alias matches

### Distribution Issues
- APK must be signed for Play Store/Google Play
- For direct download, ensure HTTPS
- MIME type must be `application/vnd.android.package-archive`

## File Structure After Build
```
habit_garden/
├── build/app/outputs/flutter-apk/
│   └── app-release.apk          # Main APK file
├── releases/                     # Organized releases (optional)
│   └── habit-garden-v1.0.0.apk
├── android/app/keystore/         # Keystore (local only)
└── android/key.properties       # Signing config (local only)
```

## Security Notes
- 🔒 Never commit keystore files
- 🔒 Use strong passwords
- 🔒 Store secrets securely in CI/CD
- 🔒 Use HTTPS for APK downloads
- 🔒 Verify APK signatures before distribution

## Support
- Test on multiple Android devices
- Check Android version compatibility (API 21+)
- Validate notification permissions
- Test offline functionality
