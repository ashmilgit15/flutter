#!/bin/bash
# Setup Android Release Signing for Habit Garden
# This script generates a keystore for release APK signing

echo "=== Habit Garden - Release Signing Setup ==="
echo ""

# Configuration
KEYSTORE_FILE="../android/keystore.jks"
KEY_ALIAS="app_key"
STORE_PASSWORD="habitgarden2024"
KEY_PASSWORD="habitgarden2024"
VALIDITY=10000

# Find keytool
if ! command -v keytool &> /dev/null; then
    echo "ERROR: keytool not found!"
    echo "Please install Java JDK and ensure keytool is in your PATH"
    exit 1
fi

echo "Found keytool: $(which keytool)"
echo ""

# Generate keystore
echo "Generating keystore..."
keytool -genkey -v \
    -keystore "$KEYSTORE_FILE" \
    -keyalg RSA \
    -keysize 2048 \
    -validity $VALIDITY \
    -alias "$KEY_ALIAS" \
    -storepass "$STORE_PASSWORD" \
    -keypass "$KEY_PASSWORD" \
    -dname "CN=Habit Garden, OU=Development, O=Habit Garden, L=Unknown, ST=Unknown, C=US"

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to generate keystore"
    exit 1
fi

echo ""
echo "Keystore created successfully!"

# Create key.properties file
KEY_PROPERTIES_FILE="../android/key.properties"
cat > "$KEY_PROPERTIES_FILE" << EOF
storePassword=$STORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=$KEY_ALIAS
storeFile=keystore.jks
EOF

echo "Created key.properties file"
echo ""
echo "=== Setup Complete ==="
echo ""
echo "IMPORTANT SECURITY NOTES:"
echo "1. The keystore password is: $STORE_PASSWORD"
echo "2. Keep this password safe and secure!"
echo "3. DO NOT commit keystore.jks or key.properties to version control!"
echo "4. Back up your keystore file - you cannot publish updates without it!"
echo ""
echo "You can now build a release APK with: flutter build apk --release"
