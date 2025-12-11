import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/restaurant.dart';
import '../../core/utils/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../common/glass_morphism_card.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;

  const RestaurantCard({
    Key? key,
    required this.restaurant,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassMorphismCard(
      onTap: onTap,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Restaurant Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: AppTheme.primaryGradient,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/restaurant.svg',
                width: 40,
                height: 40,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Restaurant Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // Rating
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.rating.toString(),
                          style: Theme.of(context).textTheme.bodySmall,
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
                        restaurant.cuisine,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppTheme.lightTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${restaurant.zone} Zone',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const Spacer(),
                    Text(
                      '${restaurant.menu.length} items',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
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