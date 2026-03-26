import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentService {
  static const String _premiumProductId = 'premium_monthly';
  static const String _premiumYearlyProductId = 'premium_yearly';
  
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  
  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  
  bool get isAvailable => _isAvailable;
  List<ProductDetails> get products => _products;
  List<PurchaseDetails> get purchases => _purchases;
  
  Future<void> initialize() async {
    // Check if billing is available
    _isAvailable = await _inAppPurchase.isAvailable();
    
    if (!_isAvailable) {
      print('In-app purchases not available on this device');
      return;
    }
    
    // Listen to purchase updates
    _subscription = _inAppPurchase.purchaseStream.listen(
      _listenToPurchaseUpdated,
      onDone: () => _subscription.cancel(),
      onError: (error) => print('Purchase stream error: $error'),
    );
    
    // Load available products
    await _loadProducts();
    
    // Restore previous purchases
    await _restorePurchases();
  }
  
  Future<void> _loadProducts() async {
    try {
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails({
        _premiumProductId,
        _premiumYearlyProductId,
      });
      
      if (response.notFoundIDs.isNotEmpty) {
        print('Products not found: ${response.notFoundIDs}');
      }
      
      _products = response.productDetails;
      print('Loaded ${_products.length} products');
    } catch (e) {
      print('Error loading products: $e');
    }
  }
  
  Future<void> _restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
      print('Purchases restored');
    } catch (e) {
      print('Error restoring purchases: $e');
    }
  }
  
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      _handlePurchase(purchaseDetails);
    }
  }
  
  void _handlePurchase(PurchaseDetails purchaseDetails) {
    if (purchaseDetails.pendingCompletePurchase) {
      _inAppPurchase.completePurchase(purchaseDetails);
    }
    
    // Update purchases list
    _purchases.add(purchaseDetails);
    print('Purchase handled: ${purchaseDetails.productID}');
  }
  
  Future<bool> purchasePremiumMonthly() async {
    try {
      final ProductDetails? product = getPremiumMonthlyProduct();
      if (product == null) {
        print('Premium monthly product not found');
        return false;
      }
      
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
      final bool success = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      return success;
    } catch (e) {
      print('Error purchasing premium monthly: $e');
      return false;
    }
  }
  
  Future<bool> purchasePremiumYearly() async {
    try {
      final ProductDetails? product = getPremiumYearlyProduct();
      if (product == null) {
        print('Premium yearly product not found');
        return false;
      }
      
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
      final bool success = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      return success;
    } catch (e) {
      print('Error purchasing premium yearly: $e');
      return false;
    }
  }
  
  Future<bool> isPremiumPurchased() async {
    // Check if user has any active premium purchase
    return _purchases.any((purchase) => 
      purchase.productID == _premiumProductId || 
      purchase.productID == _premiumYearlyProductId
    );
  }
  
  ProductDetails? getPremiumMonthlyProduct() {
    return _products.where((product) => product.id == _premiumProductId).firstOrNull;
  }
  
  ProductDetails? getPremiumYearlyProduct() {
    return _products.where((product) => product.id == _premiumYearlyProductId).firstOrNull;
  }
  
  void dispose() {
    _subscription.cancel();
  }
}
