class SupportedLanguages {
  static const Map<String, String> languages = {
    'en': 'English',
    'hi': 'हिंदी',
    'mr': 'मराठी',
    'ta': 'தமிழ்',
    'te': 'తెలుగు',
    'kn': 'ಕನ್ನಡ',
    'bn': 'বাংলা',
    'gu': 'ગુજરાતી',
    'ml': 'മലയാളം',
    'or': 'ଓଡ଼ିଆ',
    'pa': 'ਪੰਜਾਬੀ',
  };

  /// Language names in native script for display
  static const Map<String, String> nativeNames = {
    'en': 'English',
    'hi': 'हिंदी',
    'mr': 'मराठी',
    'ta': 'தமிழ்',
    'te': 'తెలుగు',
    'kn': 'ಕನ್ನಡ',
    'bn': 'বাংলা',
    'gu': 'ગુજરાતી',
    'ml': 'മലയാളം',
    'or': 'ଓଡ଼ିଆ',
    'pa': 'ਪੰਜਾਬੀ',
  };

  /// TTS locale codes (for flutter_tts setLanguage)
  static const Map<String, String> ttsLocales = {
    'en': 'en-IN',
    'hi': 'hi-IN',
    'mr': 'mr-IN',
    'ta': 'ta-IN',
    'te': 'te-IN',
    'kn': 'kn-IN',
    'bn': 'bn-IN',
    'gu': 'gu-IN',
    'ml': 'ml-IN',
    'or': 'or-IN',
    'pa': 'pa-IN',
  };

  /// STT locale codes (for speech_to_text localeId)
  static const Map<String, String> sttLocales = {
    'en': 'en_IN',
    'hi': 'hi_IN',
    'mr': 'mr_IN',
    'ta': 'ta_IN',
    'te': 'te_IN',
    'kn': 'kn_IN',
    'bn': 'bn_IN',
    'gu': 'gu_IN',
    'ml': 'ml_IN',
    'or': 'or_IN',
    'pa': 'pa_IN',
  };

  /// Legacy — kept for backward compatibility
  static const Map<String, String> speechCodes = {
    'en': 'en-IN',
    'hi': 'hi-IN',
    'mr': 'mr-IN',
    'ta': 'ta-IN',
    'te': 'te-IN',
    'kn': 'kn-IN',
    'bn': 'bn-IN',
    'gu': 'gu-IN',
    'ml': 'ml-IN',
    'or': 'or-IN',
    'pa': 'pa-IN',
  };

  /// Example sentences for onboarding slide 2
  static const Map<String, String> onboardingExamples = {
    'en': 'I am a 45-year-old widow farmer with 2 acres of land...',
    'hi': 'मैं 45 साल की विधवा किसान हूं, मेरे पास 2 एकड़ ज़मीन है...',
    'mr': 'मी 45 वर्षांची विधवा शेतकरी आहे, माझ्याकडे 2 एकर जमीन आहे...',
    'ta': 'நான் 45 வயதான விதவை விவசாயி, என்னிடம் 2 ஏக்கர் நிலம் உள்ளது...',
    'te': 'నేను 45 సంవత్సరాల వితంతువు రైతు, నా దగ్గర 2 ఎకరాల భూమి ఉంది...',
    'kn': 'ನಾನು 45 ವರ್ಷದ ವಿಧವೆ ರೈತಳು, ನನ್ನ ಬಳಿ 2 ಎಕರೆ ಭೂಮಿ ಇದೆ...',
    'bn': 'আমি ৪৫ বছরের বিধবা কৃষক, আমার কাছে ২ একর জমি আছে...',
    'gu': 'હું 45 વર્ષની વિધવા ખેડૂત છું, મારી પાસે 2 એકર જમીન છે...',
    'ml': 'ഞാൻ 45 വയസ്സുള്ള വിധവ കർഷക, നന്റെ കൈയ്യിൽ 2 ഏക്കർ ഭൂമി...',
    'or': 'ମୁଁ 45 ବର୍ଷ ବୟସ ବିଧବା ଚାଷୀ, ମୋ ପାଖରେ 2 ଏକର ଜମି ଅଛି...',
    'pa': 'ਮੈਂ 45 ਸਾਲ ਦੀ ਵਿਧਵਾ ਕਿਸਾਨ, ਮੇਰੇ ਕੋਲ 2 ਏਕੜ ਜ਼ਮੀਨ ਹੈ...',
  };

  /// Gemini prompt language instruction
  static String geminiLanguageInstruction(String code) {
    final name = languages[code] ?? 'English';
    return 'Respond in $name language only. All explanations, reasons, and next steps must be written in $name. ';
  }
}
