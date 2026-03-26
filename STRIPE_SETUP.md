# Stripe Payment Setup Instructions

## Overview
Your Flutter game now uses **Stripe** for direct credit card payments, avoiding the 30% App Store/Google Play fees.

## Fee Comparison
- **App Store/Google Play**: 30% commission
- **Stripe**: 2.9% + $0.30 per transaction
- **Your Savings**: ~27% more revenue!

## Setup Instructions

### 1. Create Stripe Account
1. Go to [Stripe Dashboard](https://dashboard.stripe.com/register)
2. Sign up for a Stripe account
3. Complete business verification
4. Add your bank account for payouts

### 2. Get API Keys
1. In Stripe Dashboard → Developers → API keys
2. Copy your **Publishable Key** (starts with `pk_`)
3. Copy your **Secret Key** (starts with `sk_`)

### 3. Update Configuration
Edit `lib/services/stripe_payment_service.dart`:

```dart
static const String _publishableKey = 'pk_live_YOUR_PUBLISHABLE_KEY';
static const String _secretKey = 'sk_live_YOUR_SECRET_KEY';
```

**For Testing:**
```dart
static const String _publishableKey = 'pk_test_51234567890abcdef';
static const String _secretKey = 'sk_test_51234567890abcdef';
```

### 4. Platform Configuration

#### iOS Setup
1. Add to `ios/Runner/Info.plist`:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

2. Update `ios/Runner/AppDelegate.swift`:
```swift
import UIKit
import Flutter
import flutter_stripe

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        StripeAPI.defaultPublishableKey = "pk_live_YOUR_PUBLISHABLE_KEY"
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

#### Android Setup
1. Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

2. Update `android/app/src/main/kotlin/.../MainActivity.kt`:
```kotlin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.stripe.android.PaymentConfiguration

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        PaymentConfiguration.init(
            applicationContext,
            "pk_live_YOUR_PUBLISHABLE_KEY"
        )
    }
}
```

### 5. Testing

#### Test Cards
Use these Stripe test cards:
- **Visa**: 4242 4242 4242 4242
- **Mastercard**: 5555 5555 5555 4444
- **Declined**: 4000 0000 0000 0002

#### Test Details
- **Expiry**: Any future date
- **CVC**: Any 3 digits
- **ZIP**: Any 5 digits

### 6. Production Deployment

#### Webhook Setup (Recommended)
1. Stripe Dashboard → Developers → Webhooks
2. Add endpoint: `https://yourserver.com/stripe-webhook`
3. Listen for events:
   - `payment_intent.succeeded`
   - `payment_intent.payment_failed`
   - `invoice.payment_succeeded` (for subscriptions)

#### Server-Side Validation (Optional but Recommended)
```javascript
// Example Node.js server
const stripe = require('stripe')('sk_live_YOUR_SECRET_KEY');

app.post('/create-payment-intent', async (req, res) => {
  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount: 999, // $9.99 in cents
      currency: 'usd',
      receipt_email: req.body.email,
    });
    res.json({ client_secret: paymentIntent.client_secret });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
```

## Payment Flow

### Current Implementation
1. User clicks "Upgrade Now"
2. Stripe payment sheet appears
3. User enters credit card details
4. Stripe processes payment securely
5. Payment confirmed → Premium activated
6. Receipt sent to user's email

### Security Features
- **PCI Compliance**: Stripe handles all card data
- **3D Secure**: Supported for enhanced security
- **Fraud Detection**: Built-in Stripe protection
- **SSL Encryption**: All communications encrypted

## Pricing Configuration

### Current Prices
- **Monthly**: $9.99 (999 cents)
- **Yearly**: $99.99 (9999 cents)

### To Change Prices
Edit `lib/services/stripe_payment_service.dart`:
```dart
String getMonthlyPriceInCents() => '1499'; // $14.99
String getYearlyPriceInCents() => '14999'; // $149.99
```

## Payout Schedule

### Stripe Payouts
- **US**: 2 business days
- **Europe**: 7 business days
- **International**: 7-14 business days

### Minimum Payout
- **US/Canada**: $25
- **International**: $250

## Troubleshooting

### Common Issues
1. **"No such payment intent"**: Check API keys
2. **"Invalid API key"**: Verify secret key configuration
3. **Payment fails**: Use test cards first
4. **iOS crashes**: Check Info.plist configuration

### Debug Mode
Enable Stripe logging:
```dart
// In main.dart
void main() {
  Stripe.publishableKey = 'pk_test_...';
  Stripe.instance.applySettings().then((_) {
    runApp(MyApp());
  });
}
```

## Compliance

### Required by Stripe
- **Privacy Policy**: Must be accessible in app
- **Terms of Service**: Required for payments
- **Refund Policy**: Clear refund process
- **Contact Info**: Business contact details

### GDPR Compliance
- Store payment data securely
- Allow data deletion requests
- Clear data usage policy

## Next Steps

1. **Test thoroughly** with Stripe test mode
2. **Set up webhooks** for production
3. **Add server validation** for enhanced security
4. **Configure payouts** to your bank account
5. **Monitor dashboard** for payment analytics

Your game is now ready to accept direct credit card payments with much lower fees than app stores!
