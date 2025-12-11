import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../core/services/storage_service.dart';

class OrderProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<Order> _orderHistory = [];
  bool _isPlacingOrder = false;

  List<Order> get orderHistory => _orderHistory;
  bool get isPlacingOrder => _isPlacingOrder;

  Future<void> loadOrderHistory() async {
    // In a real app, you would load this from a backend
    // For this demo, we'll just use an empty list
    _orderHistory = [];
    notifyListeners();
  }

  Future<bool> placeOrder(Order order) async {
    _isPlacingOrder = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Add to order history
      _orderHistory.add(order);

      // Mark first order as completed if applicable
      if (order.promoCode == 'FIRST100') {
        await _storageService.markFirstOrderCompleted();
      }

      _isPlacingOrder = false;
      notifyListeners();

      return true;
    } catch (e) {
      _isPlacingOrder = false;
      notifyListeners();
      return false;
    }
  }
}