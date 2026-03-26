#!/bin/bash

# 🖥️ macOS Build Script
# Automated macOS app generation for sideloading

set -e

echo "🖥️ Building macOS app for distribution..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="PupGame"
BUNDLE_ID="${BUNDLE_ID:-com.yourcompany.pupgame}"
OUTPUT_DIR="./macos_output"
BUILD_PATH="./macos_build"

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

if ! command -v xcodebuild &> /dev/null; then
    echo "${RED}❌ Xcode not found. Install Xcode first.${NC}"
    exit 1
fi

# Get Flutter version
echo "${BLUE}📱 Flutter version:${NC}"
flutter --version

# Build Flutter app for macOS
echo "${GREEN}🏗️ Building Flutter app for macOS...${NC}"
flutter build macos --release

if [ $? -ne 0 ]; then
    echo "${RED}❌ Flutter build failed!${NC}"
    exit 1
fi

# Navigate to macOS build directory
cd build/macos/Build/Products/Release

# Create app bundle
echo "${GREEN}📦 Creating macOS app bundle...${NC}"
# Create app structure
mkdir -p "$APP_NAME.app/Contents/MacOS"
mkdir -p "$APP_NAME.app/Contents/Resources"

# Copy executable
cp "$APP_NAME" "$APP_NAME.app/Contents/MacOS/"

# Create Info.plist
echo "${GREEN}📋 Creating Info.plist...${NC}"
cat > "$APP_NAME.app/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDisplayName</key>
    <string>$APP_NAME</string>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>$BUNDLE_ID</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>26.5</string>
    <key>CFBundleVersion</key>
    <string>26.5</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.15</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSSupportsAutomaticGraphicsSwitching</key>
    <true/>
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
        <key>NSAllowsLocalNetworking</key>
        <true/>
        <key>NSDisableDomainExpansion</key>
        <true/>
    </dict>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.games</string>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2024 Your Company</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
</dict>
</plist>
EOF

# Create icon (if available)
if [ -f "../assets/icon.png" ]; then
    mkdir -p "$APP_NAME.app/Contents/Resources"
    cp "../assets/icon.png" "$APP_NAME.app/Contents/Resources/AppIcon.icns"
fi

# Copy to output directory
echo "${GREEN}📤 Copying app bundle...${NC}"
cp -R "$APP_NAME.app" "$OUTPUT_DIR/"

# Get app info
APP_SIZE=$(du -h "$OUTPUT_DIR/$APP_NAME.app" | cut -f1)

# Create DMG (optional)
echo "${GREEN}💿 Creating DMG installer...${NC}"
if command -v hdiutil &> /dev/null; then
    # Create DMG
    hdiutil create -volname "$APP_NAME" -srcfolder "$OUTPUT_DIR" -ov -format UDZO "$OUTPUT_DIR/$APP_NAME.dmg"
    
    if [ -f "$OUTPUT_DIR/$APP_NAME.dmg" ]; then
        DMG_SIZE=$(du -h "$OUTPUT_DIR/$APP_NAME.dmg" | cut -f1)
        echo "${BLUE}💿 DMG created: $APP_NAME.dmg ($DMG_SIZE)${NC}"
    fi
else
    echo "${YELLOW}⚠️ hdiutil not found. Skipping DMG creation.${NC}"
fi

# Create info file
echo "${GREEN}📄 Creating build info...${NC}"
cat > "$OUTPUT_DIR/build_info.json" << EOF
{
  "app_name": "$APP_NAME",
  "version": "26.5",
  "build": "$(date +%Y%m%d_%H%M%S)",
  "bundle_id": "$BUNDLE_ID",
  "app_file": "$APP_NAME.app",
  "file_size": "$APP_SIZE",
  "build_date": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "flutter_version": "$(flutter --version | head -n1)",
  "xcode_version": "$(xcodebuild -version | head -n1)",
  "min_macos_version": "10.15",
  "supported_architectures": [
    "x86_64",
    "arm64"
  ],
  "distribution_methods": [
    "direct_download",
    "dmg_installer",
    "app_store"
  ]
}
EOF

# Create installation guide
echo "${GREEN}📖 Creating installation guide...${NC}"
cat > "$OUTPUT_DIR/INSTALL.md" << EOF
# 🖥️ $APP_NAME macOS Installation

## 📋 What You Need
- macOS 10.15 (Catalina) or later
- 500MB free storage
- Administrative privileges (for first installation)

## 📦 Installation Methods

### Method 1: Direct Download
1. Download $APP_NAME.app
2. Double-click to mount
3. Drag to Applications folder
4. Launch from Launchpad

### Method 2: DMG Installer
1. Download $APP_NAME.dmg
2. Double-click to open DMG
3. Drag $APP_NAME.app to Applications
4. Eject DMG
5. Launch from Launchpad

### Method 3: Command Line
\`\`\`bash
# Install to /Applications
sudo cp -R "$APP_NAME.app" /Applications/

# Fix permissions
sudo xattr -dr com.apple.quarantine /Applications/"$APP_NAME.app"
\`\`\`

## 🔐 Security Considerations

### Gatekeeper Bypass
If you see "damaged" error:
\`\`\`bash
# Allow app from anywhere
sudo spctl --master-disable

# Remove quarantine flag
sudo xattr -dr com.apple.quarantine /Applications/"$APP_NAME.app"
\`\`\`

## 📱 App Information
- **Version**: 26.5
- **Size**: $APP_SIZE
- **Bundle ID**: $BUNDLE_ID
- **Build Date**: $(date)
- **macOS Compatibility**: 10.15+

## ⚠️ Important Notes
- This app is not signed for App Store distribution
- macOS may show security warnings
- Allow app in Security & Privacy if needed
- Works on Intel and Apple Silicon Macs

## 🆘 Troubleshooting

### "App is damaged and can't be opened"
1. Right-click app → Show in Finder
2. Double-click app in Finder
3. Or run: sudo xattr -dr com.apple.quarantine /Applications/$APP_NAME.app

### "App can't be opened because Apple cannot check it for malicious software"
1. Open System Preferences → Security & Privacy
2. Click "Allow Anyway" button
3. Try launching again

## 📞 Support
- Email: support@yourapp.com
- Discord: [Your Discord Server]
- Updates: https://yourapp.com/updates
EOF

# Success message
echo ""
echo "${GREEN}✅ macOS Build Complete!${NC}"
echo ""
echo "${BLUE}📦 Build Information:${NC}"
echo "  📁 Output: $OUTPUT_DIR"
echo "  🖥️ App: $APP_NAME.app"
echo "  💿 DMG: $APP_NAME.dmg"
echo "  📏 Size: $APP_SIZE"
echo "  📅 Build: $(date)"
echo "  🔗 Bundle: $BUNDLE_ID"
echo ""
echo "${YELLOW}📲 Next Steps:${NC}"
echo "  1. Distribute .app or .dmg file"
echo "  2. Users may need to bypass Gatekeeper"
echo "  3. Include security instructions"
echo ""
echo "${BLUE}📖 Installation Guide: $OUTPUT_DIR/INSTALL.md${NC}"
echo "${BLUE}📄 Build Info: $OUTPUT_DIR/build_info.json${NC}"
echo ""

# Open output directory
open "$OUTPUT_DIR"

echo "${GREEN}🎉 Ready for macOS distribution!${NC}"
