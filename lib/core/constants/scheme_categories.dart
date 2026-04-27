class SchemeCategories {
  static const String agriculture = 'agriculture';
  static const String health = 'health';
  static const String education = 'education';
  static const String housing = 'housing';
  static const String women = 'women';
  static const String womenChild = 'women_child';
  static const String employment = 'employment';
  static const String disability = 'disability';
  static const String senior = 'senior';

  static const Map<String, String> categoryNames = {
    agriculture: 'Agriculture',
    health: 'Health',
    education: 'Education',
    housing: 'Housing',
    womenChild: 'Women & Child',
    employment: 'Employment',
    disability: 'Disability',
    senior: 'Senior Citizen',
  };

  static const Map<String, String> categoryNamesHindi = {
    agriculture: 'कृषि',
    health: 'स्वास्थ्य',
    education: 'शिक्षा',
    housing: 'आवास',
    womenChild: 'महिला एवं बाल',
    employment: 'रोजगार',
    disability: 'दिव्यांग',
    senior: 'वरिष्ठ नागरिक',
  };

  static const Map<String, String> categoryNamesMarathi = {
    agriculture: 'शेती',
    health: 'आरोग्य',
    education: 'शिक्षण',
    housing: 'गृहनिर्माण',
    womenChild: 'महिला आणि बाल',
    employment: 'रोजगार',
    disability: 'दिव्यांगत्व',
    senior: 'ज्येष्ठ नागरिक',
  };

  /// Get localized category name
  static String getLocalizedCategoryName(String category, String langCode) {
    switch (langCode) {
      case 'hi':
        return categoryNamesHindi[category] ?? categoryNames[category] ?? category;
      case 'mr':
        return categoryNamesMarathi[category] ?? categoryNames[category] ?? category;
      default:
        return categoryNames[category] ?? category;
    }
  }
}
