# Habit Garden - Build Instructions

## Quick Start

### For Windows Users

```powershell
# 1. Setup signing (first time only)
.\scripts\setup_signing.ps1

# 2. Build APK
.\scripts\build_apk.ps1
```

### For macOS/Linux Users

```bash
# 1. Setup signing (first time only)
./scripts/setup_signing.sh

# 2. Build APK
./scripts/build_apk.sh
```

## Important: Path with Spaces

⚠️ **If your path contains spaces** (e.g., "Ashmil P"), the build will fail.

**Quick fix - Move project:**
```powershell
# Windows
move "C:\Users\Ashmil P\Desktop\Flutter\habit_garden" "C:\Projects\habit_garden"
cd C:\Projects\habit_garden
```

**Or use a junction:**
```powershell
# Windows
mklink /J C:\HabitGarden "C:\Users\Ashmil P\Desktop\Flutter\habit_garden"
cd C:\HabitGarden
```

## APK Location

After building, find your APK at:
```
build/app/outputs/flutter-apk/app-release.apk
```

## Manual Build Steps

```bash
# 1. Create keystore (first time)
keytool -genkey -v -keystore android/keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias app_key

# 2. Create android/key.properties
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=app_key
storeFile=../keystore.jks

# 3. Build
flutter clean
flutter pub get
flutter build apk --release
```

## See RELEASE_NOTES.md for Complete Documentation
