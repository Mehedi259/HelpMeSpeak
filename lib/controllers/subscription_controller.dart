// lib/controllers/subscription_controller.dart

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'dart:io';
import 'dart:async';

import '../data/models/subscription_model.dart';
import '../data/services/subscription_service.dart';

class SubscriptionController extends GetxController {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  var isLoading = true.obs;
  var plans = <SubscriptionPlan>[].obs;
  var availableProducts = <ProductDetails>[].obs;
  var subscriptionStatus = Rx<SubscriptionStatus?>(null);
  var selectedPlanIndex = (-1).obs;
  var isPaidUser = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeIAP();
    loadPlans();
    checkSubscriptionStatus();
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }

  /// Initialize In-App Purchase
  void _initializeIAP() {
    // Listen to purchase updates
    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onDone: () => _subscription.cancel(),
      onError: (error) {
        print('❌ IAP Stream Error: $error');
        Get.snackbar('Error', 'Purchase stream error');
      },
    );
  }

  /// Load subscription plans from backend
  Future<void> loadPlans() async {
    try {
      isLoading.value = true;
      plans.value = await SubscriptionService.getPlans();

      // Get product IDs based on platform
      final productIds = plans.map((plan) {
        return Platform.isIOS ? plan.appleProductId : plan.googleProductId;
      }).toSet();

      // Fetch products from store
      final response = await _iap.queryProductDetails(productIds);

      if (response.notFoundIDs.isNotEmpty) {
        print('⚠️ Products not found: ${response.notFoundIDs}');
      }

      availableProducts.value = response.productDetails;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('❌ Error loading plans: $e');
      Get.snackbar('Error', 'Failed to load subscription plans');
    }
  }

  /// Check current subscription status
  Future<void> checkSubscriptionStatus() async {
    try {
      final status = await SubscriptionService.getSubscriptionStatus();
      subscriptionStatus.value = status;
      isPaidUser.value = status.isPaid;
    } catch (e) {
      print('❌ Error checking status: $e');
    }
  }

  /// Purchase a subscription
  Future<void> purchaseSubscription(SubscriptionPlan plan) async {
    try {
      // Find matching product
      final productId = Platform.isIOS ? plan.appleProductId : plan.googleProductId;
      final product = availableProducts.firstWhereOrNull(
            (p) => p.id == productId,
      );

      if (product == null) {
        Get.snackbar('Error', 'Product not available');
        return;
      }

      // Create purchase param
      final purchaseParam = PurchaseParam(productDetails: product);

      // Start purchase
      if (Platform.isIOS) {
        await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      print('❌ Purchase error: $e');
      Get.snackbar('Error', 'Purchase failed');
    }
  }

  /// Handle purchase updates from store
  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) {
        Get.snackbar('Processing', 'Your purchase is being processed...');
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        // Verify purchase with backend
        await _verifyPurchase(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        Get.snackbar('Error', 'Purchase failed: ${purchase.error?.message}');
      }

      // Complete purchase
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  /// Verify purchase with backend
  Future<void> _verifyPurchase(PurchaseDetails purchase) async {
    try {
      String receiptToken;
      String platform;

      if (Platform.isIOS) {
        platform = 'apple';
        // For iOS, get receipt from purchase
        final iosPurchase = purchase as AppStorePurchaseDetails;
        receiptToken = iosPurchase.verificationData.serverVerificationData;
      } else {
        platform = 'google';
        // For Android, get purchase token
        final androidPurchase = purchase as GooglePlayPurchaseDetails;
        receiptToken = androidPurchase.verificationData.serverVerificationData;
      }

      // Validate with backend
      final response = await SubscriptionService.validatePurchase(
        token: receiptToken,
        platform: platform,
        productId: purchase.productID,
      );

      Get.snackbar(
        'Success',
        response.message,
        duration: const Duration(seconds: 3),
      );

      // Refresh subscription status
      await checkSubscriptionStatus();

      // Navigate to home if purchase successful
      if (response.subscriptionStatus == 'active') {
        Get.offAllNamed('/home');
      }
    } catch (e) {
      print('❌ Verification error: $e');
      Get.snackbar('Error', 'Failed to verify purchase');
    }
  }

  /// Restore previous purchases
  Future<void> restorePurchases() async {
    try {
      Get.snackbar('Restoring', 'Checking for previous purchases...');
      await _iap.restorePurchases();
    } catch (e) {
      print('❌ Restore error: $e');
      Get.snackbar('Error', 'Failed to restore purchases');
    }
  }

  /// Cancel subscription
  Future<void> cancelSubscription() async {
    try {
      final message = await SubscriptionService.cancelSubscription();
      Get.snackbar('Success', message);
      await checkSubscriptionStatus();
    } catch (e) {
      print('❌ Cancel error: $e');
      Get.snackbar('Error', 'Failed to cancel subscription');
    }
  }

  /// Get product details for a plan
  ProductDetails? getProductForPlan(SubscriptionPlan plan) {
    final productId = Platform.isIOS ? plan.appleProductId : plan.googleProductId;
    return availableProducts.firstWhereOrNull((p) => p.id == productId);
  }

  /// Select plan by index
  void selectPlan(int index) {
    selectedPlanIndex.value = index;
  }
}