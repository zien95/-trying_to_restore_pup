import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account_provider.dart';
import '../services/stripe_payment_service.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final StripePaymentService _paymentService = StripePaymentService();
  bool _isPaymentLoading = false;
  bool _isPaymentAvailable = false;
  String? _paymentError;

  @override
  void initState() {
    super.initState();
    _initializePaymentService();
  }

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
  }

  Future<void> _initializePaymentService() async {
    try {
      await _paymentService.initialize();
      setState(() {
        _isPaymentAvailable = _paymentService.isInitialized;
      });
    } catch (e) {
      setState(() {
        _paymentError = 'Failed to initialize payment service: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D3A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B1FA2),
        title: const Text('Premium Features', style: TextStyle(color: Colors.white)),
      ),
      body: Consumer<AccountProvider>(
        builder: (context, accountProvider, child) {
          final account = accountProvider.account;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Premium Status Card
                _buildPremiumStatusCard(context, account, accountProvider),
                
                const SizedBox(height: 24),
                
                // Features Overview
                const Text(
                  'Premium Features',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Premium Features List
                ..._buildPremiumFeatures(account?.isPremium ?? false),
                
                const SizedBox(height: 24),
                
                // Pricing Plans
                if (!(account?.isPremium ?? false))
                  _buildPricingPlans(context, accountProvider),
                
                const SizedBox(height: 24),
                
                // Benefits Comparison
                _buildComparisonTable(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPremiumStatusCard(BuildContext context, account, AccountProvider accountProvider) {
    final isPremium = account?.isPremium ?? false;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPremium 
            ? [Colors.amber, Colors.orange]
            : [Colors.grey.shade700, Colors.grey.shade500],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isPremium ? Colors.amber.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            isPremium ? Icons.star : Icons.star_border,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          Text(
            isPremium ? 'Premium Member' : 'Free Account',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isPremium 
              ? 'Enjoy all premium features and benefits!'
              : 'Upgrade to Premium for the best experience',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          if (isPremium) ...[
            const SizedBox(height: 12),
            Text(
              'Member since ${account?.createdAt.day}/${account?.createdAt.month}/${account?.createdAt.year}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildPremiumFeatures(bool isPremium) {
    final features = [
      {
        'title': 'Unlimited Pets',
        'description': 'Care for multiple pets simultaneously',
        'icon': Icons.pets,
        'available': isPremium,
      },
      {
        'title': 'Exclusive Mini-Games',
        'description': 'Access premium-only games and content',
        'icon': Icons.videogame_asset,
        'available': isPremium,
      },
      {
        'title': 'Ad-Free Experience',
        'description': 'Enjoy the game without any advertisements',
        'icon': Icons.block,
        'available': isPremium,
      },
      {
        'title': 'Daily Bonus x2',
        'description': 'Double rewards from daily challenges',
        'icon': Icons.monetization_on,
        'available': isPremium,
      },
      {
        'title': 'Custom Themes',
        'description': 'Personalize your game with exclusive themes',
        'icon': Icons.palette,
        'available': isPremium,
      },
      {
        'title': 'Cloud Sync',
        'description': 'Sync progress across all devices',
        'icon': Icons.cloud_sync,
        'available': isPremium,
      },
      {
        'title': 'Priority Support',
        'description': 'Get faster customer support responses',
        'icon': Icons.support_agent,
        'available': isPremium,
      },
      {
        'title': 'Early Access',
        'description': 'Try new features before anyone else',
        'icon': Icons.new_releases,
        'available': isPremium,
      },
    ];

    return features.map((feature) => _buildFeatureCard(feature)).toList();
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature) {
    final isAvailable = feature['available'] as bool;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isAvailable ? const Color(0xFF4A5F4A) : const Color(0xFF3D3D4A),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isAvailable ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                feature['icon'] as IconData,
                color: isAvailable ? Colors.green : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature['title'] as String,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feature['description'] as String,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isAvailable ? Icons.check_circle : Icons.lock,
              color: isAvailable ? Colors.green : Colors.grey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingPlans(BuildContext context, AccountProvider accountProvider) {
    final monthlyPrice = 'AED ${_paymentService.getMonthlyPriceDisplay()}';
    final yearlyPrice = 'AED ${_paymentService.getYearlyPriceDisplay()}';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Your Plan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        
        if (_paymentError != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _paymentError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
        
        if (!_isPaymentAvailable && _paymentError == null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Payment service is initializing. Direct credit card payments via Stripe (2.9% + \$0.30 fee).',
                    style: TextStyle(color: Colors.orange, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
        
        const SizedBox(height: 8),
        
        Row(
          children: [
            // Free Plan
            Expanded(
              child: _buildPlanCard(
                'Free',
                'AED 0',
                ['Basic features', 'Limited pets', 'Advertisements'],
                Colors.grey,
                false,
                null,
              ),
            ),
            const SizedBox(width: 16),
            // Premium Monthly Plan
            Expanded(
              child: _buildPlanCard(
                'Premium Monthly',
                monthlyPrice,
                ['All features', 'Unlimited pets', 'No ads', 'Cloud sync'],
                Colors.amber,
                true,
                _isPaymentAvailable 
                  ? () => _purchasePremiumMonthly(context, accountProvider)
                  : () => _upgradeToPremiumDemo(context, accountProvider),
                isLoading: _isPaymentLoading,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Premium Yearly Plan
        Row(
          children: [
            const Expanded(child: SizedBox()), // Spacer
            Expanded(
              child: _buildPlanCard(
                'Premium Yearly',
                yearlyPrice,
                ['Save 17%', 'All monthly features', 'Priority support'],
                Colors.purple,
                true,
                _isPaymentAvailable 
                  ? () => _purchasePremiumYearly(context, accountProvider)
                  : () => _upgradeToPremiumDemo(context, accountProvider),
                isLoading: _isPaymentLoading,
              ),
            ),
            const Expanded(child: SizedBox()), // Spacer
          ],
        ),
      ],
    );
  }

  Widget _buildPlanCard(
    String name,
    String price,
    List<String> features,
    Color color,
    bool isHighlighted,
    VoidCallback? onUpgrade, {
    bool isLoading = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isHighlighted ? color.withOpacity(0.2) : const Color(0xFF3D3D4A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted ? color : Colors.white.withOpacity(0.2),
          width: isHighlighted ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              name,
              style: TextStyle(
                color: isHighlighted ? color : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: TextStyle(
                color: isHighlighted ? color : Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name.contains('Monthly') ? '/month' : '/year',
              style: TextStyle(
                color: isHighlighted ? color.withOpacity(0.8) : Colors.white70,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            ...features.map((feature) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Icon(
                    Icons.check,
                    color: isHighlighted ? color : Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            )),
            if (onUpgrade != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: isLoading ? null : onUpgrade,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: color.withOpacity(0.5),
                  ),
                  child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Upgrade Now'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Feature Comparison',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF3D3D4A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF4A4A6A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: const Row(
                  children: [
                    Expanded(flex: 2, child: Text('Feature', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Free', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                    Expanded(child: Text('Premium', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                  ],
                ),
              ),
              
              // Features
              ...[
                ['Number of Pets', '1', 'Unlimited'],
                ['Mini-Games', '6', '10+'],
                ['Daily Rewards', '1x', '2x'],
                ['Advertisements', 'Yes', 'No'],
                ['Cloud Sync', 'No', 'Yes'],
                ['Custom Themes', 'No', 'Yes'],
                ['Priority Support', 'No', 'Yes'],
                ['Early Access', 'No', 'Yes'],
              ].map((row) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Text(row[0], style: const TextStyle(color: Colors.white))),
                    Expanded(child: Text(row[1], style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center)),
                    Expanded(child: Text(row[2], style: const TextStyle(color: Colors.amber), textAlign: TextAlign.center)),
                  ],
                ),
              )).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _purchasePremiumMonthly(BuildContext context, AccountProvider accountProvider) async {
    setState(() {
      _isPaymentLoading = true;
      _paymentError = null;
    });

    try {
      final email = accountProvider.account?.email ?? 'user@example.com';
      final success = await _paymentService.processPayment(
        email: email,
        amount: _paymentService.getMonthlyPriceInCents(),
        currency: _paymentService.getCurrency(),
      );
      
      if (success) {
        await accountProvider.updateStats(isPremium: true);
        
        // Check if this was a demo payment
        final paymentDetails = await _paymentService.getLastPaymentDetails();
        final isDemo = paymentDetails?['source'] == 'demo';
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isDemo 
                ? '🎉 Demo payment successful! Welcome to Premium!'
                : '🎉 Payment successful! Welcome to Premium!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _paymentError = 'Payment error: $e';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isPaymentLoading = false;
      });
    }
  }

  Future<void> _purchasePremiumYearly(BuildContext context, AccountProvider accountProvider) async {
    setState(() {
      _isPaymentLoading = true;
      _paymentError = null;
    });

    try {
      final email = accountProvider.account?.email ?? 'user@example.com';
      final success = await _paymentService.processPayment(
        email: email,
        amount: _paymentService.getYearlyPriceInCents(),
        currency: _paymentService.getCurrency(),
      );
      
      if (success) {
        await accountProvider.updateStats(isPremium: true);
        
        // Check if this was a demo payment
        final paymentDetails = await _paymentService.getLastPaymentDetails();
        final isDemo = paymentDetails?['source'] == 'demo';
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isDemo 
                ? '🎉 Demo yearly payment successful! Welcome to Premium!'
                : '🎉 Yearly payment successful! Welcome to Premium!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _paymentError = 'Payment error: $e';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isPaymentLoading = false;
      });
    }
  }

  void _upgradeToPremiumDemo(BuildContext context, AccountProvider accountProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D3A),
        title: const Text('Demo Mode', style: TextStyle(color: Colors.white)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'This is a demo version. In production, this would process real credit card payments via Stripe (2.9% + \$0.30 fee).',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 16),
            Text(
              'Would you like to simulate a premium upgrade?',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              accountProvider.updateStats(isPremium: true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🎉 Demo: Premium activated!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            child: const Text('Simulate Upgrade', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
