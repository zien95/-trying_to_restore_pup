# Payment Setup Instructions

## iOS Setup (App Store)

1. **Configure App Store Connect**
   - Go to [App Store Connect](https://appstoreconnect.apple.com)
   - Select your app → Features → In-App Purchases
   - Create two new in-app purchase products:
     - **Product ID**: `premium_monthly`
     - **Product ID**: `premium_yearly`
   - Set prices and subscription durations

2. **Update App Store Configuration**
   - Add the in-app purchase capability to your app
   - Set up banking information and tax forms
   - Submit products for review

3. **Xcode Configuration**
   - Open `ios/Runner.xcodeproj`
   - Go to Signing & Capabilities
   - Add "In-App Purchase" capability

## Android Setup (Google Play)

1. **Configure Google Play Console**
   - Go to [Google Play Console](https://play.google.com/console)
   - Select your app → Monetize → Products
   - Create two new products:
     - **Product ID**: `premium_monthly`
     - **Product ID**: `premium_yearly`
   - Set prices and subscription details

2. **Update Android Configuration**
   - Add billing permission to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="com.android.vending.BILLING" />
   ```

3. **Testing**
   - Add test accounts in Google Play Console
   - Upload a signed APK for testing

## Product Configuration

### Product IDs Used in Code
- `premium_monthly` - Monthly premium subscription
- `premium_yearly` - Yearly premium subscription (17% discount)

### Price Points
- Monthly: $9.99/month
- Yearly: $99.99/year (saves ~$20)

## Testing

### iOS Testing
- Use Sandbox accounts for testing
- Test on physical devices (not simulator)
- Verify purchase flow and receipt validation

### Android Testing
- Use test accounts in Google Play Console
- Test on physical devices with Play Store
- Verify billing flow and subscription management

## Security Considerations

1. **Receipt Validation**
   - Implement server-side receipt validation
   - Verify purchases with Apple/Google servers
   - Store purchase tokens securely

2. **Subscription Management**
   - Handle subscription cancellations
   - Check subscription status regularly
   - Grace period handling

3. **Fraud Prevention**
   - Validate purchase receipts
   - Monitor for suspicious activity
   - Implement purchase limits

## Production Deployment

1. **App Store Review**
   - Ensure in-app purchases are properly configured
   - Test purchase flow thoroughly
   - Provide test accounts if requested

2. **Google Play Review**
   - Verify billing implementation
   - Test subscription management
   - Ensure privacy policy covers payments

## Troubleshooting

### Common Issues
- **Product not found**: Check product IDs match exactly
- **Billing unavailable**: Ensure device has Play Store/App Store
- **Purchase fails**: Check network connection and payment method

### Debug Mode
- Use test products during development
- Enable debug logging in payment service
- Test edge cases (network loss, cancellation)

## Server Integration (Optional)

For production apps, consider:
- Server-side receipt validation
- Subscription status webhooks
- User account linking across platforms
- Analytics for purchase tracking
