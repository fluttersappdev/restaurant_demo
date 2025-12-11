import 'menu_item.dart';

class CartItem {
  final MenuItem menuItem;
  int quantity;
  String restaurantId;
  String restaurantName;
  String restaurantZone;

  CartItem({
    required this.menuItem,
    required this.quantity,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantZone,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      menuItem: MenuItem.fromJson(json['menuItem']),
      quantity: json['quantity'],
      restaurantId: json['restaurantId'],
      restaurantName: json['restaurantName'],
      restaurantZone: json['restaurantZone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuItem': menuItem.toJson(),
      'quantity': quantity,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'restaurantZone': restaurantZone,
    };
  }

  double get totalPrice => menuItem.price * quantity;
}
