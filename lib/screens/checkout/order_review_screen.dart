// lib/screens/checkout/order_review_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/glass_morphism_card.dart';
import '../../widgets/common/custom_button.dart';
import '../../core/utils/app_theme.dart';
import '../../core/utils/helpers.dart';

class OrderReviewScreen extends StatefulWidget {
  const OrderReviewScreen({Key? key}) : super(key: key);

  @override
  State<OrderReviewScreen> createState() => _OrderReviewScreenState();
}

class _OrderReviewScreenState extends State<OrderReviewScreen> {
  bool _isPlacingOrder = false;

  // 1. Create a private async function to handle the order placement logic
  Future<void> _handlePlaceOrder() async {
    // Set loading state to true
    if (!mounted) return;
    setState(() {
      _isPlacingOrder = true;
    });

    // Get providers
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    // Create the order object
    final order = Order.fromCartItems(
      cartProvider.cartItems,
      cartProvider.deliveryFee,
      discount: cartProvider.discount,
      promoCode: cartProvider.promoCode,
    );

    // Place the order
    final success = await orderProvider.placeOrder(order);

    // 2. Check if the widget is still in the tree before updating state
    if (!mounted) return;

    if (success) {
      // Clear the cart
      await cartProvider.clearCart();

      // Show success message
      Helpers.showSnackBar(
        context,
        'Order placed successfully!',
        color: Colors.green,
      );

      // Navigate back to the home screen
      Navigator.popUntil(
        context,
        ModalRoute.withName('/'),
      );
    } else {
      // Show error message
      Helpers.showSnackBar(
        context,
        'Failed to place order. Please try again.',
        color: AppTheme.errorColor,
      );
    }

    // Reset loading state
    if (!mounted) return;
    setState(() {
      _isPlacingOrder = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Review'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          if (cartProvider.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: AppTheme.lightTextColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Browse Restaurants',
                    onPressed: () {
                      Provider.of<NavigationProvider>(context, listen: false).setTabIndex(0);
                    },
                  ),
                ],
              ),
            );
          }

          // Create order object
          final order = Order.fromCartItems(
            cartProvider.cartItems,
            cartProvider.deliveryFee,
            discount: cartProvider.discount,
            promoCode: cartProvider.promoCode,
          );

          return Column(
            children: [
              // Order Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Restaurant Name
                    GlassMorphismCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Restaurant',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cartProvider.cartItems.first.restaurantName,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Order Items
                    GlassMorphismCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Items',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 12),
                          ...cartProvider.cartItems.map((cartItem) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Item Name and Quantity
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartItem.menuItem.name,
                                          style: Theme.of(context).textTheme.titleSmall,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Quantity: ${cartItem.quantity}',
                                          style: Theme.of(context).textTheme.titleSmall,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Item Price
                                  Text(
                                    Helpers.formatPrice(cartItem.totalPrice),
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Delivery Address
                    GlassMorphismCard(
                      padding: const EdgeInsets.all(16),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Zone',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: AppTheme.primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${cartProvider.cartItems.first.restaurantZone} Zone',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Promo Code
                    if (cartProvider.promoCode.isNotEmpty)
                      GlassMorphismCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.local_offer_outlined,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Promo Code: ${cartProvider.promoCode}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                            Text(
                              '-${Helpers.formatPrice(cartProvider.discount)}',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Order Summary
                    GlassMorphismCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Summary',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow('Subtotal', Helpers.formatPrice(order.subtotal)),
                          _buildSummaryRow('Delivery Fee', Helpers.formatPrice(order.deliveryFee)),
                          if (order.discount > 0)
                            _buildSummaryRow(
                              'Discount',
                              '-${Helpers.formatPrice(order.discount)}',
                              textColor: Colors.green,
                            ),
                          const Divider(),
                          _buildSummaryRow(
                            'Total',
                            Helpers.formatPrice(order.total),
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Place Order Button
              Container(
                padding: const EdgeInsets.all(16),
                child: Consumer<OrderProvider>(
                  builder: (context, orderProvider, _) {
                    return CustomButton(
                      text: 'Place Order',
                      // 3. Use the new handler function here
                      onPressed: (_isPlacingOrder || orderProvider.isPlacingOrder)
                          ? null
                          : () => _handlePlaceOrder(),
                      isLoading: _isPlacingOrder || orderProvider.isPlacingOrder,
                      width: double.infinity,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold
                ? Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)
                : Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            value,
            style: isBold
                ? Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor ?? AppTheme.darkTextColor,
            )
                : Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor ?? AppTheme.darkTextColor,
            ),
          ),
        ],
      ),
    );
  }
}