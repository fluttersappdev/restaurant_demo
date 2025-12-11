// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/restaurants/restaurants_list_screen.dart';
import '../screens/restaurants/restaurant_details_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/checkout/order_review_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRoutes {
  static const String dashboard = '/';
  static const String restaurantsList = '/restaurants';
  static const String restaurantDetails = '/restaurant-details';
  static const String cart = '/cart';
  static const String orderReview = '/order-review';
  static const String search = '/search';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes {
    return {
      dashboard: (context) => const DashboardScreen(),
      restaurantsList: (context) => const RestaurantsListScreen(),
      restaurantDetails: (context) => const RestaurantDetailsScreen(),
      cart: (context) => const CartScreen(),
      orderReview: (context) => const OrderReviewScreen(),
      search: (context) => const SearchScreen(),
      profile: (context) => const ProfileScreen(),
    };
  }

  static Future<T?> pushNamed<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.of(context).pushNamed<T>(routeName, arguments: arguments);
  }

  static Future<T?> pushReplacementNamed<T, TO>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.of(context).pushReplacementNamed<T, TO>(routeName, arguments: arguments);
  }

  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop<T>(result);
  }
}