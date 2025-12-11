import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/restaurant_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/restaurant/restaurant_card.dart';
import '../../widgets/common/loading_widget.dart';
import '../../core/utils/app_theme.dart';
import '../../core/utils/helpers.dart';

class RestaurantsListScreen extends StatefulWidget {
  const RestaurantsListScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantsListScreen> createState() => _RestaurantsListScreenState();
}

class _RestaurantsListScreenState extends State<RestaurantsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<String> _sortOptions = ['Rating', 'Name'];
  String _selectedSortOption = 'Rating';

  @override
  void initState() {
    super.initState();
    // Fetch restaurants when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RestaurantProvider>(context, listen: false).fetchRestaurants();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<RestaurantProvider>(
        builder: (context, restaurantProvider, _) {
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
                child: Column(
                  children: [
                    // App Title
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/logo.svg',
                          width: 32,
                          height: 32,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'QuickBite',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isSearching = !_isSearching;
                              if (!_isSearching) {
                                _searchController.clear();
                              }
                            });
                          },
                          icon: Icon(
                            _isSearching ? Icons.close : Icons.search,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),

                    // Search Bar
                    if (_isSearching) ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search restaurants...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                            },
                            icon: const Icon(Icons.clear),
                          )
                              : null,
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ],

                    // Sort Options
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Sort by:',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedSortOption,
                                isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                style: Theme.of(context).textTheme.bodySmall,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedSortOption = newValue!;
                                    if (_selectedSortOption == 'Rating') {
                                      restaurantProvider.sortRestaurantsByRating();
                                    } else if (_selectedSortOption == 'Name') {
                                      restaurantProvider.sortRestaurantsByName();
                                    }
                                  });
                                },
                                items: _sortOptions.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Restaurant List
              Expanded(
                child: restaurantProvider.isLoading
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : restaurantProvider.hasError
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppTheme.errorColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load restaurants',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please check your connection and try again',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          restaurantProvider.fetchRestaurants(forceRefresh: true);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
                    : restaurantProvider.restaurants.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.restaurant_outlined,
                        size: 64,
                        color: AppTheme.lightTextColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No restaurants found',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                )
                    : RefreshIndicator(
                  onRefresh: () async {
                    await restaurantProvider.fetchRestaurants(forceRefresh: true);
                  },
                  child: restaurantProvider.isUsingCachedData
                      ? Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(top: 8),
                        color: Colors.amber.withOpacity(0.1),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.warning_amber_outlined,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Showing offline data. Pull to refresh.',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: Colors.amber[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: _buildRestaurantList(restaurantProvider)),
                    ],
                  )
                      : _buildRestaurantList(restaurantProvider),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRestaurantList(RestaurantProvider restaurantProvider) {
    // Filter restaurants based on search query
    List filteredRestaurants = restaurantProvider.restaurants.where((restaurant) {
      if (_searchController.text.isEmpty) return true;
      return restaurant.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          restaurant.cuisine.toLowerCase().contains(_searchController.text.toLowerCase());
    }).toList();

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
  }
}