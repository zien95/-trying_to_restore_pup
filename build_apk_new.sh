#!/bin/bash

# 🤖 Android APK Build Script
# Automated APK generation for sideloading

set -e

echo "🤖 Building Android APK for distribution..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="PupGame"
PACKAGE_NAME="${PACKAGE_NAME:-com.yourcompany.pupgame}"
OUTPUT_DIR="./apk_output"
BUILD_PATH="./android_build"

# Clean previous builds
echo "${YELLOW}🧹 Cleaning previous builds...${NC}"
rm -rf "$OUTPUT_DIR"
rm -rf "$BUILD_PATH"
mkdir -p "$OUTPUT_DIR"

# Check dependencies
echo "${BLUE}🔧 Checking dependencies...${NC}"
if ! command -v flutter &> /dev/null; then
    echo "${RED}❌ Flutter not found. Install Flutter first.${NC}"
    exit 1
fi

if ! command -v java &> /dev/null; then
    echo "${RED}❌ Java not found. Install Java 11+ first.${NC}"
    exit 1
fi

# Check Android SDK
if [ -z "$ANDROID_HOME" ]; then
    echo "${YELLOW}⚠️ ANDROID_HOME not set. Using default Android SDK path.${NC}"
    ANDROID_HOME="$HOME/Library/Android/sdk"
fi

# Get Flutter and Java versions
echo "${BLUE}📱 Flutter version:${NC}"
flutter --version

echo "${BLUE}☕ Java version:${NC}"
java -version

# Build Flutter app for Android
echo "${GREEN}🏗️ Building Flutter app for Android...${NC}"
flutter build apk --release --split-per-abi

if [ $? -ne 0 ]; then
    echo "${RED}❌ Flutter build failed!${NC}"
    exit 1
fi

# Navigate to build directory
cd build/app/outputs/flutter-apk

# Create output directory structure
echo "${GREEN}📦 Creating APK package...${NC}"
mkdir -p "$OUTPUT_DIR/arm64-v8a"
mkdir -p "$OUTPUT_DIR/armeabi-v7a"
mkdir -p "$OUTPUT_DIR/x86_64"
mkdir -p "$OUTPUT_DIR/x86"

# Copy APKs to organized structure
echo "${GREEN}📤 Copying APK files...${NC}"
if [ -f "app-arm64-v8a-release.apk" ]; then
    cp "app-arm64-v8a-release.apk" "$OUTPUT_DIR/arm64-v8a/"
    echo "${BLUE}✅ arm64-v8a APK copied${NC}"
fi

if [ -f "app-armeabi-v7a-release.apk" ]; then
    cp "app-armeabi-v7a-release.apk" "$OUTPUT_DIR/armeabi-v7a/"
    echo "${BLUE}✅ armeabi-v7a APK copied${NC}"
fi

if [ -f "app-x86_64-release.apk" ]; then
    cp "app-x86_64-release.apk" "$OUTPUT_DIR/x86_64/"
    echo "${BLUE}✅ x86_64 APK copied${NC}"
fi

if [ -f "app-x86-release.apk" ]; then
    cp "app-x86-release.apk" "$OUTPUT_DIR/x86/"
    echo "${BLUE}✅ x86 APK copied${NC}"
fi

# Get APK sizes
echo "${GREEN}📊 Calculating APK sizes...${NC}"
ARM64_SIZE=$(du -h "$OUTPUT_DIR/arm64-v8a/app-arm64-v8a-release.apk" 2>/dev/null | cut -f1 || echo "Unknown")
ARM32_SIZE=$(du -h "$OUTPUT_DIR/armeabi-v7a/app-armeabi-v7a-release.apk" 2>/dev/null | cut -f1 || echo "Unknown")
X64_SIZE=$(du -h "$OUTPUT_DIR/x86_64/app-x86_64-release.apk" 2>/dev/null | cut -f1 || echo "Unknown")
X86_SIZE=$(du -h "$OUTPUT_DIR/x86/app-x86-release.apk" 2>/dev/null | cut -f1 || echo "Unknown")

# Create universal APK (optional)
echo "${GREEN}🔄 Creating universal APK...${NC}"
if command -v python3 &> /dev/null; then
    python3 -c "
import zipfile
import os

# Create universal APK info
with open('$OUTPUT_DIR/universal.json', 'w') as f:
    f.write('''{
  \"app_name\": \"$APP_NAME\",
  \"version\": \"26.5\",
  \"build\": \"$(date +%Y%m%d_%H%M%S)\",
  \"package_name\": \"$PACKAGE_NAME\",
  \"architectures\": {
    \"arm64-v8a\": \"$ARM64_SIZE\",
    \"armeabi-v7a\": \"$ARM32_SIZE\",
    \"x86_64\": \"$X64_SIZE\",
    \"x86\": \"$X86_SIZE\"
  },
  \"build_date\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",
  \"flutter_version\": \"$(flutter --version | head -n1)\",
  \"min_android_version\": \"5.0 (API 21)\",
  \"target_android_version\": \"14.0 (API 34)\"
}''')

print('✅ Universal APK info created')
"
    echo "${BLUE}✅ Universal APK info created${NC}"
else
    echo "${YELLOW}⚠️ Python3 not found. Skipping universal APK info.${NC}"
fi

# Create AAB for Play Store (optional)
echo "${GREEN}📦 Creating AAB for Play Store...${NC}"
cd ../../
flutter build appbundle --release

if [ $? -eq 0 ]; then
    if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
        cp "build/app/outputs/bundle/release/app-release.aab" "$OUTPUT_DIR/"
        AAB_SIZE=$(du -h "$OUTPUT_DIR/app-release.aab" 2>/dev/null | cut -f1 || echo "Unknown")
        echo "${BLUE}✅ AAB created ($AAB_SIZE)${NC}"
    fi
fi

# Create build info
echo "${GREEN}📄 Creating build info...${NC}"
cat > "$OUTPUT_DIR/build_info.json" << EOF
{
  "app_name": "$APP_NAME",
  "version": "26.5",
  "build": "$(date +%Y%m%d_%H%M%S)",
  "package_name": "$PACKAGE_NAME",
  "bundle_id": "$PACKAGE_NAME",
  "build_date": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "flutter_version": "$(flutter --version | head -n1)",
  "java_version": "$(java -version 2>&1 | head -n1)",
  "android_sdk": "$ANDROID_HOME",
  "min_android_version": "5.0 (API 21)",
  "target_android_version": "14.0 (API 34)",
  "supported_abis": [
    "arm64-v8a",
    "armeabi-v7a", 
    "x86_64",
    "x86"
  ],
  "apks": {
    "arm64-v8a": {
      "file": "app-arm64-v8a-release.apk",
      "size": "$ARM64_SIZE",
      "devices": "Modern 64-bit ARM devices (Pixel, Samsung S21+, etc.)"
    },
    "armeabi-v7a": {
      "file": "app-armeabi-v7a-release.apk", 
      "size": "$ARM32_SIZE",
      "devices": "Older 32-bit ARM devices (Samsung J series, older phones)"
    },
    "x86_64": {
      "file": "app-x86_64-release.apk",
      "size": "$X64_SIZE", 
      "devices": "64-bit x86 Android devices (rare, ChromeOS)"
    },
    "x86": {
      "file": "app-x86-release.apk",
      "size": "$X86_SIZE",
      "devices": "32-bit x86 Android devices (very rare, emulators)"
    }
  },
  "aab": {
    "file": "app-release.aab",
    "size": "${AAB_SIZE:-Unknown}",
    "devices": "Google Play Store distribution"
  },
  "distribution_methods": [
    "direct_apk",
    "play_store",
    "third_party_stores",
    "enterprise",
    "adb_install"
  ]
}
EOF

# Create installation guide
echo "${GREEN}📖 Creating installation guide...${NC}"
cat > "$OUTPUT_DIR/INSTALL.md" << EOF
# 🤖 $APP_NAME Android Installation

## 📋 What You Need
- Android 5.0 (API 21) or later
- 500MB free storage
- "Unknown sources" enabled in settings

## 📦 Installation Methods

### Method 1: Direct APK Download
1. Download appropriate APK for your device:
   - arm64-v8a: Modern 64-bit devices (recommended)
   - armeabi-v7a: Older 32-bit devices
   - x86_64/x86: Emulators and rare devices
2. Enable "Unknown sources" in Settings → Security
3. Tap downloaded APK to install
4. Follow on-screen instructions

### Method 2: ADB Install (Advanced)
\`\`\`bash
# Enable USB debugging
adb devices

# Install APK (replace with correct architecture)
adb install app-arm64-v8a-release.apk
\`\`\`

### Method 3: QR Code Installation
1. Host APK files on web server
2. Generate QR codes for each APK
3. Scan QR code with Android camera
4. Install from browser download

## 📱 Device Compatibility

### Architecture Guide
- **arm64-v8a**: Most modern devices (2019+)
  - Pixel 3+, Samsung S20+, OnePlus 8+
  - Recommended for 95% of users

- **armeabi-v7a**: Older and budget devices
  - Samsung J series, older phones
  - 32-bit ARM, decreasing compatibility

- **x86_64**: ChromeOS and some tablets
  - Rare, mainly for development
  - 64-bit Intel/AMD

- **x86**: Very old devices and emulators
  - Legacy support only
  - 32-bit Intel/AMD

## 📊 APK Information
- **Version**: 26.5
- **Sizes**: 
  - arm64-v8a: $ARM64_SIZE
  - armeabi-v7a: $ARM32_SIZE
  - x86_64: $X64_SIZE
  - x86: $X86_SIZE
- **Bundle ID**: $PACKAGE_NAME
- **Build Date**: $(date)
- **Android Compatibility**: 5.0+ (API 21+)

## ⚠️ Important Notes
- Enable "Unknown sources" in settings
- Some devices may need "Apps from unknown sources" toggle
- Always test on target device architecture
- Backup data before updating

## 🔐 Security Considerations
- APKs are signed with debug key for sideloading
- Not suitable for Play Store distribution
- Use AAB for production releases

## 🆘 Troubleshooting

### "Parse Error" or "App Not Installed"
1. Check Android version compatibility
2. Verify "Unknown sources" is enabled
3. Try different APK architecture
4. Clear cache and restart device

### "Install Failed"
1. Free up storage space
2. Check for corrupted download
3. Try ADB installation method

## 📞 Support
- Email: support@yourapp.com
- Discord: [Your Discord Server]
- Updates: https://yourapp.com/updates
EOF

# Generate QR codes for APKs
echo "${GREEN}📱 Generating QR codes...${NC}"
if command -v qrencode &> /dev/null; then
    for apk in arm64-v8a armeabi-v7a x86_64 x86; do
        if [ -f "$OUTPUT_DIR/$apk/app-$apk-release.apk" ]; then
            qrencode -o "$OUTPUT_DIR/qr_$apk.png" "https://your-server.com/apk/app-$apk-release.apk"
            echo "${BLUE}✅ QR code generated for $apk${NC}"
        fi
    done
else
    echo "${YELLOW}⚠️ qrencode not found. Install with: brew install qrencode${NC}"
fi

# Success message
echo ""
echo "${GREEN}✅ Android APK Build Complete!${NC}"
echo ""
echo "${BLUE}📦 Build Information:${NC}"
echo "  📁 Output: $OUTPUT_DIR"
echo "  📱 APKs: Multiple architectures"
echo "  📊 arm64-v8a: $ARM64_SIZE"
echo "  📊 armeabi-v7a: $ARM32_SIZE"
echo "  📊 x86_64: $X64_SIZE"
echo "  📊 x86: $X86_SIZE"
echo "  📦 AAB: ${AAB_SIZE:-Not created}"
echo "  📅 Build: $(date)"
echo "  🔗 Package: $PACKAGE_NAME"
echo ""
echo "${YELLOW}📲 Next Steps:${NC}"
echo "  1. Choose correct APK for device architecture"
echo "  2. Distribute via direct download, ADB, or QR codes"
echo "  3. Enable 'Unknown sources' on user devices"
echo "  4. Use AAB for Play Store submission"
echo ""
echo "${BLUE}📖 Installation Guide: $OUTPUT_DIR/INSTALL.md${NC}"
echo "${BLUE}📄 Build Info: $OUTPUT_DIR/build_info.json${NC}"
echo ""

# Open output directory
open "$OUTPUT_DIR"

echo "${GREEN}🎉 Ready for Android distribution!${NC}"
