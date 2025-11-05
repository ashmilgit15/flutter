# Setup Android Release Signing for Habit Garden
# This script generates a keystore for release APK signing

Write-Host "=== Habit Garden - Release Signing Setup ===" -ForegroundColor Green
Write-Host ""

# Configuration
$keystoreFile = "..\android\keystore.jks"
$keyAlias = "app_key"
$storePassword = "habitgarden2024"
$keyPassword = "habitgarden2024"
$validity = 10000

# Find keytool (try multiple common locations)
$keytoolPaths = @(
    "keytool",
    "$env:JAVA_HOME\bin\keytool.exe",
    "C:\Program Files\Java\jdk*\bin\keytool.exe",
    "C:\Program Files (x86)\Common Files\Oracle\Java\javapath\keytool.exe",
    "$env:LOCALAPPDATA\Android\Sdk\jre\bin\keytool.exe"
)

$keytool = $null
foreach ($path in $keytoolPaths) {
    try {
        if (Test-Path $path -ErrorAction SilentlyContinue) {
            $keytool = $path
            break
        }
        # Try to resolve wildcards
        $resolved = Resolve-Path $path -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($resolved) {
            $keytool = $resolved.Path
            break
        }
    } catch {
        continue
    }
}

if (-not $keytool) {
    # Try to run keytool directly (if in PATH)
    try {
        $null = & keytool -help 2>&1
        $keytool = "keytool"
    } catch {
        Write-Host "ERROR: keytool not found!" -ForegroundColor Red
        Write-Host "Please install Java JDK and ensure keytool is in your PATH" -ForegroundColor Yellow
        Write-Host "Or set JAVA_HOME environment variable to your JDK installation" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "Found keytool: $keytool" -ForegroundColor Cyan
Write-Host ""

# Generate keystore
Write-Host "Generating keystore..." -ForegroundColor Yellow
& $keytool -genkey -v `
    -keystore $keystoreFile `
    -keyalg RSA `
    -keysize 2048 `
    -validity $validity `
    -alias $keyAlias `
    -storepass $storePassword `
    -keypass $keyPassword `
    -dname "CN=Habit Garden, OU=Development, O=Habit Garden, L=Unknown, ST=Unknown, C=US"

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to generate keystore" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Keystore created successfully!" -ForegroundColor Green

# Create key.properties file
$keyPropertiesContent = @"
storePassword=$storePassword
keyPassword=$keyPassword
keyAlias=$keyAlias
storeFile=keystore.jks
"@

$keyPropertiesFile = "..\android\key.properties"
$keyPropertiesContent | Out-File -FilePath $keyPropertiesFile -Encoding ASCII

Write-Host "Created key.properties file" -ForegroundColor Green
Write-Host ""
Write-Host "=== Setup Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "IMPORTANT SECURITY NOTES:" -ForegroundColor Yellow
Write-Host "1. The keystore password is: $storePassword" -ForegroundColor Cyan
Write-Host "2. Keep this password safe and secure!" -ForegroundColor Yellow
Write-Host "3. DO NOT commit keystore.jks or key.properties to version control!" -ForegroundColor Red
Write-Host "4. Back up your keystore file - you cannot publish updates without it!" -ForegroundColor Yellow
Write-Host ""
Write-Host "You can now build a release APK with: flutter build apk --release" -ForegroundColor Green


