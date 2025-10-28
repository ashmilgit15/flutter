# 🔧 Setup Guide - Habit Garden

Complete step-by-step guide to set up your development environment and run Habit Garden.

## Prerequisites Installation

### 1. Install Flutter SDK

#### Windows
1. **Download Flutter**
   - Visit: https://docs.flutter.dev/get-started/install/windows
   - Download the Flutter SDK ZIP file
   - Extract to `C:\flutter` (or preferred location)

2. **Add to PATH**
   - Open "Edit system environment variables"
   - Click "Environment Variables"
   - Under "User variables", select "Path"
   - Click "Edit" → "New"
   - Add: `C:\flutter\bin`
   - Click "OK" on all dialogs

3. **Verify Installation**
   ```cmd
   flutter --version
   flutter doctor
   ```

#### macOS
```bash
# Using Homebrew
brew install --cask flutter

# Or download from flutter.dev and add to PATH
export PATH="$PATH:`pwd`/flutter/bin"
```

#### Linux
```bash
# Download and extract
cd ~/development
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.9.2-stable.tar.xz
tar xf flutter_linux_3.9.2-stable.tar.xz

# Add to PATH
export PATH="$PATH:`pwd`/flutter/bin"
```

### 2. Install Android Studio

1. **Download**
   - Visit: https://developer.android.com/studio
   - Download and install

2. **Setup Android SDK**
   - Open Android Studio
   - Go to "More Actions" → "SDK Manager"
   - Install:
     - Android SDK Platform 34 (Android 14)
     - Android SDK Build-Tools
     - Android SDK Platform-Tools
     - Android Emulator

3. **Accept Licenses**
   ```bash
   flutter doctor --android-licenses
   ```
   Type 'y' to accept all

### 3. Install Java JDK 11+

#### Windows
1. Download from: https://adoptium.net/
2. Install and add to PATH
3. Verify: `java -version`

#### macOS
```bash
brew install openjdk@11
```

#### Linux
```bash
sudo apt install openjdk-11-jdk
```

### 4. Install an IDE

**Option A: Android Studio** (Recommended)
- Already installed from step 2
- Install Flutter plugin:
  - File → Settings → Plugins
  - Search "Flutter"
  - Install and restart

**Option B: Visual Studio Code**
```bash
# Download from code.visualstudio.com
# Install extensions:
- Flutter
- Dart
```

## Project Setup

### 1. Navigate to Project

```bash
cd "c:/Users/Ashmil P/Desktop/Flutter/habit_garden"
```

### 2. Install Dependencies

```bash
flutter pub get
```

Expected output:
```
Running "flutter pub get" in habit_garden...
Resolving dependencies... (X.Xs)
✓ Got dependencies!
```

### 3. Verify Project

```bash
flutter doctor -v
```

Check all items are ✓:
- Flutter
- Android toolchain
- Android Studio
- VS Code (if using)
- Connected device / emulator

### 4. Fix Common Issues

#### Issue: cmdline-tools component is missing
```bash
# Open Android Studio
# Tools → SDK Manager → SDK Tools
# Check "Android SDK Command-line Tools"
# Click Apply
```

#### Issue: License not accepted
```bash
flutter doctor --android-licenses
```

#### Issue: No device available
```bash
# Start an emulator:
flutter emulators --launch <emulator-id>

# Or connect a physical device with USB debugging enabled
```

## Running the App

### Method 1: From Command Line

```bash
# List available devices
flutter devices

# Run on connected device
flutter run

# Run in release mode
flutter run --release
```

### Method 2: From Android Studio

1. Open the project in Android Studio
2. Wait for indexing to complete
3. Select a device from the dropdown
4. Click the green "Run" button (▶️)

### Method 3: From VS Code

1. Open the project in VS Code
2. Press F5 or click "Run and Debug"
3. Select "Dart & Flutter"
4. Choose a device

## Building APK

### Development APK (Testing)

```bash
flutter build apk --debug
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`

### Release APK (Distribution)

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Optimized APK (Smaller Size)

```bash
flutter build apk --split-per-abi --release
```

Creates 3 APKs for different architectures.

## Testing on Physical Device

### Android

1. **Enable Developer Options**
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
   - Go back to Settings → Developer Options

2. **Enable USB Debugging**
   - In Developer Options
   - Enable "USB Debugging"

3. **Connect Device**
   - Connect via USB
   - Accept the debugging prompt
   - Verify: `flutter devices`

4. **Run App**
   ```bash
   flutter run
   ```

### Using Wireless Debugging (Android 11+)

```bash
# On device: Settings → Developer Options → Wireless debugging
# Note the IP and port

adb connect <IP>:<PORT>
flutter devices
flutter run
```

## Emulator Setup

### Create Android Emulator

1. Open Android Studio
2. Tools → Device Manager
3. Click "Create Device"
4. Choose a device (e.g., Pixel 6)
5. Download a system image (e.g., Android 14)
6. Finish setup

### Launch Emulator

```bash
# List available emulators
flutter emulators

# Launch an emulator
flutter emulators --launch <emulator-id>

# Or from Android Studio
# Device Manager → Click ▶️ next to emulator
```

## Hot Reload / Hot Restart

While app is running:
- **Hot Reload**: Press 'r' (or Save in IDE)
  - Updates UI instantly
  - Preserves app state
  
- **Hot Restart**: Press 'R'
  - Restarts the app
  - Resets state

## Troubleshooting

### "Gradle build failed"

```bash
# Clean the build
flutter clean
flutter pub get

# Try again
flutter run
```

### "Could not resolve all dependencies"

```bash
# Update Flutter
flutter upgrade

# Clear cache
flutter pub cache repair

# Try again
flutter pub get
```

### "No connected devices"

```bash
# Check device connection
adb devices

# If device not listed:
# - Reconnect USB cable
# - Accept USB debugging prompt
# - Try different USB port
# - Check cable supports data transfer
```

### "Permission denied" errors

```bash
# On macOS/Linux, give executable permissions
chmod +x flutter/bin/flutter
```

### App crashes on startup

```bash
# Check logs
flutter logs

# Run in debug mode for better error messages
flutter run --debug
```

### Build is slow

```bash
# Enable Gradle daemon
mkdir ~/.gradle
echo "org.gradle.daemon=true" >> ~/.gradle/gradle.properties
```

## Project Structure Overview

```
habit_garden/
├── android/               # Android native code
├── assets/               # App assets (sounds, images)
├── build/                # Build output
├── ios/                  # iOS native code (if needed)
├── lib/                  # Dart application code
│   ├── models/           # Data models
│   ├── providers/        # State management
│   ├── screens/          # UI screens
│   ├── services/         # Business logic
│   ├── utils/            # Utilities
│   ├── widgets/          # Reusable widgets
│   └── main.dart         # App entry point
├── landing-page/         # HTML distribution page
├── test/                 # Unit tests
├── pubspec.yaml          # Dependencies
└── README.md             # Documentation
```

## Development Workflow

### Daily Development

1. **Start your day**
   ```bash
   git pull  # If using version control
   flutter pub get  # Get any new dependencies
   ```

2. **Make changes**
   - Edit code in your IDE
   - Save to hot reload
   - Test features

3. **Debug issues**
   ```bash
   flutter run --debug
   # Check console for errors
   # Use DevTools for inspection
   ```

4. **Build for testing**
   ```bash
   flutter build apk --debug
   # Share with testers
   ```

### Before Release

1. **Clean build**
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Run tests**
   ```bash
   flutter test
   ```

3. **Build release**
   ```bash
   flutter build apk --release
   ```

4. **Test on multiple devices**

5. **Update version** in pubspec.yaml

6. **Build final APK**

## Useful Commands

```bash
# Check Flutter version
flutter --version

# Update Flutter
flutter upgrade

# Analyze code
flutter analyze

# Format code
flutter format lib/

# Run tests
flutter test

# Check app size
flutter build apk --analyze-size

# Clean build cache
flutter clean

# Repair packages
flutter pub cache repair

# List available devices
flutter devices

# List available emulators
flutter emulators

# Take screenshot
flutter screenshot

# Install APK on device
flutter install
```

## IDE Tips

### Android Studio
- **Hot Reload**: Ctrl+\ (Win/Linux) or Cmd+\ (Mac)
- **Hot Restart**: Ctrl+Shift+\ or Cmd+Shift+\
- **Run**: Shift+F10 (Win/Linux) or Ctrl+R (Mac)
- **Debug**: Shift+F9 (Win/Linux) or Ctrl+D (Mac)

### VS Code
- **Hot Reload**: Save file or Ctrl+S
- **Hot Restart**: Ctrl+Shift+F5
- **Run**: F5
- **Run without debugging**: Ctrl+F5

## Performance Optimization

### Enable Performance Overlay
```bash
flutter run --profile
# Press 'P' to show performance overlay
```

### Profile Mode
```bash
flutter run --profile
# Better performance than debug
# Still allows profiling
```

### Release Mode
```bash
flutter run --release
# Full optimizations
# No debugging
```

## Next Steps

1. ✅ Complete this setup
2. ✅ Run `flutter doctor` successfully
3. ✅ Run the app in debug mode
4. ✅ Make a test change and hot reload
5. ✅ Build a release APK
6. ✅ Test on a physical device
7. ✅ Read BUILD_INSTRUCTIONS.md for distribution
8. ✅ Deploy using DEPLOYMENT_GUIDE.md

## Getting Help

- **Flutter Docs**: https://docs.flutter.dev
- **Flutter Discord**: https://discord.gg/flutter
- **Stack Overflow**: Tag with `flutter`
- **GitHub Issues**: For project-specific problems

## Additional Resources

- **Flutter Cookbook**: https://docs.flutter.dev/cookbook
- **Widget Catalog**: https://docs.flutter.dev/development/ui/widgets
- **API Reference**: https://api.flutter.dev
- **Pub.dev**: https://pub.dev (package repository)

---

**Setup complete?** Start development with `flutter run`! 🚀

**Need help?** Check the troubleshooting section or create an issue.
