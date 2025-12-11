import 'package:flutter/foundation.dart';
import '../constants/promo_codes.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';
import '../models/restaurant.dart';
import '../core/services/storage_service.dart';
import '../constants/delivery_fee_constants.dart';

class CartProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<CartItem> _cartItems = [];
  String _promoCode = '';
  double _discount = 0.0;

  List<CartItem> get cartItems => _cartItems;
  String get promoCode => _promoCode;
  double get discount => _discount;

  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get deliveryFee {
    if (_cartItems.isEmpty) return 0.0;
    // Use the delivery zone of the first restaurant in cart
    // In a real app, you might want to handle multiple restaurants differently
    final zone = _cartItems.first.restaurantZone;
    return DeliveryFeeConstants.getDeliveryFee(zone);
  }

  double get total => subtotal + deliveryFee - _discount;

  Future<void> loadCartItems() async {
    _cartItems = await _storageService.getCartItems();
    notifyListeners();
  }

  Future<void> saveCartItems() async {
    await _storageService.saveCartItems(_cartItems);
  }

  Future<void> addToCart(MenuItem menuItem, Restaurant restaurant) async {
    // Check if item from different restaurant is already in cart
    if (_cartItems.isNotEmpty && _cartItems.first.restaurantId != restaurant.id) {
      // In a real app, you might want to show a dialog asking to clear cart
      _cartItems.clear();
    }

    // Check if item already exists in cart
    final existingIndex = _cartItems.indexWhere(
            (item) => item.menuItem.id == menuItem.id
    );

    if (existingIndex != -1) {
      _cartItems[existingIndex].quantity++;
    } else {
      _cartItems.add(
        CartItem(
          menuItem: menuItem,
          quantity: 1,
          restaurantId: restaurant.id,
          restaurantName: restaurant.name,
          restaurantZone: restaurant.zone,
        ),
      );
    }

    await saveCartItems();
    notifyListeners();
  }

  Future<void> updateQuantity(String menuItemId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(menuItemId);
      return;
    }

    final index = _cartItems.indexWhere(
            (item) => item.menuItem.id == menuItemId
    );

    if (index != -1) {
      _cartItems[index].quantity = quantity;
      await saveCartItems();
      notifyListeners();
    }
  }

  Future<void> removeFromCart(String menuItemId) async {
    _cartItems.removeWhere((item) => item.menuItem.id == menuItemId);
    await saveCartItems();
    notifyListeners();
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    _promoCode = '';
    _discount = 0.0;
    await saveCartItems();
    notifyListeners();
  }

  Future<bool> applyPromoCode(String code) async {
    // Check if this is a first order promo
    final isFirstOrder = await _storageService.isFirstOrder();

    // Get promo details
    final promoDetails = PromoCodes.getPromoDetails(code);

    if (promoDetails == null) {
      return false; // Invalid promo code
    }

    // Check if it's a first order only promo and this isn't the first order
    if (promoDetails['isFirstOrderOnly'] == true && !isFirstOrder) {
      return false;
    }

    // Check minimum order value
    if (subtotal < promoDetails['minOrder']) {
      return false;
    }

    // Apply promo
    _promoCode = code;
    _discount = promoDetails['discount'].toDouble();
    notifyListeners();

    return true;
  }

  void removePromoCode() {
    _promoCode = '';
    _discount = 0.0;
    notifyListeners();
  }
}