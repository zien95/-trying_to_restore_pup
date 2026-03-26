#!/bin/bash

# Quick IPA Build for Sideloadly (No Code Signing Required)
# This script creates an IPA file specifically for Sideloadly sideloading

set -e

echo "🍎 Quick IPA Build for Sideloadly"
echo "================================="

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_NAME="${PROJECT_DIR##*/}"

cd "$PROJECT_DIR"

echo -e "${BLUE}Building: $APP_NAME${NC}"

# Check Flutter installation
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter not found in PATH${NC}"
    exit 1
fi

# Quick clean and get dependencies
echo -e "${YELLOW}🧹 Quick clean...${NC}"
flutter clean > /dev/null 2>&1 || true
flutter pub get

# Fix CocoaPods platform warning
echo -e "${YELLOW}🔧 Fixing iOS configuration...${NC}"
cd ios
if ! grep -q "platform :ios" Podfile; then
    echo "platform :ios, '13.0'" >> Podfile
fi
pod install --repo-update
cd ..

# Build for iOS without code signing and disable icon tree shaking
echo -e "${YELLOW}🔨 Building iOS app (no codesign, no tree-shake)...${NC}"
flutter build ios --release --no-codesign --no-tree-shake-icons

# Create IPA
echo -e "${YELLOW}📦 Creating IPA...${NC}"
cd build/ios/iphoneos

if [ ! -d "Runner.app" ]; then
    echo -e "${RED}❌ Runner.app not found. Build failed.${NC}"
    exit 1
fi

mkdir -p Payload
cp -r Runner.app Payload/
zip -r "../Sideloadly_$APP_NAME.ipa" Payload/
rm -rf Payload

cd "$PROJECT_DIR"

IPA_PATH="build/ios/Sideloadly_$APP_NAME.ipa"
if [ -f "$IPA_PATH" ]; then
    IPA_SIZE=$(du -h "$IPA_PATH" | cut -f1)
    echo -e "${GREEN}✅ Done!${NC}"
    echo -e "${BLUE}IPA: $IPA_PATH ($IPA_SIZE)${NC}"
    echo ""
    echo "Ready for Sideloadly! 🚀"
else
    echo -e "${RED}❌ IPA creation failed${NC}"
    exit 1
fi
