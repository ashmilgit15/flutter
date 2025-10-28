# 🚀 Deployment Guide

Complete guide for deploying Habit Garden to various platforms.

## Table of Contents
- [Quick Start](#quick-start)
- [Building the APK](#building-the-apk)
- [Hosting the Landing Page](#hosting-the-landing-page)
- [Distribution Methods](#distribution-methods)
- [Play Store Submission](#play-store-submission)
- [Updates and Versioning](#updates-and-versioning)

## Quick Start

For a simple, free deployment:

1. **Build the APK**
   ```bash
   flutter build apk --release
   ```

2. **Deploy landing page to GitHub Pages**
   - Upload `landing-page/` folder to GitHub
   - Enable GitHub Pages in repository settings
   - Upload APK to GitHub Releases

3. **Share the link!**

## Building the APK

### Option 1: Quick Build (Testing)

```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build release APK
flutter build apk --release
```

**Output**: `build/app/outputs/flutter-apk/app-release.apk`

### Option 2: Optimized Build (Production)

```bash
# Build split APKs for smaller file size
flutter build apk --split-per-abi --release
```

**Output**: Three APKs (~10-15 MB each)
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM) ← Recommended
- `app-x86_64-release.apk` (x86 devices)

### Option 3: Signed Build (App Stores)

See `BUILD_INSTRUCTIONS.md` for complete signing setup.

## Hosting the Landing Page

### Option 1: GitHub Pages (FREE)

1. **Create a new repository** on GitHub
2. **Upload files**:
   ```
   your-repo/
   ├── index.html (from landing-page/)
   └── habit-garden-v1.0.0.apk
   ```

3. **Enable GitHub Pages**:
   - Go to repository Settings
   - Scroll to "Pages"
   - Select "main" branch
   - Click Save

4. **Update download link** in `index.html`:
   ```html
   <a href="./habit-garden-v1.0.0.apk" class="download-btn" download>
   ```

5. **Access your site**:
   ```
   https://yourusername.github.io/your-repo/
   ```

### Option 2: Netlify (FREE)

1. **Sign up** at netlify.com
2. **Drag and drop** the `landing-page` folder
3. **Upload APK** to the deployed site
4. **Update download link** to match your Netlify URL

### Option 3: Vercel (FREE)

```bash
# Install Vercel CLI
npm install -g vercel

# Deploy from landing-page directory
cd landing-page
vercel

# Follow prompts
```

### Option 4: Firebase Hosting (FREE)

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize
firebase init hosting

# Deploy
firebase deploy
```

### Option 5: Your Own Server

Upload via FTP/SFTP:
```bash
# Example with SCP
scp landing-page/index.html user@yourserver.com:/var/www/html/
scp build/app/outputs/flutter-apk/app-release.apk user@yourserver.com:/var/www/html/downloads/
```

## Distribution Methods

### Method 1: Direct Link Distribution

**Best for**: Personal use, small groups

1. Build and host as described above
2. Share the landing page URL
3. Users download and install

**Pros**: Simple, free, no account needed
**Cons**: Users need to enable unknown sources

### Method 2: Google Play Store

**Best for**: Wide audience, automatic updates

1. **Create developer account** ($25 USD one-time)
2. **Build app bundle**:
   ```bash
   flutter build appbundle --release
   ```
3. **Upload to Play Console**
4. **Complete store listing**:
   - App title, description
   - Screenshots (take from running app)
   - Feature graphic (1024x500px)
   - App icon (512x512px)
5. **Submit for review** (1-3 days)

### Method 3: Amazon Appstore

**Best for**: Additional reach, Kindle devices

1. **Create developer account** (FREE)
2. **Upload APK** to Amazon Developer Console
3. **Complete listing**
4. **Submit for review**

### Method 4: Samsung Galaxy Store

**Best for**: Samsung users

1. **Register as developer** (FREE)
2. **Upload via Galaxy Store Seller Portal**
3. **Complete listing and submit**

### Method 5: GitHub Releases

**Best for**: Open source distribution

1. **Create a release** on GitHub
2. **Upload APK** as release asset
3. **Write release notes**
4. **Link from landing page**

## Play Store Submission Checklist

### Pre-Submission

- [ ] App is fully tested on multiple devices
- [ ] All features work without crashes
- [ ] Privacy policy created (required)
- [ ] Content rating questionnaire completed
- [ ] App signing configured
- [ ] App bundle built (`flutter build appbundle`)

### Assets Required

- [ ] App icon (512x512px, PNG)
- [ ] Feature graphic (1024x500px, JPG/PNG)
- [ ] Screenshots (2-8 images, phone + tablet)
- [ ] Short description (80 chars)
- [ ] Full description (4000 chars)
- [ ] Promotional video (optional, YouTube link)

### Store Listing Content

**Title**: Habit Garden - Daily Habit Tracker

**Short Description**:
```
Grow a beautiful virtual garden by maintaining daily habits. Gamified habit tracking with plants, streaks, and rewards!
```

**Full Description**:
```
🌱 Transform Your Habits Into a Beautiful Garden

Habit Garden is a calming, gamified habit tracker that makes building good habits enjoyable and rewarding. Each habit you create grows a unique virtual plant that evolves as you maintain your streaks.

✨ KEY FEATURES

🌿 Virtual Garden
- Each habit corresponds to a plant
- Watch them grow from seed to full bloom
- 10+ beautiful plant varieties to unlock

📈 Growth & Progress
- 4 growth stages based on consistency
- Visual feedback for your efforts
- Build streaks to accelerate growth

🔔 Smart Notifications
- Adaptive reminders learn your routine
- Never miss a habit at the optimal time
- Gentle, encouraging notifications

💰 Reward System
- Earn "Sunlight" currency
- Unlock new plants and decorations
- Shop for exclusive content

🎨 Seasonal Themes
- Spring, Summer, Autumn, Winter
- Beautiful pastel color palettes
- Calming, mindful design

💾 Privacy First
- All data stored locally
- No account required
- Works completely offline
- Zero tracking or analytics

🌟 WHY HABIT GARDEN?

Traditional habit trackers can feel like work. Habit Garden transforms the experience into something beautiful and rewarding. Miss a day? Your plant may wilt—but you can always revive it and start fresh.

Perfect for:
✓ Building morning/evening routines
✓ Health and fitness goals
✓ Reading and learning habits
✓ Mindfulness practices
✓ Any daily activity you want to maintain

📱 TECHNICAL DETAILS

- Works offline (no internet required)
- Minimal battery usage
- Small app size (~20 MB)
- Supports Android 6.0+
- Smooth 60 FPS animations
- Clean, modern UI

🆓 100% FREE

No ads, no subscriptions, no required purchases. Optional cosmetic items available for those who want to support development.

Start growing today! 🌱
```

**Keywords**: 
habit tracker, habits, productivity, self improvement, garden, plants, gamification, streak tracker, daily routine, mindfulness

### Publishing Steps

1. **Build app bundle**:
   ```bash
   flutter build appbundle --release
   ```

2. **Sign in** to Play Console

3. **Create new app**

4. **Upload app bundle** to internal testing first

5. **Complete all sections**:
   - Main store listing
   - Content rating
   - Target audience
   - Privacy policy
   - App content
   - Pricing & distribution

6. **Submit for review**

7. **Monitor status** (usually approved in 1-3 days)

## Updates and Versioning

### Version Numbering

Use semantic versioning: `MAJOR.MINOR.PATCH+BUILD`

Example progression:
- `1.0.0+1` - Initial release
- `1.0.1+2` - Bug fix
- `1.1.0+3` - New feature
- `2.0.0+4` - Major changes

### Releasing Updates

1. **Update version** in `pubspec.yaml`:
   ```yaml
   version: 1.1.0+2
   ```

2. **Build new APK/bundle**:
   ```bash
   flutter build apk --release
   ```

3. **Update landing page**:
   - Change version number
   - Add to changelog
   - Upload new APK

4. **For Play Store**:
   - Upload new bundle to existing app
   - Update "What's new" section
   - Submit for review

### Changelog Template

```markdown
## Version 1.1.0 (Build 2)

### New Features
- Added winter theme
- New plant varieties: Orchid, Bonsai

### Improvements
- Faster app startup
- Smoother animations
- Better notification scheduling

### Bug Fixes
- Fixed plant growth calculation
- Resolved notification issues on Android 13+
- Fixed crash when editing habits

### Known Issues
- Some devices may show delayed notifications
```

## Analytics and Monitoring

### Play Store Console

After publishing, monitor:
- Install counts
- User ratings and reviews
- Crash reports
- ANR (Application Not Responding) reports

### Crashlytics (Optional)

Add Firebase Crashlytics for crash reporting:

```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_crashlytics: ^3.4.8
```

## Marketing Tips

1. **Social Media**
   - Share screenshots on Twitter, Instagram
   - Use hashtags: #habittracker #productivity #Flutter
   - Post in Reddit communities (r/productivity, r/Android)

2. **Content Creation**
   - Write a blog post about the app
   - Create a demo video for YouTube
   - Submit to app showcase sites

3. **Community Building**
   - Create a Discord server
   - Start a subreddit
   - Engage with users

4. **App Store Optimization**
   - Optimize keywords
   - Encourage positive reviews
   - Respond to user feedback
   - Update screenshots regularly

## Support and Maintenance

### User Support

Set up:
- Email: habitgarden@yourdomain.com
- GitHub Issues for bug reports
- FAQ page on landing site
- Discord/Telegram for community

### Monitoring

Check regularly:
- User reviews (respond within 24-48h)
- Crash reports
- Feature requests
- Bug reports

### Update Schedule

Recommended:
- Bug fixes: As needed (within days)
- Minor updates: Monthly
- Major updates: Quarterly

## Legal Requirements

### Privacy Policy

Required for Play Store. Template:

```
Privacy Policy for Habit Garden

Data Collection:
- We do not collect any personal data
- All data is stored locally on your device
- No analytics or tracking

Permissions:
- Notifications: For habit reminders
- Storage: For saving your data locally

Contact:
your.email@example.com
```

Host at: `yoursite.com/privacy-policy`

### Terms of Service (Optional)

Basic ToS for app usage and liability.

## Troubleshooting Deployment

### Issue: Play Store Rejected

**Common reasons**:
- Missing privacy policy
- Incomplete content rating
- Required permissions not explained
- Misleading screenshots

**Solution**: Address feedback and resubmit

### Issue: APK Won't Install

- Check minimum SDK version
- Verify APK signature
- Test on actual device, not emulator

### Issue: Users Can't Download

- Check file hosting
- Verify download links
- Test from different networks

## Useful Resources

- [Flutter Deployment Docs](https://docs.flutter.dev/deployment/android)
- [Play Console Help](https://support.google.com/googleplay/android-developer)
- [GitHub Pages Docs](https://pages.github.com/)
- [Netlify Docs](https://docs.netlify.com/)

---

**Need help?** Create an issue on GitHub or contact support.

**Last Updated**: October 2024
