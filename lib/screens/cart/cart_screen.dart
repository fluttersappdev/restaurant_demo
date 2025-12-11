import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/glass_morphism_card.dart';
import '../../widgets/common/quantity_selector.dart';
import '../../widgets/common/custom_button.dart';
import '../../core/utils/app_theme.dart';
import '../../core/utils/helpers.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  final TextEditingController _promoCodeController = TextEditingController();
  bool _isPromoApplied = false;
  bool _isCheckoutButtonExpanded = false;
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _buttonAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _promoCodeController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add items from restaurants to get started',
                    style: Theme.of(context).textTheme.titleSmall,
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

          return Column(
            children: [
              // Header
              Container(
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
                child: Row(
                  children: [
                    Text(
                      'My Cart',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const Spacer(),
                    Text(
                      '${cartProvider.itemCount} items',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),

              // Cart Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartProvider.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartProvider.cartItems[index];
                    return GlassMorphismCard(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Restaurant Name
                          Text(
                            cartItem.restaurantName,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Menu Item
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Menu Item Details
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
                                      cartItem.menuItem.description,
                                      style: Theme.of(context).textTheme.titleSmall,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      Helpers.formatPrice(cartItem.menuItem.price),
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Quantity Selector
                              QuantitySelector(
                                quantity: cartItem.quantity,
                                onQuantityChanged: (quantity) {
                                  cartProvider.updateQuantity(cartItem.menuItem.id, quantity);
                                },
                                width: 100,
                              ),
                            ],
                          ),

                          // Remove Button
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                cartProvider.removeFromCart(cartItem.menuItem.id);
                                Helpers.showSnackBar(context, 'Item removed from cart');
                              },
                              child: Text(
                                'Remove',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppTheme.errorColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Promo Code Section
              GlassMorphismCard(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Promo Code',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _promoCodeController,
                            decoration: InputDecoration(
                              hintText: 'Enter promo code',
                              enabled: !cartProvider.promoCode.isNotEmpty,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (cartProvider.promoCode.isEmpty)
                          CustomButton(
                            text: 'Apply',
                            onPressed: () async {
                              final code = _promoCodeController.text.trim();
                              if (code.isEmpty) return;

                              final success = await cartProvider.applyPromoCode(code);
                              if (success) {
                                setState(() {
                                  _isPromoApplied = true;
                                });
                                Helpers.showSnackBar(
                                  context,
                                  'Promo code applied successfully',
                                  color: Colors.green,
                                );
                              } else {
                                Helpers.showSnackBar(
                                  context,
                                  'Invalid promo code or minimum order not met',
                                  color: AppTheme.errorColor,
                                );
                              }
                            },
                            width: 80,
                            height: 48,
                          )
                        else
                          CustomButton(
                            text: 'Remove',
                            onPressed: () {
                              cartProvider.removePromoCode();
                              setState(() {
                                _isPromoApplied = false;
                                _promoCodeController.clear();
                              });
                              Helpers.showSnackBar(context, 'Promo code removed');
                            },
                            width: 80,
                            height: 48,
                            isOutlined: true,
                          ),
                      ],
                    ),
                    if (_isPromoApplied) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Promo code applied: ${cartProvider.promoCode}',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Order Summary
              GlassMorphismCard(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryRow('Subtotal', Helpers.formatPrice(cartProvider.subtotal)),
                    _buildSummaryRow('Delivery Fee', Helpers.formatPrice(cartProvider.deliveryFee)),
                    if (cartProvider.discount > 0)
                      _buildSummaryRow(
                        'Discount',
                        '-${Helpers.formatPrice(cartProvider.discount)}',
                        textColor: Colors.green,
                      ),
                    const Divider(),
                    _buildSummaryRow(
                      'Total',
                      Helpers.formatPrice(cartProvider.total),
                      isBold: true,
                    ),
                  ],
                ),
              ),

              // Checkout Button
              Container(
                padding: const EdgeInsets.all(16),
                child: AnimatedBuilder(
                  animation: _buttonAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _buttonAnimation.value,
                      child: CustomButton(
                        text: 'Swipe to Checkout',
                        onPressed: () {
                          AppRoutes.pushNamed(
                            context,
                            AppRoutes.orderReview,
                          );
                        },
                        width: double.infinity,
                        height: 50,
                      ),
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
                : Theme.of(context).textTheme.titleSmall,
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