import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Service for handling in-app purchases (cosmetic items only)
/// This is a basic implementation with hooks for future expansion
class IAPService {
  static final InAppPurchase _iap = InAppPurchase.instance;
  static StreamSubscription<List<PurchaseDetails>>? _subscription;

  // Product IDs (these would be configured in Play Store/App Store)
  static const String sunlightSmall = 'sunlight_small';
  static const String sunlightMedium = 'sunlight_medium';
  static const String sunlightLarge = 'sunlight_large';
  static const String premiumPlanPack = 'premium_plant_pack';

  static final List<String> _productIds = [
    sunlightSmall,
    sunlightMedium,
    sunlightLarge,
    premiumPlanPack,
  ];

  /// Initialize IAP service
  static Future<void> initialize() async {
    final available = await _iap.isAvailable();
    if (!available) {
      return;
    }

    // Listen to purchase updates
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: _onPurchaseError,
    );
  }

  /// Get available products
  static Future<List<ProductDetails>> getProducts() async {
    final available = await _iap.isAvailable();
    if (!available) {
      return [];
    }

    final response = await _iap.queryProductDetails(_productIds.toSet());
    if (response.error != null) {
      return [];
    }

    return response.productDetails;
  }

  /// Purchase a product
  static Future<void> buyProduct(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyConsumable(purchaseParam: purchaseParam);
  }

  /// Handle purchase updates
  static void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        _handlePurchase(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        // Handle error
      }

      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }

  /// Handle completed purchase
  static void _handlePurchase(PurchaseDetails purchase) {
    // Award sunlight based on product
    int sunlightAmount = 0;

    switch (purchase.productID) {
      case sunlightSmall:
        sunlightAmount = 50;
        break;
      case sunlightMedium:
        sunlightAmount = 150;
        break;
      case sunlightLarge:
        sunlightAmount = 500;
        break;
      case premiumPlanPack:
        // Unlock premium plants
        // This would be handled by the provider
        break;
    }

    // The actual awarding would be handled by the app provider
    // This is just the IAP hook
  }

  /// Handle purchase errors
  static void _onPurchaseError(Object error) {
    // Log error or show user message
  }

  /// Restore purchases
  static Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  /// Dispose IAP service
  static Future<void> dispose() async {
    await _subscription?.cancel();
  }

  /// Get product info
  static Map<String, dynamic> getProductInfo(String productId) {
    switch (productId) {
      case sunlightSmall:
        return {
          'name': 'Small Sunlight Pack',
          'description': '50 Sunlight',
          'price': '\$0.99',
        };
      case sunlightMedium:
        return {
          'name': 'Medium Sunlight Pack',
          'description': '150 Sunlight (Best Value!)',
          'price': '\$2.99',
        };
      case sunlightLarge:
        return {
          'name': 'Large Sunlight Pack',
          'description': '500 Sunlight',
          'price': '\$7.99',
        };
      case premiumPlanPack:
        return {
          'name': 'Premium Plant Pack',
          'description': 'Unlock 5 exclusive plants',
          'price': '\$4.99',
        };
      default:
        return {};
    }
  }
}
