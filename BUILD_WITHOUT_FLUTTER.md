# 🚀 Build APK WITHOUT Installing Flutter

Use GitHub Actions to build automatically in the cloud!

## Steps (5 Minutes)

### 1. Create GitHub Repository

1. Go to github.com and sign in
2. Click "New Repository"
3. Name it: `habit-garden`
4. Make it Public
5. Click "Create repository"

### 2. Upload Your Project

```powershell
# In your habit_garden folder
cd "C:/Users/Ashmil P/Desktop/Flutter/habit_garden"

# Initialize git
git init
git add .
git commit -m "Initial commit - Habit Garden app"

# Connect to GitHub (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/habit-garden.git
git branch -M main
git push -u origin main
```

### 3. Trigger the Build

1. Go to your GitHub repository
2. Click "Actions" tab
3. Click "Build APK" workflow
4. Click "Run workflow" button
5. Wait 3-5 minutes for build to complete

### 4. Download Your APK

1. After build completes, click on the workflow run
2. Scroll down to "Artifacts"
3. Download "habit-garden-apk"
4. Extract the ZIP to get `app-release.apk`

### 5. Add to Portfolio

1. Rename to `habit-garden.apk`
2. Upload to your portfolio's `downloads/` folder
3. Done! ✅

## Alternative: Direct Download Link

### Option A: GitHub Releases

1. Create a release:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. Go to GitHub → Releases
3. Find your release
4. APK will be attached
5. Copy download link for portfolio

### Option B: Use GitHub Actions Artifact Link

Get direct link from Actions artifacts:
```
https://github.com/YOUR_USERNAME/habit-garden/actions
```

## Benefits of This Method

✅ No Flutter installation needed
✅ No Android SDK needed
✅ Builds in 3-5 minutes
✅ Always builds clean APK
✅ Automatic with every code change
✅ Free on GitHub

## If You Don't Have Git Installed

### Download Git
```
https://git-scm.com/download/win
```

Install with default settings, then restart PowerShell.

## Quick Alternative: Upload Manually

If you prefer not to use command line:

1. Create GitHub repo on website
2. Click "uploading an existing file"
3. Drag and drop all files from `habit_garden` folder
4. Commit
5. Go to Actions tab
6. Run workflow
7. Download APK

## Troubleshooting

### "git not recognized"
Install Git from: https://git-scm.com/download/win

### "Build failed"
Check Actions logs for errors. Usually:
- Missing dependencies (already configured ✓)
- Android version mismatch (already fixed ✓)

### Can't push to GitHub
```powershell
# If authentication fails, use Personal Access Token
# GitHub → Settings → Developer settings → Personal access tokens
# Create token with 'repo' scope
# Use token as password when prompted
```

## Full Manual Alternative

If you want to avoid all of this:

1. **Get Flutter SDK** (~1 GB download)
   - https://docs.flutter.dev/get-started/install/windows
   
2. **Extract to C:\flutter**

3. **Add to PATH**
   - Search "Environment Variables" in Windows
   - Edit Path → Add: `C:\flutter\bin`
   
4. **Restart PowerShell**

5. **Run**:
   ```powershell
   flutter doctor --android-licenses
   cd "C:/Users/Ashmil P/Desktop/Flutter/habit_garden"
   flutter pub get
   flutter build apk --release
   ```

**Time**: 30-60 minutes (including downloads)

---

## 🎯 Recommendation

**For Portfolio RIGHT NOW**: Use GitHub Actions (5 min)
**For Future Development**: Install Flutter locally (60 min)

Choose what works for you! Both produce the exact same APK.
