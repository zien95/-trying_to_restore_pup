#!/bin/bash

# 🍎 iOS IPA Build Script
# Automated IPA generation for sideloading

set -e

echo "🍎 Building iOS IPA for sideloading..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="PupGame"
TEAM_ID="${TEAM_ID:-YOUR_TEAM_ID}"
BUNDLE_ID="${BUNDLE_ID:-com.yourcompany.pupgame}"
OUTPUT_DIR="./ipa_output"
ARCHIVE_PATH="./ios_build"

# Clean previous builds
echo "${YELLOW}🧹 Cleaning previous builds...${NC}"
rm -rf "$OUTPUT_DIR"
rm -rf "$ARCHIVE_PATH"
mkdir -p "$OUTPUT_DIR"

# Check dependencies
echo "${BLUE}🔧 Checking dependencies...${NC}"
if ! command -v flutter &> /dev/null; then
    echo "${RED}❌ Flutter not found. Install Flutter first.${NC}"
    exit 1
fi

if ! command -v xcodebuild &> /dev/null; then
    echo "${RED}❌ Xcode not found. Install Xcode first.${NC}"
    exit 1
fi

# Get Flutter version
echo "${BLUE}📱 Flutter version:${NC}"
flutter --version

# Build Flutter app
echo "${GREEN}🏗️ Building Flutter app...${NC}"
flutter build ios --release --no-tree-shake-icons

if [ $? -ne 0 ]; then
    echo "${RED}❌ Flutter build failed!${NC}"
    exit 1
fi

# Navigate to iOS build directory
cd build/ios/iphoneos

# Create archive
echo "${GREEN}📦 Creating Xcode archive...${NC}"
xcodebuild \
    -workspace ../../ios/Runner.xcworkspace \
    -scheme Runner \
    -configuration Release \
    -destination generic/platform=iOS \
    -archivePath "$ARCHIVE_PATH" \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    PROVISIONING_PROFILE="" \
    PRODUCT_BUNDLE_IDENTIFIER="$BUNDLE_ID"

if [ $? -ne 0 ]; then
    echo "${RED}❌ Archive creation failed!${NC}"
    exit 1
fi

# Create ExportOptions.plist
echo "${GREEN}📋 Creating export options...${NC}"
cat > ExportOptions.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>ad-hoc</string>
    <key>teamID</key>
    <string>$TEAM_ID</string>
    <key>uploadBitcode</key>
    <false/>
    <key>compileBitcode</key>
    <false/>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>destination</key>
    <string>export</string>
    <key>provisioningProfiles</key>
    <array>
        <dict>
            <key>name</key>
            <string>Runner Release</string>
        </dict>
    </array>
</dict>
</plist>
EOF

# Export IPA
echo "${GREEN}📤 Exporting IPA...${NC}"
xcodebuild \
    -exportArchive \
    -archivePath "$ARCHIVE_PATH/Runner.xcarchive" \
    -exportPath "$OUTPUT_DIR" \
    -exportOptionsPlist ExportOptions.plist

if [ $? -ne 0 ]; then
    echo "${RED}❌ IPA export failed!${NC}"
    exit 1
fi

# Find IPA file
IPA_FILE=$(find "$OUTPUT_DIR" -name "*.ipa" | head -n 1)

if [ -z "$IPA_FILE" ]; then
    echo "${RED}❌ No IPA file found!${NC}"
    exit 1
fi

# Get IPA info
IPA_SIZE=$(du -h "$IPA_FILE" | cut -f1)
IPA_NAME=$(basename "$IPA_FILE")

# Create info file
echo "${GREEN}📄 Creating build info...${NC}"
cat > "$OUTPUT_DIR/build_info.json" << EOF
{
  "app_name": "$APP_NAME",
  "version": "26.5",
  "build": "$(date +%Y%m%d_%H%M%S)",
  "bundle_id": "$BUNDLE_ID",
  "team_id": "$TEAM_ID",
  "ipa_file": "$IPA_NAME",
  "file_size": "$IPA_SIZE",
  "build_date": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "flutter_version": "$(flutter --version | head -n1)",
  "xcode_version": "$(xcodebuild -version | head -n1)",
  "min_ios_version": "14.0",
  "supported_devices": [
    "iPhone 6s and later",
    "iPad Air 2 and later",
    "iPad mini 4 and later",
    "iPod touch 7th generation and later"
  ]
}
EOF

# Generate QR code for easy download
echo "${GREEN}📱 Generating QR code...${NC}"
if command -v qrencode &> /dev/null; then
    qrencode -o "$OUTPUT_DIR/install_qr.png" "https://your-server.com/$IPA_NAME"
    echo "${BLUE}📱 QR code generated: $OUTPUT_DIR/install_qr.png${NC}"
else
    echo "${YELLOW}⚠️ qrencode not found. Install with: brew install qrencode${NC}"
fi

# Create installation guide
echo "${GREEN}📖 Creating installation guide...${NC}"
cat > "$OUTPUT_DIR/INSTALL.md" << EOF
# 🍎 $APP_NAME iOS Installation

## 📋 What You Need
- iOS 14.0 or later
- 500MB free storage
- Stable internet connection

## 📲 Installation Methods

### Method 1: AltStore (Recommended)
1. Install AltStore: [altstore.io](https://altstore.io/)
2. Download this IPA: $IPA_NAME
3. Open AltStore → Tap this file → Install
4. Trust profile: Settings → General & Privacy → Trust Developer App

### Method 2: Sideloadly
1. Visit: [sideloadly.io](https://sideloadly.io/)
2. Upload this IPA file
3. Scan QR code with camera
4. Install and trust profile

### Method 3: Direct USB
1. Connect iPhone to Mac
2. Open Finder → Select your iPhone
3. Drag this IPA to your device
4. Enter passcode and trust profile

## 📱 App Information
- **Version**: 26.5
- **Size**: $IPA_SIZE
- **Bundle ID**: $BUNDLE_ID
- **Build Date**: $(date)
- **Valid Until**: $(date -v+7d +%Y-%m-%d)

## ⚠️ Important Notes
- This app will expire in 7 days
- Reinstall when expired
- iOS updates may require reinstallation
- Backup your data before updating

## 🆘 Troubleshooting
- **"Unable to Install"**: Check iOS version (needs 14.0+)
- **"Profile Expired"**: Rebuild and reinstall
- **"App Won't Open"**: Restart device and try again

## 📞 Support
- Email: support@yourapp.com
- Discord: [Your Server]
- Updates: https://yourapp.com/updates
EOF

# Success message
echo ""
echo "${GREEN}✅ IPA Build Complete!${NC}"
echo ""
echo "${BLUE}📦 Build Information:${NC}"
echo "  📁 Output: $OUTPUT_DIR"
echo "  📱 IPA File: $IPA_NAME"
echo "  📏 Size: $IPA_SIZE"
echo "  📅 Build: $(date)"
echo "  🔗 Bundle: $BUNDLE_ID"
echo ""
echo "${YELLOW}📲 Next Steps:${NC}"
echo "  1. Transfer IPA to your iOS device"
echo "  2. Install using AltStore, Sideloadly, or USB"
echo "  3. Trust developer profile in Settings"
echo "  4. Launch and enjoy!"
echo ""
echo "${BLUE}📖 Installation Guide: $OUTPUT_DIR/INSTALL.md${NC}"
echo "${BLUE}📱 QR Code: $OUTPUT_DIR/install_qr.png${NC}"
echo "${BLUE}📄 Build Info: $OUTPUT_DIR/build_info.json${NC}"
echo ""

# Open output directory
open "$OUTPUT_DIR"

echo "${GREEN}🎉 Ready for sideloading!${NC}"
