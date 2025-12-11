import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/delivery_fee_constants.dart';
import '../../constants/delivery_fee_constants.dart';
import '../../models/restaurant.dart';
import '../../providers/cart_provider.dart';
import '../../providers/restaurant_provider.dart';
import '../../widgets/restaurant/menu_item_card.dart';
import '../../core/utils/app_theme.dart';
import '../../core/utils/helpers.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  const RestaurantDetailsScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantDetailsScreen> createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  Restaurant? restaurant;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    // Get restaurant from arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        restaurant = ModalRoute.of(context)?.settings.arguments as Restaurant?;
      });
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (restaurant == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Restaurant Image
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.restaurant,
                        size: 64,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        restaurant!.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Restaurant Info
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Rating
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 20,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            restaurant!.rating.toString(),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),

                      // Cuisine Type
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          restaurant!.cuisine,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),

                      // Delivery Zone
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 20,
                            color: AppTheme.lightTextColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${restaurant!.zone} Zone',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Delivery Fee: ${Helpers.formatPrice(DeliveryFeeConstants.getDeliveryFee(restaurant!.zone))}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Menu',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),

          // Menu Items
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final menuItem = restaurant!.menu[index];
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: MenuItemCard(
                    menuItem: menuItem,
                    onAddToCart: () {
                      _showAddToCartAnimation(context);
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(menuItem, restaurant!);
                      Helpers.showSnackBar(context, '${menuItem.name} added to cart');
                    },
                  ),
                );
              },
              childCount: restaurant!.menu.length,
            ),
          ),

          // Bottom Padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  void _showAddToCartAnimation(BuildContext context) {
    _animationController.reset();
    _animationController.forward();
  }
}