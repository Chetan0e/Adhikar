// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get appName => 'ਅਧਿਕਾਰ';

  @override
  String get tagline => 'ਤੁਹਾਡਾ ਹੱਕ। ਤੁਹਾਡੇ ਦਰ ਤੇ।';

  @override
  String get builtForBharat => 'ਭਾਰਤ ਲਈ 🇮🇳';

  @override
  String get poweredByAI => 'ਭਾਰਤ ਲਈ AI ਦੁਆਰਾ ਸੰਚਾਲਿਤ';

  @override
  String get selectLanguage => 'ਭਾਸ਼ਾ ਚੁਣੋ';

  @override
  String get chooseLanguage => 'ਆਪਣੀ ਭਾਸ਼ਾ ਚੁਣੋ';

  @override
  String get continueButton => 'ਅੱਗੇ ਵਧੋ';

  @override
  String get continueWithEnglish => 'ਅੰਗਰੇਜ਼ੀ ਵਿੱਚ ਜਾਰੀ';

  @override
  String get changeLanguage => 'ਭਾਸ਼ਾ ਬਦਲੋ';

  @override
  String languageChanged(String language) {
    return 'ਭਾਸ਼ਾ $language ਵਿੱਚ ਬਦਲੀ';
  }

  @override
  String get voiceInputTitle => 'ਆਪਣੀ ਸਥਿਤੀ ਦੱਸੋ';

  @override
  String get voiceInputSubtitle => 'ਆਪਣੇ ਬਾਰੇ, ਪਰਿਵਾਰ, ਆਮਦਨ, ਕੰਮ ਬਾਰੇ ਬੋਲੋ';

  @override
  String get transcriptLabel => 'ਤੁਹਾਡੀ ਗੱਲ';

  @override
  String get typeInstead => 'ਟਾਈਪ ਕਰੋ';

  @override
  String get transcriptHint => 'ਤੁਹਾਡੀ ਗੱਲ ਇੱਥੇ...';

  @override
  String get pleaseSpeak => 'ਕਿਰਪਾ ਕਰਕੇ ਬੋਲੋ';

  @override
  String get listening => 'ਸੁਣ ਰਹੇ ਹਾਂ...';

  @override
  String get tapToSpeakAgain => 'ਦੁਬਾਰਾ ਬੋਲੋ';

  @override
  String get enterYourInfo => 'ਜਾਣਕਾਰੀ ਦਿਓ';

  @override
  String get describeHint => 'ਸਥਿਤੀ ਦੱਸੋ...';

  @override
  String get cancel => 'ਰੱਦ';

  @override
  String get save => 'ਸੁਰੱਖਿਅਤ';

  @override
  String listeningIn(String language) {
    return 'ਸੁਣ ਰਹੇ: $language';
  }

  @override
  String get speakPrompt => 'ਆਪਣੀ ਸਥਿਤੀ ਦੱਸੋ';

  @override
  String get analyzingVoice => 'ਸਮਝ ਰਹੇ ਹਾਂ...';

  @override
  String get matchingSchemes => 'ਯੋਜਨਾਵਾਂ ਲੱਭ ਰਹੇ...';

  @override
  String get generatingForm => 'ਅਰਜ਼ੀ ਤਿਆਰ...';

  @override
  String schemesFound(int count) {
    return '$count ਯੋਜਨਾਵਾਂ';
  }

  @override
  String totalBenefit(String amount) {
    return '₹$amount / ਸਾਲ';
  }

  @override
  String get totalEstimatedBenefits => 'ਕੁੱਲ ਲਾਭ';

  @override
  String get eligibleSchemes => 'ਯੋਗ ਯੋਜਨਾਵਾਂ';

  @override
  String get noSchemesFound => 'ਕੋਈ ਯੋਜਨਾ ਨਹੀਂ';

  @override
  String get tryUpdatingProfile => 'ਪ੍ਰੋਫਾਈਲ ਅਪਡੇਟ ਕਰੋ';

  @override
  String get applyNow => 'ਹੁਣ ਅਰਜ਼ੀ';

  @override
  String get back => 'ਵਾਪਸ';

  @override
  String get schemeDetails => 'ਯੋਜਨਾ ਵੇਰਵਾ';

  @override
  String get eligibilityScore => 'ਸਕੋਰ';

  @override
  String get whyEligible => 'ਕਾਰਨ:';

  @override
  String get description => 'ਵੇਰਵਾ';

  @override
  String get requiredDocuments => 'ਦਸਤਾਵੇਜ਼';

  @override
  String get applicationInfo => 'ਅਰਜ਼ੀ';

  @override
  String get ministry => 'ਮੰਤਰਾਲਾ';

  @override
  String get applyAt => 'ਕਿੱਥੇ';

  @override
  String get visitOfficialWebsite => 'ਵੈੱਬਸਾਈਟ';

  @override
  String get documentsNeeded => 'ਲੋੜੀਂਦੇ ਦਸਤਾਵੇਜ਼';

  @override
  String get iHaveAllDocuments => 'ਦਸਤਾਵੇਜ਼ ਹਨ → ਅਰਜ਼ੀ';

  @override
  String get missingDocuments => 'ਦਸਤਾਵੇਜ਼ ਨਹੀਂ → ਸੁਰੱਖਿਅਤ';

  @override
  String get howToGet => 'ਕਿਵੇਂ';

  @override
  String get findNearestOffice => 'ਨਜ਼ਦੀਕੀ ਦਫ਼ਤਰ';

  @override
  String get shareScheme => 'ਸ਼ੇਅਰ';

  @override
  String shareText(
      String name, String benefit, String eligibility, String url) {
    return '$name\nਲਾਭ: $benefit\nਯੋਗਤਾ: $eligibility\nਅਰਜ਼ੀ: $url\n\nAdhikar app';
  }

  @override
  String get applicationHistory => 'ਇਤਿਹਾਸ';

  @override
  String get noApplications => 'ਕੋਈ ਅਰਜ਼ੀ ਨਹੀਂ!';

  @override
  String get statusSubmitted => 'ਜਮ੍ਹਾ';

  @override
  String get statusUnderReview => 'ਸਮੀਖਿਆ';

  @override
  String get statusApproved => 'ਮਨਜ਼ੂਰ';

  @override
  String get statusRejected => 'ਰੱਦ';

  @override
  String submittedDate(String date) {
    return 'ਜਮ੍ਹਾ: $date';
  }

  @override
  String referenceNumber(String number) {
    return 'Ref: $number';
  }

  @override
  String get offlineMessage => 'ਇੰਟਰਨੈੱਟ ਨਹੀਂ।';

  @override
  String get settings => 'ਸੈਟਿੰਗਾਂ';

  @override
  String get language => 'ਭਾਸ਼ਾ';

  @override
  String get currentLanguage => 'ਮੌਜੂਦਾ';

  @override
  String get voiceAndSound => 'ਅਵਾਜ਼';

  @override
  String get enableTTS => 'TTS';

  @override
  String get autoPlayResults => 'ਆਟੋ';

  @override
  String get speechSpeed => 'ਗਤੀ';

  @override
  String get slow => 'ਹੌਲੀ';

  @override
  String get normal => 'ਆਮ';

  @override
  String get fast => 'ਤੇਜ਼';

  @override
  String get notifications => 'ਸੂਚਨਾਵਾਂ';

  @override
  String get statusAlerts => 'ਸਥਿਤੀ';

  @override
  String get documentReminders => 'ਦਸਤਾਵੇਜ਼';

  @override
  String get newSchemeAlerts => 'ਨਵੀਂ';

  @override
  String get accessibility => 'ਪਹੁੰਚ';

  @override
  String get largeText => 'ਵੱਡਾ ਟੈਕਸਟ';

  @override
  String get highContrast => 'ਕੰਟ੍ਰਾਸਟ';

  @override
  String get dataPrivacy => 'ਗੋਪਨੀਯਤਾ';

  @override
  String get exportData => 'ਡੇਟਾ';

  @override
  String get deleteAccount => 'ਖਾਤਾ ਮਿਟਾਓ';

  @override
  String get deleteConfirmTitle => 'ਮਿਟਾਓ?';

  @override
  String get deleteConfirmBody => 'ਸਾਰਾ ਡੇਟਾ ਜਾਵੇਗਾ।';

  @override
  String get confirm => 'ਹਾਂ';

  @override
  String get about => 'ਬਾਰੇ';

  @override
  String get appVersion => 'ਵਰਜ਼ਨ';

  @override
  String get contactSupport => 'ਸੰਪਰਕ';

  @override
  String get onboarding1Title => 'Adhikar ਵਿੱਚ ਸੁਆਗਤ';

  @override
  String get onboarding1Body => 'ਤੁਹਾਡੀ ਭਾਸ਼ਾ ਵਿੱਚ ਸਰਕਾਰੀ ਯੋਜਨਾਵਾਂ।';

  @override
  String get onboarding2Title => 'ਬੋਲੋ';

  @override
  String get onboarding2Body => 'ਮਾਈਕ ਦਬਾਓ ਤੇ ਉਮਰ, ਕੰਮ, ਪਰਿਵਾਰ, ਆਮਦਨ ਦੱਸੋ।';

  @override
  String get onboarding2Example =>
      'ਮੈਂ 45 ਸਾਲ ਦੀ ਵਿਧਵਾ ਕਿਸਾਨ, ਮੇਰੇ ਕੋਲ 2 ਏਕੜ ਜ਼ਮੀਨ ਹੈ...';

  @override
  String get onboarding3Title => 'ਅਧਿਕਾਰ';

  @override
  String get onboarding3Body => '200+ ਯੋਜਨਾਵਾਂ।';

  @override
  String get onboarding4Title => 'ਅਰਜ਼ੀ';

  @override
  String get onboarding4Body => 'ਫਾਰਮ ਭਰਿਆ ਜਾਂਦਾ। ਦਫ਼ਤਰ ਲੱਭੋ।';

  @override
  String get getStarted => 'ਸ਼ੁਰੂ';

  @override
  String get skipOnboarding => 'ਛੱਡੋ';

  @override
  String get next => 'ਅੱਗੇ';

  @override
  String get networkError => 'ਇੰਟਰਨੈੱਟ ਨਹੀਂ।';

  @override
  String get geminiError => 'AI ਨਹੀਂ।';

  @override
  String get firebaseError => 'ਸਿੰਕ ਫੇਲ।';

  @override
  String get categoryAll => 'ਸਾਰੇ';

  @override
  String get categoryAgriculture => 'ਖੇਤੀ';

  @override
  String get categoryHealth => 'ਸਿਹਤ';

  @override
  String get categoryEducation => 'ਸਿੱਖਿਆ';

  @override
  String get categoryHousing => 'ਘਰ';

  @override
  String get categoryWomen => 'ਔਰਤਾਂ';

  @override
  String get categoryEmployment => 'ਰੁਜ਼ਗਾਰ';

  @override
  String get categoryDisability => 'ਅਪਾਹਜਤਾ';

  @override
  String get categorySenior => 'ਬਜ਼ੁਰਗ';

  @override
  String get profileTitle => 'ਪ੍ਰੋਫਾਈਲ';

  @override
  String get editProfile => 'ਸੰਪਾਦਨ';

  @override
  String get name => 'ਨਾਮ';

  @override
  String get age => 'ਉਮਰ';

  @override
  String get gender => 'ਲਿੰਗ';

  @override
  String get caste => 'ਜਾਤੀ';

  @override
  String get occupation => 'ਕੰਮ';

  @override
  String get income => 'ਆਮਦਨ';

  @override
  String get state => 'ਰਾਜ';

  @override
  String get district => 'ਜ਼ਿਲ੍ਹਾ';

  @override
  String get landOwned => 'ਜ਼ਮੀਨ';

  @override
  String get familySize => 'ਪਰਿਵਾਰ';

  @override
  String get maritalStatus => 'ਵਿਆਹੁਤਾ';

  @override
  String get disability => 'ਅਪਾਹਜਤਾ';

  @override
  String get helpButton => 'ਮਦਦ?';

  @override
  String get pullToRefresh => 'ਰਿਫ਼ਰੈਸ਼';
}
