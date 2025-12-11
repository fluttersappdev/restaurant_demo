import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/restaurant_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/restaurant/restaurant_card.dart';
import '../../core/utils/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _recentSearches = ['Pizza', 'Burger', 'Chinese', 'Italian'];
  List<String> _popularSearches = ['Fast Food', 'Italian', 'Chinese', 'Indian', 'Mexican'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search restaurants or cuisines...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.clear),
                )
                    : null,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // Search Results
          Expanded(
            child: _searchController.text.isNotEmpty
                ? Consumer<RestaurantProvider>(
              builder: (context, restaurantProvider, _) {
                final query = _searchController.text.toLowerCase();
                final filteredRestaurants = restaurantProvider.restaurants.where((restaurant) {
                  return restaurant.name.toLowerCase().contains(query) ||
                      restaurant.cuisine.toLowerCase().contains(query);
                }).toList();

                if (filteredRestaurants.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppTheme.lightTextColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No restaurants found',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try searching for something else',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: filteredRestaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = filteredRestaurants[index];
                    return RestaurantCard(
                      restaurant: restaurant,
                      onTap: () {
                        AppRoutes.pushNamed(
                          context,
                          AppRoutes.restaurantDetails,
                          arguments: restaurant,
                        );
                      },
                    );
                  },
                );
              },
            )
                : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recent Searches
                  if (_recentSearches.isNotEmpty) ...[
                    Text(
                      'Recent Searches',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _recentSearches.map((search) {
                        return _buildSearchChip(search);
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Popular Searches
                  Text(
                    'Popular Searches',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _popularSearches.map((search) {
                      return _buildSearchChip(search);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchChip(String search) {
    return ActionChip(
      label: Text(search),
      onPressed: () {
        _searchController.text = search;
        setState(() {});
      },
      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
      labelStyle: TextStyle(
        color: AppTheme.primaryColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}