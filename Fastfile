# 🍎 Fastfile for iOS IPA Sideloading
# Automated build and distribution system

fastlane_version "2.220.0"

default_platform(:ios)

# 🏗️ Build Configuration
before_all do
  puts "🍎 Starting iOS IPA build process..."
  
  # Ensure Flutter is ready
  sh("flutter clean")
  sh("flutter pub get")
  
  # Check Flutter version
  flutter_version = sh("flutter --version").strip
  puts "📱 Flutter version: #{flutter_version}"
end

# 📦 Build IPA for Sideloading
lane :build_sideload_ipa do
  puts "🏗️ Building IPA for sideloading..."
  
  build_app(
    scheme: "Runner",
    configuration: "Release",
    export_method: "ad-hoc",
    output_directory: "./ipa_output",
    output_name: "PupGame_v26.5",
    include_bitcode: false,
    include_symbols: false
  )
  
  puts "✅ IPA build completed!"
  puts "📁 Output: ./ipa_output"
end

# 📲 Build for Different Sideloading Methods
lane :build_all_methods do
  puts "🍎 Building IPAs for all sideloading methods..."
  
  # Standard Ad-Hoc
  build_app(
    scheme: "Runner",
    configuration: "Release",
    export_method: "ad-hoc",
    output_directory: "./ipa_output/adhoc",
    output_name: "PupGame_AdHoc",
    include_bitcode: false
  )
  
  # Development (for testing)
  build_app(
    scheme: "Runner",
    configuration: "Debug",
    export_method: "development",
    output_directory: "./ipa_output/development",
    output_name: "PupGame_Dev",
    include_bitcode: true
  )
  
  puts "✅ All IPA builds completed!"
end

# 🔐 Code Signing and Provisioning
lane :update_provisioning do
  puts "🔐 Updating provisioning profiles..."
  
  # Download latest provisioning from Apple Developer Portal
  download_provisioning(
    type: "development",
    team_id: ENV["TEAM_ID"]
  )
  
  download_provisioning(
    type: "ad-hoc", 
    team_id: ENV["TEAM_ID"]
  )
  
  puts "✅ Provisioning profiles updated!"
end

# 📤 Upload to Distribution Services
lane :distribute_ipa do
  puts "📤 Uploading IPA to distribution services..."
  
  ipa_path = lane_context[SharedValues::IPA_OUTPUT_PATH]
  
  # Upload to Sideloadly
  if ENV["SIDELOADLY_API_KEY"]
    sh("curl -X POST https://api.sideloadly.io/v1/upload \\
         -H 'Authorization: Bearer #{ENV['SIDELOADLY_API_KEY']}' \\
         -F 'file=@#{ipa_path}' \\
         -F 'version=26.5' \\
         -F 'changelog=Quantum Leap Update with AI companions'")
  end
  
  # Upload to AltStore (if configured)
  if ENV["ALTSTORE_API_KEY"]
    sh("curl -X POST https://api.altstore.io/v1/upload \\
         -H 'Authorization: Bearer #{ENV['ALTSTORE_API_KEY']}' \\
         -F 'file=@#{ipa_path}' \\
         -F 'version=26.5' \\
         -F 'bundle_id=com.yourcompany.pupgame'")
  end
  
  puts "✅ IPA distributed to sideloading services!"
end

# 📊 Generate Build Analytics
lane :build_analytics do
  puts "📊 Generating build analytics..."
  
  # Get build information
  build_info = {
    version: "26.5",
    build_number: lane_context[SharedValues::BUILD_NUMBER],
    flutter_version: sh("flutter --version").strip,
    xcode_version: sh("xcodebuild -version").strip,
    build_time: Time.now.strftime("%Y-%m-%d %H:%M:%S"),
    git_commit: sh("git rev-parse HEAD").strip,
    git_branch: sh("git rev-parse --abbrev-ref HEAD").strip
  }
  
  # Save analytics
  File.write("./build_analytics.json", JSON.pretty_generate(build_info))
  
  puts "✅ Build analytics saved!"
end

# 🧪 Clean Build Artifacts
lane :clean_builds do
  puts "🧪 Cleaning build artifacts..."
  
  sh("rm -rf ./ipa_output")
  sh("rm -rf ./ios_build")
  sh("rm -rf ./build")
  
  puts "✅ Build artifacts cleaned!"
end

# 📱 Create Installation Package
lane :create_install_package do
  puts "📱 Creating installation package..."
  
  ipa_path = lane_context[SharedValues::IPA_OUTPUT_PATH]
  output_dir = "./install_package"
  
  sh("mkdir -p #{output_dir}")
  
  # Copy IPA
  sh("cp #{ipa_path} #{output_dir}/")
  
  # Create installation guide
  install_guide = <<~MARKDOWN
# 🍎 PupGame v26.5 Installation

## 📋 Requirements
- iOS 14.0 or later
- 500MB free storage
- Stable internet connection

## 📲 Installation Methods

### 🥇 AltStore (Recommended)
1. Install AltStore from [altstore.io](https://altstore.io/)
2. Download IPA below
3. Open AltStore → Tap IPA → Install
4. Trust profile in Settings

### 🥈 Sideloadly
1. Visit [sideloadly.io](https://sideloadly.io/)
2. Upload this IPA file
3. Scan QR code
4. Install and trust

### 🥉 Direct USB
1. Connect iPhone to Mac
2. Open Finder → Select device
3. Drag IPA to device
4. Trust profile

## 📱 App Info
- **Version**: 26.5 Quantum Leap
- **Build**: #{lane_context[SharedValues::BUILD_NUMBER]}
- **Size**: #{File.size(ipa_path) / (1024.0 * 1024.0)}MB
- **Bundle ID**: com.yourcompany.pupgame

## ⚠️ Important
- Expires in 7 days (free Apple ID)
- Requires iOS 14.0+
- Backup data before updating

## 🆘 Troubleshooting
- **"Unable to Install"**: Check iOS version
- **"Profile Expired"**: Rebuild and reinstall
- **"App Crashes"**: Restart device

## 📞 Support
- Email: support@pupgame.com
- Discord: [Your Discord]
- Updates: https://pupgame.com/updates
  MARKDOWN
  
  File.write("#{output_dir}/INSTALL.md", install_guide)
  
  # Generate QR code
  sh("qrencode -o #{output_dir}/install_qr.png 'https://pupgame.com/download'")
  
  # Create metadata
  metadata = {
    version: "26.5",
    ipa_url: "https://pupgame.com/download/PupGame_v26.5.ipa",
    install_guide: "https://pupgame.com/install",
    qr_code: "https://pupgame.com/qr",
    min_ios_version: "14.0",
    max_ios_version: "17.0",
    supported_devices: [
      "iPhone 6s and later",
      "iPad Air 2 and later", 
      "iPad mini 4 and later",
      "iPod touch 7th generation"
    ]
  }
  
  File.write("#{output_dir}/metadata.json", JSON.pretty_generate(metadata))
  
  puts "✅ Installation package created!"
  puts "📁 Output: #{output_dir}"
end

# 🚀 Deploy to TestFlight
lane :deploy_testflight do
  puts "🚀 Deploying to TestFlight..."
  
  upload_to_testflight(
    ipa_path: lane_context[SharedValues::IPA_OUTPUT_PATH],
    changelog: "Quantum Leap Update with AI companions and advanced pet care features",
    beta_description: "Test the latest quantum pet care features before public release",
    expire_date: Time.now + (60 * 60 * 24 * 90) # 90 days
  )
  
  puts "✅ Deployed to TestFlight!"
end

# Error handling
error do |lane, exception|
  puts "❌ Error in lane #{lane}: #{exception.message}"
  
  # Send notification to team
  if ENV["SLACK_WEBHOOK"]
    sh("curl -X POST #{ENV['SLACK_WEBHOOK']} \\
         -H 'Content-type: application/json' \\
         -d '{\"text\":\"❌ iOS build failed: #{lane}\\nError: #{exception.message}\"}'")
  end
end
