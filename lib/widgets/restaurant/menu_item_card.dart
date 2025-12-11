import 'package:flutter/material.dart';
import '../../models/menu_item.dart';
import '../../core/utils/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../common/glass_morphism_card.dart';
import '../common/custom_button.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem menuItem;
  final VoidCallback onAddToCart;

  const MenuItemCard({
    Key? key,
    required this.menuItem,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassMorphismCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: AppTheme.primaryGradient,
            ),
            child: const Icon(
              Icons.restaurant_menu,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),

          // Menu Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menuItem.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  menuItem.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Helpers.formatPrice(menuItem.price),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    CustomButton(
                      text: 'Add',
                      onPressed: onAddToCart,
                      width: 80,
                      height: 36,
                      borderRadius: 8,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}