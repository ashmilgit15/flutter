# 🌱 Habit Garden

A calming, gamified habit tracker where you grow a virtual garden by maintaining daily habits.

![Version](https://img.shields.io/badge/version-1.0.0-green.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.35.7-blue.svg)
![Platform](https://img.shields.io/badge/platform-Android-brightgreen.svg)
![Tests](https://img.shields.io/badge/tests-passing-brightgreen.svg)

## 📖 Overview

**Habit Garden** transforms habit tracking into a peaceful gardening experience. Complete your daily habits to nurture virtual plants, build streaks, and unlock new varieties. Miss a habit, and your plant may wilt—but you can always revive it and start fresh!

### ✨ Features

- 🌿 **Virtual Garden**: Each habit grows a unique plant
- 📈 **Growth Stages**: Seed → Sprout → Bloom → Full Plant (based on streaks)
- 🔔 **Smart Notifications**: AI-powered reminders that learn your routine
- 💰 **Sunlight Currency**: Earn rewards for consistency
- 🎨 **Seasonal Themes**: Spring, Summer, Autumn, Winter
- 🛍️ **Shop System**: Unlock new plants and decorations
- 💾 **Offline First**: All data stored locally with Hive
- 🎵 **Ambient Sounds**: Calming background music (optional)
- 🔄 **Plant Revival**: Second chances with the sunlight system

## 🎉 Latest Updates (v1.0.0 - October 2025)

**Ready-to-distribute APK now available!** This release includes:
- ✅ All code fixes and dependency updates applied
- ✅ Comprehensive test suite (9 tests passing)
- ✅ Optimized release build (49.3 MB)
- ✅ All packages verified as FREE and open-source
- ✅ Build scripts for easy deployment

📄 **[View Complete Release Notes →](RELEASE_NOTES.md)**

### Quick Build
```bash
git checkout cursor-fixes
flutter pub get
flutter build apk --release
# APK: build/app/outputs/flutter-apk/app-release.apk (49.3 MB)
```

### For Production Signing
```bash
# Windows
.\scripts\setup_signing_windows.ps1
.\scripts\build_apk_windows.ps1

# Linux/macOS
./scripts/setup_signing.sh
./scripts/build_apk.sh
```

## 🏗️ Architecture

```
lib/
├── models/              # Data models with Hive
│   ├── habit.dart
│   ├── user_profile.dart
│   └── plant_catalog.dart
├── services/            # Business logic layer
│   ├── storage_service.dart
│   ├── notification_service.dart
│   ├── audio_service.dart
│   └── iap_service.dart
├── providers/           # State management (Provider)
│   └── habit_provider.dart
├── screens/             # UI screens
│   ├── onboarding_screen.dart
│   ├── home_screen.dart
│   ├── add_habit_screen.dart
│   ├── shop_screen.dart
│   └── settings_screen.dart
├── widgets/             # Reusable components
│   ├── plant_widget.dart
│   └── habit_card.dart
├── utils/               # Utilities
│   └── theme.dart
└── main.dart           # App entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.35.7 (or compatible version)
- Dart SDK 3.9.2
- Android Studio or VS Code
- Android SDK (API 23+ / Android 6.0+)
- Java JDK 11+

### Installation

1. **Clone or extract the project**
   ```bash
   cd habit_garden
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # Debug mode
   flutter run

   # Release mode
   flutter run --release
   ```

## 📦 Building APK

### Debug APK (for testing)

```bash
flutter build apk --debug
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`

### Release APK (unsigned - for distribution)

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Signed Release APK (production)

1. **Generate a keystore** (one-time setup):
   ```bash
   keytool -genkey -v -keystore ~/habit-garden-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias habit-garden
   ```

2. **Create `android/key.properties`**:
   ```properties
   storePassword=<your-store-password>
   keyPassword=<your-key-password>
   keyAlias=habit-garden
   storeFile=<path-to-keystore>/habit-garden-key.jks
   ```

3. **Update `android/app/build.gradle.kts`** to use signing config (see BUILD_INSTRUCTIONS.md)

4. **Build signed APK**:
   ```bash
   flutter build apk --release
   ```

## 🎯 Usage Guide

### First Launch
1. Complete the onboarding flow
2. Choose 3 starter habits
3. Select plants for each habit
4. Name your plants

### Daily Workflow
1. Open the app to see your garden
2. Tap habits to mark them complete
3. Watch your plants grow!
4. Earn sunlight (☀️) for each completion
5. Build streaks for faster growth

### Growth Milestones
- **7 days**: Plant reaches Sprout stage 🌱
- **14 days**: Plant reaches Bloom stage 🌸
- **21 days**: Plant reaches Full Growth 🌳

### Unlocking Content
- Visit the **Shop** tab
- Spend sunlight to unlock new plants
- Unlock decorations for your garden
- Premium plants cost more but are worth it!

## 🔧 Configuration

### Adding Custom Audio
1. Place audio files in `assets/sounds/`
2. Uncomment playback lines in `lib/services/audio_service.dart`
3. Run `flutter pub get` to rebuild assets

### Customizing Plants
Edit `lib/models/plant_catalog.dart` to add new plant types or adjust unlock costs.

### Notification Scheduling
Smart reminders adapt to your completion patterns. To adjust default times, edit `lib/services/notification_service.dart`.

## 📱 Supported Platforms

- ✅ Android (6.0+)
- ⚠️ iOS (ready but needs signing)
- ⚠️ Web (experimental)

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run with coverage
flutter test --coverage
```

## 🔧 Recent Fixes (Production Ready)

**Version 1.0.0 - Production Release**
- ✅ **Fixed blank screen crash** - Removed in_app_purchase causing LateInitializationError
- ✅ **Resolved RenderFlex overflow** - Added scrollable containers to onboarding screens
- ✅ **Optimized performance** - Added const constructors and proper error handling
- ✅ **Successful builds** - Android APK (48.7MB) and Web builds working
- ✅ **100% FREE** - Removed all paid dependencies and features

## 🐛 Known Issues

- Audio requires actual sound files (hooks are in place)
- iOS requires Apple Developer account for distribution

## 📄 License

This project is open source and available for personal use.

## 🙏 Acknowledgments

- Emoji icons from Unicode Standard
- Flutter framework and community
- Hive for efficient local storage
- Google Fonts for beautiful typography

## 📞 Support

For issues or questions, please open an issue on the repository.

---

**Made with 💚 and Flutter**
