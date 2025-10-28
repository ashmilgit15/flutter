# 📦 Build Instructions for Habit Garden

This document provides detailed instructions for building and distributing the Habit Garden Android app.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Development Build](#development-build)
- [Release Build (Unsigned)](#release-build-unsigned)
- [Release Build (Signed)](#release-build-signed)
- [Distribution](#distribution)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Software
1. **Flutter SDK** (3.9.2 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Add Flutter to your PATH

2. **Android Studio** or **VS Code**
   - Android Studio: https://developer.android.com/studio
   - VS Code with Flutter extension

3. **Android SDK**
   - Install via Android Studio SDK Manager
   - Required: API Level 23 (Android 6.0) minimum
   - Recommended: API Level 34 (Android 14)

4. **Java Development Kit (JDK) 11+**
   - Required for building Android apps
   - Can be installed via Android Studio

### Verify Installation

```bash
# Check Flutter installation
flutter doctor

# Expected output: All checks should pass
# [✓] Flutter (Channel stable, 3.9.2...)
# [✓] Android toolchain - develop for Android devices
# [✓] Android Studio
```

## Development Build

Development builds are for testing on physical devices or emulators during development.

### Steps

1. **Navigate to project directory**
   ```bash
   cd habit_garden
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Connect device or start emulator**
   ```bash
   # List available devices
   flutter devices
   ```

4. **Run in debug mode**
   ```bash
   flutter run
   
   # Or specify a device
   flutter run -d <device-id>
   ```

5. **Build debug APK** (optional)
   ```bash
   flutter build apk --debug
   ```
   
   Output location: `build/app/outputs/flutter-apk/app-debug.apk`

## Release Build (Unsigned)

Unsigned release builds can be distributed for testing but won't install on most devices without developer mode enabled.

### Steps

1. **Build release APK**
   ```bash
   flutter build apk --release
   ```

2. **Locate the APK**
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

3. **APK Size Optimization** (optional)
   ```bash
   # Build split APKs per ABI (smaller size)
   flutter build apk --split-per-abi --release
   
   # This creates 3 APKs:
   # - app-armeabi-v7a-release.apk (ARM 32-bit)
   # - app-arm64-v8a-release.apk (ARM 64-bit)
   # - app-x86_64-release.apk (x86 64-bit)
   ```

## Release Build (Signed)

Signed APKs are required for public distribution and Google Play Store submission.

### Step 1: Generate Signing Key

**One-time setup** - Keep this keystore file safe and never commit it to version control!

```bash
# Windows (Command Prompt)
keytool -genkey -v -keystore %USERPROFILE%\habit-garden-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias habit-garden

# macOS/Linux
keytool -genkey -v -keystore ~/habit-garden-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias habit-garden
```

**Important**: Remember the passwords you set! You'll need them for every build.

### Step 2: Create Key Properties File

Create a file named `key.properties` in the `android/` directory:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=habit-garden
storeFile=C:/Users/YourName/habit-garden-key.jks
```

**Security**: Add `key.properties` to `.gitignore`:
```bash
echo "key.properties" >> android/.gitignore
```

### Step 3: Configure Build Gradle

Edit `android/app/build.gradle.kts` and add the signing configuration:

```kotlin
// Load keystore properties
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing config ...
    
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            
            // Optional: Enable ProGuard for smaller APK
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}
```

### Step 4: Build Signed APK

```bash
flutter build apk --release
```

Your signed APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

### Step 5: Verify Signature

```bash
# Check APK signature
keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk
```

## Distribution

### Option 1: Direct APK Distribution

1. **Upload to your web server**
   ```bash
   # Example with SCP
   scp build/app/outputs/flutter-apk/app-release.apk user@yourserver.com:/var/www/html/downloads/
   ```

2. **Use the included landing page**
   - Customize `landing-page/index.html`
   - Update download link to your APK location
   - Deploy to GitHub Pages, Netlify, or any static host

3. **Share via cloud storage**
   - Google Drive (make sure sharing is enabled)
   - Dropbox
   - OneDrive

### Option 2: Google Play Store

1. **Create a Google Play Developer account** ($25 one-time fee)

2. **Generate App Bundle** (preferred over APK)
   ```bash
   flutter build appbundle --release
   ```
   
   Output: `build/app/outputs/bundle/release/app-release.aab`

3. **Upload to Play Console**
   - Go to: https://play.google.com/console
   - Create new app
   - Upload the `.aab` file
   - Complete store listing
   - Submit for review

### Option 3: Alternative App Stores

- **Amazon Appstore**
- **Samsung Galaxy Store**
- **F-Droid** (requires open-source build)

## File Size Optimization

### Current APK Size
- Debug: ~60-80 MB
- Release (unsigned): ~20-30 MB
- Release (signed, optimized): ~15-25 MB
- Split APKs: ~10-15 MB each

### Further Optimization

1. **Remove unused resources**
   ```bash
   # Analyze APK size
   flutter build apk --analyze-size --target-platform android-arm64
   ```

2. **Use split APKs**
   ```bash
   flutter build apk --split-per-abi --release
   ```

3. **Enable R8 shrinking** (already configured in gradle)

## Troubleshooting

### Issue: "Flutter not found"
```bash
# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"  # macOS/Linux
set PATH=%PATH%;C:\flutter\bin         # Windows
```

### Issue: "SDK license not accepted"
```bash
flutter doctor --android-licenses
```

### Issue: "Gradle build failed"
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build apk --release
```

### Issue: "Key was created with errors"
- Make sure you use JDK 11 or higher
- Use the exact keytool command provided above

### Issue: "APK won't install on device"
- For unsigned APKs: Enable "Install from unknown sources" on device
- For signed APKs: Verify signature with keytool command
- Check minimum SDK version (API 23 / Android 6.0)

### Issue: "Build takes too long"
```bash
# Use local gradle daemon
mkdir ~/.gradle
echo "org.gradle.daemon=true" >> ~/.gradle/gradle.properties
```

## Performance Testing

### Check APK Contents
```bash
# Windows
7z l build/app/outputs/flutter-apk/app-release.apk

# macOS/Linux
unzip -l build/app/outputs/flutter-apk/app-release.apk
```

### Install and Test
```bash
# Install on connected device
adb install build/app/outputs/flutter-apk/app-release.apk

# Check logs
adb logcat | grep flutter
```

## Continuous Integration

### GitHub Actions Example

Create `.github/workflows/build.yml`:

```yaml
name: Build APK

on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.9.2'
      - run: flutter pub get
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v3
        with:
          name: release-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

## Versioning

To update version for new releases:

1. Edit `pubspec.yaml`:
   ```yaml
   version: 1.1.0+2  # version name + build number
   ```

2. Rebuild:
   ```bash
   flutter build apk --release
   ```

## Support

For build issues:
1. Check `flutter doctor -v` output
2. Review error logs carefully
3. Search Flutter GitHub issues
4. Ask on Flutter Discord/Stack Overflow

---

**Last Updated**: October 2024
**Flutter Version**: 3.9.2
**Target SDK**: Android 14 (API 34)
