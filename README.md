QuickBite Customer App
A Flutter customer app for QuickBite restaurant ordering.

Features
Browse restaurants with filtering and sorting options
View restaurant details and menu items
Add items to cart with quantity management
Apply promo codes for discounts
Review order before placing
Offline support with cached data
Modern UI with glassmorphism effects and animations
Architecture
State Management
The app uses the Provider pattern for state management. Provider was chosen because:

It's simple to implement and understand
It provides good separation between UI and business logic
It's well-maintained and widely adopted in the Flutter community
It's less boilerplate compared to BLoC while still providing good structure
Folder Structure
lib/
├── main.dart
├── app.dart
├── constants/
│ ├── app_constants.dart
│ ├── delivery_fee_constants.dart
│ └── promo_codes.dart
├── core/
│ ├── services/
│ │ ├── api_service.dart
│ │ ├── cache_service.dart
│ │ └── storage_service.dart
│ └── utils/
│ ├── app_theme.dart
│ └── helpers.dart
├── models/
│ ├── restaurant.dart
│ ├── menu_item.dart
│ ├── cart_item.dart
│ └── order.dart
├── providers/
│ ├── restaurant_provider.dart
│ ├── cart_provider.dart
│ └── order_provider.dart
├── screens/
│ ├── dashboard/
│ │ └── dashboard_screen.dart
│ ├── restaurants/
│ │ ├── restaurants_list_screen.dart
│ │ └── restaurant_details_screen.dart
│ ├── cart/
│ │ └── cart_screen.dart
│ ├── checkout/
│ │ └── order_review_screen.dart
│ ├── search/
│ │ └── search_screen.dart
│ └── profile/
│ └── profile_screen.dart
├── widgets/
│ ├── common/
│ │ ├── glass_morphism_card.dart
│ │ ├── custom_button.dart
│ │ ├── quantity_selector.dart
│ │ └── loading_widget.dart
│ └── restaurant/
│ ├── restaurant_card.dart
│ └── menu_item_card.dart
└── routes/
└── app_routes.dart




### Caching

The app implements caching using SharedPreferences:

- Restaurant data is cached after fetching from API
- Cart items are persisted to survive app restarts
- First order status is tracked for promo code validation

### Delivery Fee Calculation

Delivery fees are calculated based on the restaurant's zone:

- Urban: ₹20
- Suburban: ₹30
- Remote: ₹50

The fee is determined by the `DeliveryFeeConstants.getDeliveryFee()` method which maps the zone string to the corresponding fee.

## Getting Started

### Prerequisites

- Flutter SDK (>=2.18.0)
- Dart SDK

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/fluttersappdev/restaurant_demo
   cd restaurant_demo