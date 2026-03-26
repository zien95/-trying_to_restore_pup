# 🍎 iOS Sideloading Guide

## 📱 IPA Sideloading Instructions

### 🔧 Build Requirements
- macOS with Xcode 14.0+
- iOS 14.0+ target
- Apple Developer Account (Free or Paid)
- Physical iOS device or Simulator

### 📦 Build IPA Files

#### Method 1: Flutter Build
```bash
# Build for iOS
flutter build ios --release

# Create IPA
cd build/ios/iphoneos
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -destination generic/platform=iOS \
  -archivePath ios_build

# Export IPA
xcodebuild -exportArchive \
  -archivePath ios_build/Runner.xcarchive \
  -exportPath ../ipa_output \
  -exportOptionsPlist ExportOptions.plist
```

#### Method 2: Fastlane (Recommended)
```ruby
# Fastfile
lane :build_ipa do
  build_app(
    scheme: "Runner",
    configuration: "Release",
    export_method: "ad-hoc"
  )
end
```

### 📋 ExportOptions.plist
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>ad-hoc</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>uploadBitcode</key>
    <false/>
    <key>compileBitcode</key>
    <false/>
</dict>
</plist>
```

### 📲 Sideloading Methods

#### Method 1: AltStore (Recommended)
1. Install AltStore from [altstore.io](https://altstore.io/)
2. Download IPA to device
3. Open AltStore → Tap IPA → Install
4. Trust developer profile in Settings → General & Privacy

#### Method 2: Sideloadly
1. Install Sideloadly from [sideloadly.io](https://sideloadly.io/)
2. Upload IPA to [sideloadly.io/upload](https://sideloadly.io/upload)
3. Scan QR code on iOS device
4. Install and trust profile

#### Method 3: Cydia Impactor
1. Install Cydia Impactor from [cydia-impactor.org](https://cydia-impactor.org/)
2. Upload IPA file
3. Enter Apple ID (free account works)
4. Install generated profile

#### Method 4: 3uTools
1. Install 3uTools from [3u.com](https://3u.com/)
2. Connect iOS device via USB
3. Drag IPA to 3uTools interface
4. Click Install

### 🔐 Code Signing Options

#### Free Apple ID
- Valid for 7 days
- Requires reinstallation weekly
- No developer account needed

#### Apple Developer Program
- Valid for 1 year
- Unlimited installations
- $99/year
- Required for App Store distribution

#### Enterprise Program
- Valid for 1 year
- Mass distribution
- $299/year
- No device limits

### 📱 Installation Steps

#### Standard Installation
1. Download IPA to device (Safari/Files)
2. Open Settings → General & Privacy
3. Tap "Install [App Name]"
4. Trust Developer Profile
5. Launch app from Home Screen

#### USB Installation (macOS only)
1. Connect iOS device to Mac
2. Open Finder → Select device
3. Drag IPA to device icon
4. Enter passcode if prompted
5. Trust profile in Settings

### ⚠️ Troubleshooting

#### Common Issues
- **"Unable to Install"**: Check iOS version compatibility
- **"Profile Expired"**: Rebuild and reinstall
- **"App Crashes"**: Check device compatibility
- **"Network Error"**: Use different sideloading method

#### Solutions
```bash
# Check iOS version
flutter config --ios-version

# Clean build
flutter clean
flutter pub get

# Rebuild with specific version
flutter build ios --release --no-codesign
```

### 🔄 Auto-Update System

#### In-App Updates
```dart
// Update checker for sideloaded apps
class UpdateChecker {
  static Future<void> checkForUpdates() async {
    try {
      final response = await http.get(
        Uri.parse('https://your-server.com/version.json')
      );
      
      final latestVersion = jsonDecode(response.body)['version'];
      final currentVersion = await _getCurrentVersion();
      
      if (latestVersion > currentVersion) {
        _showUpdateDialog(latestVersion);
      }
    } catch (e) {
      print('Update check failed: $e');
    }
  }
}
```

#### OTA Update Server
```json
{
  "version": "26.5",
  "build": "2024.02.22",
  "ipa_url": "https://your-server.com/app.ipa",
  "changelog": "Bug fixes and performance improvements",
  "min_ios_version": "14.0",
  "required": false
}
```

### 📊 Distribution Analytics

#### Installation Tracking
```dart
// Track installations for analytics
class Analytics {
  static Future<void> trackInstallation() async {
    final deviceId = await _getDeviceId();
    final installSource = await _getInstallSource();
    
    await http.post(
      Uri.parse('https://your-server.com/analytics'),
      body: {
        'device_id': deviceId,
        'install_source': installSource,
        'version': '26.5',
        'timestamp': DateTime.now().toIso8601String(),
        'platform': 'ios',
        'sideload_method': 'altstore'
      },
    );
  }
}
```

### 🛡️ Security Considerations

#### App Transport Security
- Enable ATS in Info.plist
- Use HTTPS for all network requests
- Implement certificate pinning

#### Code Signing Best Practices
- Use provisioning profiles
- Enable app transport security
- Implement jailbreak detection

#### User Privacy
- Clear data collection policy
- Anonymous analytics only
- No tracking without consent

### 📞 Support

#### Documentation
- [Full Guide](https://your-docs.com/ios-sideloading)
- [Video Tutorial](https://your-video.com/ipa-install)
- [Troubleshooting](https://your-support.com/ios-issues)

#### Contact
- Email: support@your-app.com
- Discord: [Your Discord Server]
- Telegram: @YourSupportBot
