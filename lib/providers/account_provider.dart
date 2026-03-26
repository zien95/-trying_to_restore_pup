import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/account.dart';
import '../services/stripe_payment_service.dart';

class AccountProvider extends ChangeNotifier {
  Account? _account;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  final StripePaymentService _paymentService = StripePaymentService();

  Account? get account => _account;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  AccountProvider() {
    _loadAccount();
  }

  Future<void> _loadAccount() async {
    _isLoading = true;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    final accountJson = prefs.getString('user_account');
    
    if (accountJson != null) {
      _account = Account.fromJson(json.decode(accountJson!));
      _isLoggedIn = true;
      
      // Sync premium status with payment service
      await _syncPremiumStatus();
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _syncPremiumStatus() async {
    try {
      final isPremiumFromPayment = await _paymentService.isPremiumPurchased();
      if (isPremiumFromPayment && _account != null && !_account!.isPremium) {
        // Update account if payment service shows premium but account doesn't
        _account!.isPremium = true;
        await _saveAccount();
      }
    } catch (e) {
      print('Error syncing premium status: $e');
    }
  }

  Future<void> login(String username, String email) async {
    _isLoading = true;
    notifyListeners();
    
    final newAccount = Account(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: username,
      email: email,
      createdAt: DateTime.now(),
    );
    
    _account = newAccount;
    _isLoggedIn = true;
    
    await _saveAccount();
    
    // Check if user has existing premium purchases
    await _syncPremiumStatus();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveAccount() async {
    if (_account == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_account', json.encode(_account!.toJson()));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_account');
    // Note: We don't remove premium purchase data as it's tied to the store
    
    _account = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> updateStats({
    int? totalPlayTime,
    int? achievementsUnlocked,
    int? coins,
    int? gems,
    bool? isPremium,
  }) async {
    if (_account == null) return;
    
    if (totalPlayTime != null) _account!.totalPlayTime += totalPlayTime;
    if (achievementsUnlocked != null) _account!.achievementsUnlocked += achievementsUnlocked;
    if (coins != null) _account!.coins += coins;
    if (gems != null) _account!.gems += gems;
    if (isPremium != null) _account!.isPremium = isPremium;
    
    await _saveAccount();
    notifyListeners();
  }

  Future<void> unlockFeature(String feature) async {
    if (_account == null) return;
    
    if (!_account!.unlockedFeatures.contains(feature)) {
      _account!.unlockedFeatures.add(feature);
      await _saveAccount();
      notifyListeners();
    }
  }

  // Payment related methods
  Future<bool> checkPremiumStatus() async {
    try {
      return await _paymentService.isPremiumPurchased();
    } catch (e) {
      print('Error checking premium status: $e');
      return _account?.isPremium ?? false;
    }
  }

  Future<String?> getPurchaseToken() async {
    try {
      return await _paymentService.getPremiumPurchaseToken();
    } catch (e) {
      print('Error getting purchase token: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getLastPaymentDetails() async {
    try {
      return await _paymentService.getLastPaymentDetails();
    } catch (e) {
      print('Error getting payment details: $e');
      return null;
    }
  }
}
