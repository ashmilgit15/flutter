# ⚡ Quick Start Guide

Get Habit Garden running in 5 minutes!

## Prerequisites Check

Do you have these installed?
- [ ] Flutter SDK (3.9.2+)
- [ ] Android Studio or VS Code
- [ ] Android SDK
- [ ] Java JDK 11+

**Don't have them?** See [SETUP_GUIDE.md](./SETUP_GUIDE.md) for detailed installation.

## Run the App (3 Steps)

### 1. Install Dependencies
```bash
cd habit_garden
flutter pub get
```

### 2. Connect a Device
```bash
# Start an emulator or connect phone via USB
flutter devices
```

### 3. Run!
```bash
flutter run
```

**That's it!** The app will launch on your device.

## Build APK (1 Command)

```bash
flutter build apk --release
```

Find your APK at: `build/app/outputs/flutter-apk/app-release.apk`

## Common Issues

### "Flutter not found"
- Add Flutter to your PATH
- Windows: `C:\flutter\bin`
- See: [SETUP_GUIDE.md](./SETUP_GUIDE.md)

### "No devices"
- Start Android emulator, or
- Connect phone with USB debugging enabled

### "Gradle build failed"
```bash
flutter clean
flutter pub get
flutter run
```

## Project Files

```
📁 habit_garden/
├── 📄 README.md              ← Start here
├── 📄 QUICK_START.md         ← You are here
├── 📄 SETUP_GUIDE.md         ← Detailed setup
├── 📄 BUILD_INSTRUCTIONS.md  ← Build & sign APKs
├── 📄 DEPLOYMENT_GUIDE.md    ← Distribution guide
├── 📄 FEATURES.md            ← Complete feature list
├── 📁 lib/                   ← All Dart code
├── 📁 android/               ← Android config
├── 📁 assets/                ← Sounds (optional)
├── 📁 landing-page/          ← HTML for distribution
└── 📄 pubspec.yaml           ← Dependencies
```

## Essential Commands

```bash
# Development
flutter run              # Run app
flutter clean            # Clean build
flutter pub get          # Install dependencies

# Building
flutter build apk        # Build APK
flutter build appbundle  # Build for Play Store

# Testing
flutter test             # Run tests
flutter doctor           # Check setup

# Analysis
flutter analyze          # Check for issues
flutter format lib/      # Format code
```

## Hot Reload

While app is running:
- **r** = Hot reload (fast, keeps state)
- **R** = Hot restart (slower, resets state)
- **q** = Quit

## Next Steps

1. ✅ Got the app running? Great!
2. 📖 Read [README.md](./README.md) for features
3. 🏗️ Ready to build? See [BUILD_INSTRUCTIONS.md](./BUILD_INSTRUCTIONS.md)
4. 🚀 Ready to deploy? See [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)

## Need Help?

- **Setup issues**: [SETUP_GUIDE.md](./SETUP_GUIDE.md)
- **Build issues**: [BUILD_INSTRUCTIONS.md](./BUILD_INSTRUCTIONS.md)
- **Flutter issues**: Run `flutter doctor -v`

---

**Happy coding! 🌱**
