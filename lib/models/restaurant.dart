import 'menu_item.dart';

class Restaurant {
  final String id;
  final String name;
  final String zone;
  final double rating;
  final String cuisine;
  final List<MenuItem> menu;

  Restaurant({
    required this.id,
    required this.name,
    required this.zone,
    required this.rating,
    required this.cuisine,
    required this.menu,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    var menuList = json['menu'] as List;
    List<MenuItem> menuItems = menuList.map((i) => MenuItem.fromJson(i)).toList();

    return Restaurant(
      id: json['id'],
      name: json['name'],
      zone: json['zone'],
      rating: json['rating'].toDouble(),
      cuisine: json['cuisine'],
      menu: menuItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'zone': zone,
      'rating': rating,
      'cuisine': cuisine,
      'menu': menu.map((item) => item.toJson()).toList(),
    };
  }
}