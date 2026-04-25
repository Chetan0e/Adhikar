class ApiEndpoints {
  // Gemini API
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const String geminiModel = 'gemini-1.5-flash';
  
  // Backend API (FastAPI) - Replace with actual backend URL
  static const String backendBaseUrl = 'https://api.adhikar.gov.in';
  
  static const String schemes = '/schemes';
  static const String schemeMatch = '/schemes/match';
  static const String profiles = '/profiles';
  static const String applications = '/applications';
  static const String applicationStatus = '/applications';
  static const String districts = '/districts';
  static const String offices = '/offices';
}
