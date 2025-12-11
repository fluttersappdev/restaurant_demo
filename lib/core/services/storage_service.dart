import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/cart_item.dart';

class StorageService {
  static const String _cartKey = 'cart_items';
  static const String _firstOrderKey = 'is_first_order';

  Future<void> saveCartItems(List<CartItem> cartItems) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> cartMaps =
      cartItems.map((item) => item.toJson()).toList();
      await prefs.setString(_cartKey, json.encode(cartMaps));
    } catch (e) {
      print('Error saving cart items: $e');
    }
  }

  Future<List<CartItem>> getCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cartJson = prefs.getString(_cartKey);

      if (cartJson != null) {
        final List<dynamic> cartMaps = json.decode(cartJson);
        return cartMaps.map((item) => CartItem.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      print('Error getting cart items: $e');
      return [];
    }
  }

  Future<bool> isFirstOrder() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_firstOrderKey) ?? true;
    } catch (e) {
      print('Error checking first order: $e');
      return true;
    }
  }

  Future<void> markFirstOrderCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_firstOrderKey, false);
    } catch (e) {
      print('Error marking first order completed: $e');
    }
  }
}