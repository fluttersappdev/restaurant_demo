// lib/app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_demo/providers/navigation_provider.dart';
import 'providers/restaurant_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'routes/app_routes.dart';
import 'core/utils/app_theme.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()), // <-- ADD THE PROVIDER HERE
      ],
      child: MaterialApp(
        title: 'QuickBite',
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.dashboard,
        routes: AppRoutes.routes,
      ),
    );
  }
}

