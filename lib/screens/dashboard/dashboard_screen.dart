// lib/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/navigation_provider.dart'; // <-- IMPORT THE PROVIDER
import '../../core/utils/app_theme.dart';
import '../restaurants/restaurants_list_screen.dart';
import '../search/search_screen.dart';
import '../cart/cart_screen.dart';
import '../profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // The list of screens remains the same
  final List<Widget> _screens = [
    const RestaurantsListScreen(),
    const SearchScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load cart items when dashboard initializes
    Provider.of<CartProvider>(context, listen: false).loadCartItems();
  }

  @override
  Widget build(BuildContext context) {
    // Use a Consumer to rebuild when the navigation index changes
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.backgroundGradient,
            ),
            // Use the index from the provider to display the correct screen
            child: _screens[navigationProvider.currentIndex],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              // Use the index from the provider
              currentIndex: navigationProvider.currentIndex,
              onTap: (index) {
                // When a tab is tapped, update the provider
                navigationProvider.setTabIndex(index);
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: AppTheme.primaryColor,
              unselectedItemColor: AppTheme.lightTextColor,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
              items: [
                // ... your BottomNavigationBarItem list remains the same
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  activeIcon: const Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.search_outlined),
                  activeIcon: const Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Consumer<CartProvider>(
                    builder: (context, cartProvider, _) {
                      return Stack(
                        children: [
                          const Icon(Icons.shopping_cart_outlined),
                          if (cartProvider.itemCount > 0)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  cartProvider.itemCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  activeIcon: Consumer<CartProvider>(
                    builder: (context, cartProvider, _) {
                      return Stack(
                        children: [
                          const Icon(Icons.shopping_cart),
                          if (cartProvider.itemCount > 0)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  cartProvider.itemCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outline),
                  activeIcon: const Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}