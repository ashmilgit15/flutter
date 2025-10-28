# 📱 Adding Habit Garden to Your Portfolio

Quick guide to add the app download to your portfolio website.

## Step 1: Build the APK

```bash
cd "c:/Users/Ashmil P/Desktop/Flutter/habit_garden"
flutter build apk --release
```

**Output**: `build/app/outputs/flutter-apk/app-release.apk`

## Step 2: Organize Files

Create this structure in your portfolio:

```
your-portfolio/
├── index.html
├── downloads/
│   └── habit-garden.apk    ← Copy the APK here (rename from app-release.apk)
└── projects/
    └── habit-garden/
        └── index.html       ← Or integrate into main portfolio
```

## Step 3: Add to Portfolio

### Option A: Standalone Page

1. Copy `habit-garden-section.html` content
2. Create `your-portfolio/projects/habit-garden/index.html`
3. Paste the content
4. Update the APK link: `href="../../downloads/habit-garden.apk"`

### Option B: Integrate into Main Portfolio

1. Open your `portfolio/index.html`
2. Find your projects section
3. Copy the content from `habit-garden-section.html`
4. Paste it in your projects section
5. Update the APK link: `href="./downloads/habit-garden.apk"`

## Step 4: Customize

Update these in the HTML:

```html
<!-- Update GitHub link -->
<a href="https://github.com/YOUR_USERNAME/habit-garden">

<!-- Update download path if needed -->
<a href="./downloads/habit-garden.apk" download>
```

## Step 5: Deploy

### GitHub Pages
```bash
git add .
git commit -m "Add Habit Garden project"
git push
```

Enable GitHub Pages in repository settings.

### Netlify
Drag and drop your portfolio folder to netlify.com

### Your Server
```bash
# Upload via FTP/SFTP
# Make sure downloads/ folder is accessible
```

## File Size Note

The APK is ~20-30 MB. Most hosting services can handle this, but:

- **GitHub**: 100 MB file limit ✅
- **Netlify**: 100 MB limit ✅
- **Vercel**: 100 MB limit ✅

## Testing

1. Visit your portfolio
2. Click the download button
3. Verify APK downloads
4. Test installation on Android device

## Quick Copy-Paste Code

### Minimal Version (for existing portfolio)

```html
<div class="project-card">
    <h3>🌱 Habit Garden</h3>
    <p>A calming habit tracker app with virtual plant growth</p>
    <p><strong>Tech:</strong> Flutter, Dart, Hive, Provider</p>
    <a href="./downloads/habit-garden.apk" class="btn-download" download>
        Download APK (Android)
    </a>
    <p><small>Version 1.0.0 • 20 MB • Android 6.0+</small></p>
</div>

<style>
.btn-download {
    display: inline-block;
    background: #8FBC8F;
    color: white;
    padding: 12px 24px;
    border-radius: 25px;
    text-decoration: none;
    font-weight: 600;
    transition: transform 0.3s;
}
.btn-download:hover {
    transform: translateY(-2px);
}
</style>
```

## Alternative Hosting (if portfolio has file size limits)

### Google Drive
1. Upload APK to Google Drive
2. Right-click → Get link
3. Change sharing to "Anyone with the link"
4. Update href: `href="YOUR_GOOGLE_DRIVE_LINK"`

### Dropbox
1. Upload to Dropbox
2. Share → Create link
3. Change `www.dropbox.com` to `dl.dropboxusercontent.com` in URL
4. Update href

### GitHub Releases
1. Create a release in your portfolio repo
2. Attach APK as release asset
3. Copy download URL
4. Update href

## SEO Tips

Add to your portfolio's `<head>`:

```html
<meta name="description" content="Habit Garden - Flutter Android app for habit tracking">
<meta property="og:title" content="Habit Garden - Download">
<meta property="og:description" content="Grow your habits with this calming Android app">
<meta property="og:type" content="website">
```

## Security Note

Add this to `.htaccess` (if using Apache) to set correct MIME type:

```apache
<Files "habit-garden.apk">
    Header set Content-Type "application/vnd.android.package-archive"
</Files>
```

## Track Downloads (Optional)

Add Google Analytics event:

```javascript
document.querySelector('.download-button').addEventListener('click', function() {
    gtag('event', 'download', {
        'event_category': 'App',
        'event_label': 'Habit Garden APK'
    });
});
```

## Troubleshooting

### APK won't download
- Check file path is correct
- Verify file permissions (should be readable)
- Try adding `download` attribute to `<a>` tag

### Browser blocks download
- Some browsers block APK downloads for security
- Add a note: "If blocked, allow downloads in browser settings"

### File too large
- Use split APKs: `flutter build apk --split-per-abi`
- Offer only arm64-v8a version (~15 MB)

## Example Text for Portfolio

```markdown
### Habit Garden 🌱

A beautiful Android app that gamifies habit tracking through virtual plant growth.

**Features:**
- Virtual garden with 10+ plant varieties
- Smart adaptive notifications
- 4 seasonal themes
- Offline-first with local storage
- Unlock system with in-game currency

**Tech Stack:** Flutter, Dart, Provider, Hive, Material Design

**Download:** [Get APK](./downloads/habit-garden.apk) (20 MB, Android 6.0+)
```

## Complete Example

See `habit-garden-section.html` for a fully styled, production-ready section.

---

**Need help?** Check the main README.md or DEPLOYMENT_GUIDE.md
