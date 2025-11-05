# ⚡ Quick Website Integration Guide

## 🎯 What You Need (Everything is Ready!)

### ✅ Current Status:
1. **APK Files Available:**
   - `habit-garden-v1.0.0.apk` (root folder)
   - `build/app/outputs/flutter-apk/app-release.apk` (51 MB - latest release)
   
2. **HTML Templates Ready:**
   - Full featured section: `portfolio-integration/habit-garden-section.html`
   - Minimal version: `portfolio-integration/minimal-version.html`
   - Standalone page: `landing-page/index.html`

---

## 🚀 Fastest Method (5 Steps, ~10 minutes)

### Step 1: Choose Your Template

**For Portfolio Projects Section:**
- Use: `portfolio-integration/minimal-version.html` ✅ (Easiest)

**For Dedicated Project Page:**
- Use: `portfolio-integration/habit-garden-section.html` ✅ (Full featured)

**For Standalone Landing Page:**
- Use: `landing-page/index.html` ✅ (Complete marketing page)

### Step 2: Copy the APK

Copy one of these to your website:
- `habit-garden-v1.0.0.apk` (root folder)
- OR `build/app/outputs/flutter-apk/app-release.apk` (latest release)

Place it in: `your-website/downloads/habit-garden.apk`

### Step 3: Copy HTML Code

1. Open the HTML template you chose
2. Copy ALL the content
3. Paste into your website HTML where you want it

### Step 4: Update the Link

In the HTML, find this line and update the path:
```html
<!-- Change to match where you put the APK -->
<a href="./downloads/habit-garden.apk" class="download-button" download>
```

### Step 5: Deploy!

**GitHub Pages:**
```powershell
git add .
git commit -m "Add Habit Garden"
git push
```

**Netlify:** Drag and drop your folder

**Your Server:** Upload via FTP

---

## 📁 File Structure for Your Website

### Option 1: Simple (All in root)
```
your-website/
├── index.html (your portfolio)
├── habit-garden.apk
└── (paste HTML code into index.html)
```

### Option 2: Organized
```
your-website/
├── index.html
├── downloads/
│   └── habit-garden.apk
└── projects/
    └── habit-garden/
        └── index.html (standalone page)
```

---

## 🔧 Quick Updates Needed

### In the HTML file, update:

1. **GitHub Link:**
```html
<a href="https://github.com/YOUR_USERNAME/habit-garden">
```

2. **Contact Email:**
```html
<a href="mailto:your.email@example.com">
```

3. **APK Path** (if needed):
```html
<a href="./downloads/habit-garden.apk" download>
```

---

## ✅ Testing Checklist

After deployment, test:
- [ ] Visit your website
- [ ] Find the Habit Garden section
- [ ] Click download button
- [ ] Verify APK downloads
- [ ] Test on mobile (responsive design)

---

## 🎨 Customization Tips

### Change Colors:
The templates use `#8FBC8F` (green) as primary color. Find and replace:
```css
color: #8FBC8F;  /* Change to your color */
background: #8FBC8F;
```

### Remove/Add Features:
- Remove the demo modal if you don't need screenshots
- Add your own screenshots instead of placeholders
- Customize the feature list

---

## 📝 Example: Adding to Existing Portfolio

If you have an existing portfolio with a projects section:

1. Open `portfolio-integration/minimal-version.html`
2. Copy everything inside the `<div class="habit-garden-project">` tag
3. Paste into your portfolio's projects section
4. Make sure to include the `<style>` section too
5. Update the APK link path

**That's it!** The minimal version is designed to fit into existing portfolios.

---

## 🆘 Need Help?

**File Too Large?**
- Use GitHub Releases and link to it
- Or host APK on Google Drive/Dropbox

**Styling Conflicts?**
- The templates include their own CSS
- If conflicts occur, wrap in a unique class

**APK Won't Download?**
- Check file path is correct
- Ensure file is actually uploaded
- Try absolute URL: `href="https://yoursite.com/downloads/habit-garden.apk"`

---

## 📚 Full Details

For comprehensive information, see:
- `WEBSITE_INTEGRATION_CHECKLIST.md` - Complete checklist
- `portfolio-integration/PORTFOLIO_SETUP.md` - Detailed portfolio guide
- `DEPLOYMENT_GUIDE.md` - Full deployment options

---

**You're Ready!** Everything is set up. Just copy, paste, update links, and deploy! 🚀


