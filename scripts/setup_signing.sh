#!/bin/bash
# Habit Garden - Setup Android Release Signing
# This script helps you create a keystore for signing your Android APK

set -e

echo "=========================================="
echo "Habit Garden - Android Signing Setup"
echo "=========================================="
echo ""

KEYSTORE_PATH="android/keystore.jks"
KEY_PROPERTIES="android/key.properties"

# Check if keystore already exists
if [ -f "$KEYSTORE_PATH" ]; then
    echo "⚠️  Keystore already exists at $KEYSTORE_PATH"
    read -p "Do you want to create a new one? This will overwrite the existing keystore. (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted. Keeping existing keystore."
        exit 0
    fi
fi

echo "Creating Android keystore..."
echo ""
echo "You will be asked to provide:"
echo "  - A keystore password (remember this!)"
echo "  - A key password (can be the same as keystore password)"
echo "  - Your name, organization, city, state, and country"
echo ""
echo "Press Enter to continue..."
read

# Generate keystore
keytool -genkey -v \
    -keystore "$KEYSTORE_PATH" \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -alias app_key

if [ ! -f "$KEYSTORE_PATH" ]; then
    echo "❌ Failed to create keystore!"
    exit 1
fi

echo ""
echo "✅ Keystore created successfully at $KEYSTORE_PATH"
echo ""

# Create key.properties if it doesn't exist
if [ ! -f "$KEY_PROPERTIES" ]; then
    echo "Creating key.properties file..."
    read -sp "Enter keystore password: " STORE_PASSWORD
    echo ""
    read -sp "Enter key password: " KEY_PASSWORD
    echo ""
    
    cat > "$KEY_PROPERTIES" << EOF
storePassword=$STORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=app_key
storeFile=../keystore.jks
EOF
    
    echo "✅ Created $KEY_PROPERTIES"
else
    echo "⚠️  $KEY_PROPERTIES already exists. Please update it manually if needed."
fi

echo ""
echo "=========================================="
echo "✅ Setup Complete!"
echo "=========================================="
echo ""
echo "IMPORTANT: NEVER commit the following files to version control:"
echo "  - $KEYSTORE_PATH"
echo "  - $KEY_PROPERTIES"
echo ""
echo "These files are already in .gitignore"
echo ""
echo "You can now build a release APK with: ./scripts/build_apk.sh"
echo ""

