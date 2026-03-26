#!/bin/bash

# Flutter IPA Build Script for Sideloadly
# This script builds an IPA file that can be sideloaded using Sideloadly

set -e

echo "🍎 Flutter IPA Build Script for Sideloadly"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get project directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo -e "${BLUE}Project Directory: $PROJECT_DIR${NC}"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed or not in PATH${NC}"
    echo "Please install Flutter first: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo -e "${GREEN}✅ Flutter found: $(flutter --version | head -1)${NC}"

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ This script must be run on macOS to build iOS apps${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Running on macOS${NC}"

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}❌ Xcode is not installed${NC}"
    echo "Please install Xcode from the App Store"
    exit 1
fi

echo -e "${GREEN}✅ Xcode found${NC}"

# Clean previous builds
echo -e "${YELLOW}🧹 Cleaning previous builds...${NC}"
flutter clean
rm -rf build/ios/ipa/

# Get dependencies
echo -e "${YELLOW}📦 Getting Flutter dependencies...${NC}"
flutter pub get

# Check for CocoaPods
if ! command -v pod &> /dev/null; then
    echo -e "${YELLOW}⚠️  CocoaPods not found, installing...${NC}"
    sudo gem install cocoapods
fi

# Update CocoaPods repos
echo -e "${YELLOW}📱 Updating CocoaPods repositories...${NC}"
cd ios
pod repo update
pod install
cd ..

# Build options
BUILD_MODE=${1:-release}  # Default to release mode
TEAM_ID=${2:-""}          # Optional: Your Apple Developer Team ID

echo -e "${BLUE}Build Configuration:${NC}"
echo "  Mode: $BUILD_MODE"
if [ ! -z "$TEAM_ID" ]; then
    echo "  Team ID: $TEAM_ID"
fi

# Build the iOS app
echo -e "${YELLOW}🔨 Building iOS app...${NC}"

if [ ! -z "$TEAM_ID" ]; then
    # Build with specific team ID
    flutter build ios --release --export-options-plist ios/ExportOptions.plist
else
    # Build without team ID (for Sideloadly)
    flutter build ios --release --no-codesign
fi

echo -e "${GREEN}✅ iOS build completed${NC}"

# Create IPA for Sideloadly
echo -e "${YELLOW}📦 Creating IPA for Sideloadly...${NC}"

# Navigate to build directory
cd build/ios/iphoneos

# Create Payload directory
mkdir -p Payload

# Copy the app bundle to Payload
cp -r Runner.app Payload/

# Create the IPA file
zip -r "../Sideloadly_${PROJECT_DIR##*/}.ipa" Payload/

# Clean up
rm -rf Payload

cd "$PROJECT_DIR"

echo -e "${GREEN}🎉 IPA created successfully!${NC}"
echo -e "${BLUE}IPA Location: build/ios/Sideloadly_${PROJECT_DIR##*/}.ipa${NC}"

# Display file info
IPA_PATH="build/ios/Sideloadly_${PROJECT_DIR##*/}.ipa"
if [ -f "$IPA_PATH" ]; then
    IPA_SIZE=$(du -h "$IPA_PATH" | cut -f1)
    echo -e "${BLUE}IPA Size: $IPA_SIZE${NC}"
fi

echo ""
echo -e "${GREEN}Next steps:${NC}"
echo "1. Open Sideloadly on your Mac"
echo "2. Connect your iPhone/iPad via USB"
echo "3. Drag and drop the IPA file to Sideloadly"
echo "4. Enter your Apple ID and password"
echo "5. Click 'Start' to sideload the app"
echo ""
echo -e "${YELLOW}Note: You'll need a free Apple ID for sideloading${NC}"
echo -e "${YELLOW}The app will expire in 7 days and need to be reinstalled${NC}"

# Optional: Open Finder to the IPA location
read -p "Do you want to open the folder containing the IPA? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open build/ios/
fi

echo -e "${GREEN}✅ Script completed successfully!${NC}"
