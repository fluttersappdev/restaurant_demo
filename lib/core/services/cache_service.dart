import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/restaurant.dart';

class CacheService {
  static const String _restaurantsKey = 'cached_restaurants';

  Future<void> cacheRestaurants(List<Restaurant> restaurants) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> restaurantMaps =
      restaurants.map((r) => r.toJson()).toList();
      await prefs.setString(_restaurantsKey, json.encode(restaurantMaps));
    } catch (e) {
      print('Error caching restaurants: $e');
    }
  }

  Future<List<Restaurant>> getCachedRestaurants() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? restaurantsJson = prefs.getString(_restaurantsKey);

      if (restaurantsJson != null) {
        final List<dynamic> restaurantMaps = json.decode(restaurantsJson);
        return restaurantMaps.map((r) => Restaurant.fromJson(r)).toList();
      }

      return [];
    } catch (e) {
      print('Error getting cached restaurants: $e');
      return [];
    }
  }

  Future<bool> hasCachedRestaurants() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_restaurantsKey);
    } catch (e) {
      print('Error checking cached restaurants: $e');
      return false;
    }
  }
}