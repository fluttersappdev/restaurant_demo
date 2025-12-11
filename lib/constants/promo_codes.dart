class PromoCodes {
  static const Map<String, Map<String, dynamic>> promoCodeMap = {
    'SAVE50': {
      'discount': 50,
      'minOrder': 700,
      'description': 'Get ₹50 off on orders above ₹700',
    },
    'FIRST100': {
      'discount': 100,
      'minOrder': 200,
      'description': 'Get ₹100 off on your first order above ₹200',
      'isFirstOrderOnly': true,
    },
  };

  static Map<String, dynamic>? getPromoDetails(String code) {
    return promoCodeMap[code.toUpperCase()];
  }
}