class DeliveryFeeConstants {
  static const Map<String, double> zoneFeeMap = {
    'Urban': 20.0,
    'Suburban': 30.0,
    'Remote': 50.0,
  };

  static double getDeliveryFee(String zone) {
    return zoneFeeMap[zone] ?? 50.0; // Default to 50 if zone not found
  }
}