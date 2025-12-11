// lib/providers/navigation_provider.dart
import 'package:flutter/foundation.dart';

class NavigationProvider with ChangeNotifier {
  int _currentIndex = 0; // Default to the first tab (Home)

  int get currentIndex => _currentIndex;

  void setTabIndex(int index) {
    // Only update and notify listeners if the index actually changes
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}