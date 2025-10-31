# Habit Garden - Setup Android Release Signing (PowerShell)
# This script helps you create a keystore for signing your Android APK

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Green
Write-Host "Habit Garden - Android Signing Setup" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

$KEYSTORE_PATH = "android\keystore.jks"
$KEY_PROPERTIES = "android\key.properties"

# Check if keystore already exists
if (Test-Path $KEYSTORE_PATH) {
    Write-Host "⚠️  Keystore already exists at $KEYSTORE_PATH" -ForegroundColor Yellow
    $response = Read-Host "Do you want to create a new one? This will overwrite the existing keystore. (y/N)"
    if ($response -notmatch "^[Yy]$") {
        Write-Host "Aborted. Keeping existing keystore." -ForegroundColor Yellow
        exit 0
    }
}

Write-Host "Creating Android keystore..." -ForegroundColor Cyan
Write-Host ""
Write-Host "You will be asked to provide:"
Write-Host "  - A keystore password (remember this!)"
Write-Host "  - A key password (can be the same as keystore password)"
Write-Host "  - Your name, organization, city, state, and country"
Write-Host ""
Write-Host "Press Enter to continue..."
Read-Host

# Generate keystore
keytool -genkey -v `
    -keystore "$KEYSTORE_PATH" `
    -keyalg RSA `
    -keysize 2048 `
    -validity 10000 `
    -alias app_key

if (!(Test-Path $KEYSTORE_PATH)) {
    Write-Host "❌ Failed to create keystore!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ Keystore created successfully at $KEYSTORE_PATH" -ForegroundColor Green
Write-Host ""

# Create key.properties if it doesn't exist
if (!(Test-Path $KEY_PROPERTIES)) {
    Write-Host "Creating key.properties file..." -ForegroundColor Cyan
    $STORE_PASSWORD = Read-Host "Enter keystore password" -AsSecureString
    $STORE_PASSWORD_TEXT = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($STORE_PASSWORD))
    
    $KEY_PASSWORD = Read-Host "Enter key password" -AsSecureString
    $KEY_PASSWORD_TEXT = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($KEY_PASSWORD))
    
    @"
storePassword=$STORE_PASSWORD_TEXT
keyPassword=$KEY_PASSWORD_TEXT
keyAlias=app_key
storeFile=../keystore.jks
"@ | Out-File -FilePath $KEY_PROPERTIES -Encoding UTF8
    
    Write-Host "✅ Created $KEY_PROPERTIES" -ForegroundColor Green
} else {
    Write-Host "⚠️  $KEY_PROPERTIES already exists. Please update it manually if needed." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "✅ Setup Complete!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "IMPORTANT: NEVER commit the following files to version control:" -ForegroundColor Red
Write-Host "  - $KEYSTORE_PATH" -ForegroundColor Red
Write-Host "  - $KEY_PROPERTIES" -ForegroundColor Red
Write-Host ""
Write-Host "These files are already in .gitignore"
Write-Host ""
Write-Host "You can now build a release APK with: .\scripts\build_apk.ps1"
Write-Host ""

