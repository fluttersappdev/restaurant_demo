import 'package:flutter/foundation.dart';
import '../models/restaurant.dart';
import '../core/services/api_service.dart';
import '../core/services/cache_service.dart';

class RestaurantProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final CacheService _cacheService = CacheService();

  List<Restaurant> _restaurants = [];
  bool _isLoading = false;
  bool _hasError = false;
  bool _isUsingCachedData = false;

  List<Restaurant> get restaurants => _restaurants;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get isUsingCachedData => _isUsingCachedData;

  Future<void> fetchRestaurants({bool forceRefresh = false}) async {
    _isLoading = true;
    _hasError = false;
    _isUsingCachedData = false;
    notifyListeners();

    try {
      // Check if we have cached data and not forcing a refresh
      if (!forceRefresh && await _cacheService.hasCachedRestaurants()) {
        _restaurants = await _cacheService.getCachedRestaurants();
        _isUsingCachedData = true;
        _isLoading = false;
        notifyListeners();

        // Still try to fetch fresh data in the background
        _fetchFreshData();
        return;
      }

      // Fetch fresh data
      await _fetchFreshData();
    } catch (e) {
      _hasError = true;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchFreshData() async {
    try {
      _restaurants = await _apiService.getRestaurantsFromApi();
      await _cacheService.cacheRestaurants(_restaurants);
      _isUsingCachedData = false;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // If we already have cached data, keep using it
      if (_restaurants.isNotEmpty) {
        _isUsingCachedData = true;
      } else {
        _hasError = true;
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Restaurant? getRestaurantById(String id) {
    try {
      return _restaurants.firstWhere((restaurant) => restaurant.id == id);
    } catch (e) {
      return null;
    }
  }

  void sortRestaurantsByRating() {
    _restaurants.sort((a, b) => b.rating.compareTo(a.rating));
    notifyListeners();
  }

  void sortRestaurantsByName() {
    _restaurants.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }
}