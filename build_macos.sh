#!/bin/bash

# Flutter macOS Build Script
# This script builds a macOS app for distribution

set -e

echo "🖥️  Flutter macOS Build Script"
echo "============================="

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_NAME="${PROJECT_DIR##*/}"

cd "$PROJECT_DIR"

echo -e "${BLUE}Building macOS app: $APP_NAME${NC}"

# Check Flutter installation
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter not found in PATH${NC}"
    exit 1
fi

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ This script must be run on macOS to build macOS apps${NC}"
    exit 1
fi

# Clean build
echo -e "${YELLOW}🧹 Cleaning previous builds...${NC}"
flutter clean > /dev/null 2>&1 || true
rm -rf build/macos
rm -rf macos/Pods macos/Podfile.lock

# Get dependencies
echo -e "${YELLOW}📦 Getting dependencies...${NC}"
flutter pub get

# Build options
BUILD_MODE=${1:-release}  # Default to release mode

echo -e "${BLUE}Build Configuration:${NC}"
echo "  Mode: $BUILD_MODE"

# Build the macOS app
echo -e "${YELLOW}🔨 Building macOS app...${NC}"
flutter build macos --$BUILD_MODE --no-tree-shake-icons

# Check if build was successful
BUILD_MODE_CAPITALIZED="Release"
if [ "$BUILD_MODE" = "debug" ]; then
    BUILD_MODE_CAPITALIZED="Debug"
fi
APP_PATH="build/macos/Build/Products/$BUILD_MODE_CAPITALIZED/$APP_NAME.app"
if [ -d "$APP_PATH" ]; then
    APP_SIZE=$(du -sh "$APP_PATH" | cut -f1)
    echo -e "${GREEN}✅ macOS build completed successfully!${NC}"
    echo -e "${BLUE}App Location: $APP_PATH${NC}"
    echo -e "${BLUE}App Size: $APP_SIZE${NC}"
    echo ""
    echo -e "${GREEN}Ready to run! 🚀${NC}"
    echo "You can open the app by double-clicking or running:"
    echo "open \"$APP_PATH\""
else
    echo -e "${RED}❌ Build failed - app not found at expected location${NC}"
    echo "Expected: $APP_PATH"
    echo "Checking actual build output..."
    find build -name "*.app" -type d 2>/dev/null || echo "No .app files found"
    exit 1
fi

# Optional: Open the app
read -p "Do you want to open the app now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open "$APP_PATH"
fi

echo -e "${GREEN}✅ Script completed successfully!${NC}"
