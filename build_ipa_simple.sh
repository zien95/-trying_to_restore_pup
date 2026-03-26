#!/bin/bash

# 🍎 Simple iOS IPA Build Script
# Direct IPA generation from existing build

set -e

echo "🍎 Creating IPA from existing build..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="PupGame"
OUTPUT_DIR="./ipa_output"

# Clean previous builds
echo "${YELLOW}🧹 Cleaning previous builds...${NC}"
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# Check if build exists
if [ ! -d "build/ios/iphoneos/Runner.app" ]; then
    echo "${RED}❌ iOS build not found. Running Flutter build first...${NC}"
    flutter build ios --release --no-tree-shake-icons
fi

if [ ! -d "build/ios/iphoneos/Runner.app" ]; then
    echo "${RED}❌ Flutter build failed!${NC}"
    exit 1
fi

# Copy app to output directory
echo "${GREEN}📦 Creating IPA package...${NC}"
cp -R "build/ios/iphoneos/Runner.app" "$OUTPUT_DIR/"

# Get app info
APP_SIZE=$(du -h "$OUTPUT_DIR/Runner.app" | cut -f1)

# Create simple IPA (zip format)
echo "${GREEN}📦 Creating IPA file...${NC}"
cd "$OUTPUT_DIR"
zip -r "${APP_NAME}_v26.5.ipa" "Runner.app"

# Create info file
echo "${GREEN}📄 Creating build info...${NC}"
cat > "$OUTPUT_DIR/build_info.json" << EOF
{
  "app_name": "$APP_NAME",
  "version": "26.5",
  "build": "$(date +%Y%m%d_%H%M%S)",
  "bundle_id": "com.example.tryingToRestorePup",
  "ipa_file": "${APP_NAME}_v26.5.ipa",
  "file_size": "$APP_SIZE",
  "build_date": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "flutter_version": "$(flutter --version | head -n1)",
  "min_ios_version": "14.0",
  "supported_devices": [
    "iPhone 6s and later",
    "iPad Air 2 and later",
    "iPad mini 4 and later",
    "iPod touch 7th generation and later"
  ],
  "distribution_methods": [
    "altstore",
    "sideloadly",
    "cydia_impactor",
    "direct_install"
  ]
}
EOF

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
2. Download this IPA: ${APP_NAME}_v26.5.ipa
3. Open AltStore → Tap this file → Install
4. Trust profile: Settings → General & Privacy → Trust Developer App

### Method 2: Sideloadly
1. Visit: [sideloadly.io](https://sideloadly.io/)
2. Upload this IPA file
3. Scan QR code with camera
4. Install and trust profile

### Method 3: Cydia Impactor
1. Install Cydia Impactor: [cydia-impactor.org](https://cydia-impactor.org/)
2. Upload this IPA file
3. Enter Apple ID (free account works)
4. Install generated profile

### Method 4: Direct USB (macOS only)
1. Connect iPhone to Mac
2. Open Finder → Select your iPhone
3. Drag this IPA to your device
4. Enter passcode and trust profile

## 📱 App Information
- **Version**: 26.5
- **Size**: $APP_SIZE
- **Bundle ID**: com.example.tryingToRestorePup
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

# Generate QR code for easy download
echo "${GREEN}📱 Generating QR code...${NC}"
if command -v qrencode &> /dev/null; then
    qrencode -o "$OUTPUT_DIR/install_qr.png" "https://your-server.com/${APP_NAME}_v26.5.ipa"
    echo "${BLUE}📱 QR code generated: $OUTPUT_DIR/install_qr.png${NC}"
else
    echo "${YELLOW}⚠️ qrencode not found. Install with: brew install qrencode${NC}"
fi

# Success message
echo ""
echo "${GREEN}✅ IPA Build Complete!${NC}"
echo ""
echo "${BLUE}📦 Build Information:${NC}"
echo "  📁 Output: $OUTPUT_DIR"
echo "  📱 IPA File: ${APP_NAME}_v26.5.ipa"
echo "  📏 Size: $APP_SIZE"
echo "  📅 Build: $(date)"
echo "  🔗 Bundle: com.example.tryingToRestorePup"
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

echo "${GREEN}🎉 IPA ready for sideloading!${NC}"
