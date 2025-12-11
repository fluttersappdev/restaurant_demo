import 'cart_item.dart';

class Order {
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final String promoCode;
  final DateTime orderDate;

  Order({
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    this.discount = 0.0,
    this.total = 0.0,
    this.promoCode = '',
    DateTime? orderDate,
  }) : orderDate = orderDate ?? DateTime.now();

  factory Order.fromCartItems(
      List<CartItem> items,
      double deliveryFee, {
        double discount = 0.0,
        String promoCode = '',
      }) {
    final subtotal = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final total = subtotal + deliveryFee - discount;

    return Order(
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      discount: discount,
      total: total,
      promoCode: promoCode,
    );
  }
}