// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get appName => 'ಅಧಿಕಾರ್';

  @override
  String get tagline => 'ನಿಮ್ಮ ಹಕ್ಕು. ನಿಮ್ಮ ಬಾಗಿಲಿಗೆ.';

  @override
  String get builtForBharat => 'ಭಾರತಕ್ಕಾಗಿ ನಿರ್ಮಿಸಲಾಗಿದೆ 🇮🇳';

  @override
  String get poweredByAI => 'Powered by AI for Bharat';

  @override
  String get selectLanguage => 'ಭಾಷೆ ಆಯ್ಕೆ ಮಾಡಿ';

  @override
  String get chooseLanguage => 'ನಿಮ್ಮ ಭಾಷೆ ಆಯ್ಕೆ ಮಾಡಿ';

  @override
  String get continueButton => 'ಮುಂದುವರಿಯಿರಿ';

  @override
  String get continueWithEnglish => 'ಇಂಗ್ಲಿಷ್‌ನಲ್ಲಿ ಮುಂದುವರಿಯಿರಿ';

  @override
  String get changeLanguage => 'ಭಾಷೆ ಬದಲಾಯಿಸಿ';

  @override
  String languageChanged(String language) {
    return 'ಭಾಷೆ $language ಗೆ ಬದಲಾಯಿಸಲಾಗಿದೆ';
  }

  @override
  String get voiceInputTitle => 'ನಿಮ್ಮ ಪರಿಸ್ಥಿತಿ ಹೇಳಿ';

  @override
  String get voiceInputSubtitle =>
      'ನಿಮ್ಮ ಬಗ್ಗೆ, ಕುಟುಂಬ, ಆದಾಯ, ಉದ್ಯೋಗ ಬಗ್ಗೆ ಮಾತನಾಡಿ';

  @override
  String get transcriptLabel => 'ನಿಮ್ಮ ಮಾತು';

  @override
  String get typeInstead => 'ಮಾತನಾಡುವ ಬದಲು ಟೈಪ್ ಮಾಡಿ';

  @override
  String get transcriptHint => 'ನಿಮ್ಮ ಮಾತು ಇಲ್ಲಿ ಕಾಣಿಸುತ್ತದೆ...';

  @override
  String get pleaseSpeak => 'ದಯವಿಟ್ಟು ಮಾತನಾಡಿ ಅಥವಾ ಟೈಪ್ ಮಾಡಿ';

  @override
  String get listening => 'ಕೇಳುತ್ತಿದ್ದೇವೆ...';

  @override
  String get tapToSpeakAgain => 'ಮತ್ತೆ ಮಾತನಾಡಲು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get enterYourInfo => 'ನಿಮ್ಮ ಮಾಹಿತಿ ನಮೂದಿಸಿ';

  @override
  String get describeHint => 'ನಿಮ್ಮ ಪರಿಸ್ಥಿತಿ ವಿವರಿಸಿ...';

  @override
  String get cancel => 'ರದ್ದುಮಾಡಿ';

  @override
  String get save => 'ಉಳಿಸಿ';

  @override
  String listeningIn(String language) {
    return 'ಕೇಳುತ್ತಿದ್ದೇವೆ: $language ನಲ್ಲಿ';
  }

  @override
  String get speakPrompt => 'ದಯವಿಟ್ಟು ನಿಮ್ಮ ಪರಿಸ್ಥಿತಿ ವಿವರಿಸಿ';

  @override
  String get analyzingVoice => 'ನಿಮ್ಮ ಪರಿಸ್ಥಿತಿ ಅರ್ಥಮಾಡಿಕೊಳ್ಳುತ್ತಿದ್ದೇವೆ...';

  @override
  String get matchingSchemes => 'ನಿಮ್ಮ ಯೋಜನೆಗಳನ್ನು ಹುಡುಕುತ್ತಿದ್ದೇವೆ...';

  @override
  String get generatingForm => 'ನಿಮ್ಮ ಅರ್ಜಿ ಸಿದ್ಧಪಡಿಸುತ್ತಿದ್ದೇವೆ...';

  @override
  String schemesFound(int count) {
    return '$count ಯೋಜನೆಗಳು ಕಂಡುಬಂದಿವೆ';
  }

  @override
  String totalBenefit(String amount) {
    return '₹$amount / ವರ್ಷ';
  }

  @override
  String get totalEstimatedBenefits => 'ಒಟ್ಟು ಅಂದಾಜು ಪ್ರಯೋಜನಗಳು';

  @override
  String get eligibleSchemes => 'ಅರ್ಹ ಯೋಜನೆಗಳು';

  @override
  String get noSchemesFound => 'ಯಾವ ಯೋಜನೆಗಳೂ ಕಂಡುಬಂದಿಲ್ಲ';

  @override
  String get tryUpdatingProfile => 'ನಿಮ್ಮ ಪ್ರೊಫೈಲ್ ಮಾಹಿತಿ ನವೀಕರಿಸಿ';

  @override
  String get applyNow => 'ಈಗಲೇ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ';

  @override
  String get back => 'ಹಿಂದೆ';

  @override
  String get schemeDetails => 'ಯೋಜನೆ ವಿವರಗಳು';

  @override
  String get eligibilityScore => 'ಅರ್ಹತಾ ಸ್ಕೋರ್';

  @override
  String get whyEligible => 'ಏಕೆ ಅರ್ಹರು:';

  @override
  String get description => 'ವಿವರಣೆ';

  @override
  String get requiredDocuments => 'ಅಗತ್ಯ ದಾಖಲೆಗಳು';

  @override
  String get applicationInfo => 'ಅರ್ಜಿ ಮಾಹಿತಿ';

  @override
  String get ministry => 'ಮಂತ್ರಾಲಯ';

  @override
  String get applyAt => 'ಇಲ್ಲಿ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ';

  @override
  String get visitOfficialWebsite => 'ಅಧಿಕೃತ ವೆಬ್‌ಸೈಟ್ ಭೇಟಿ ಮಾಡಿ';

  @override
  String get documentsNeeded => 'ಅಗತ್ಯ ದಾಖಲೆಗಳು';

  @override
  String get iHaveAllDocuments => 'ಎಲ್ಲಾ ದಾಖಲೆಗಳಿವೆ → ಈಗಲೇ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ';

  @override
  String get missingDocuments => 'ದಾಖಲೆಗಳಿಲ್ಲ → ನಂತರಕ್ಕೆ ಉಳಿಸಿ';

  @override
  String get howToGet => 'ಇದನ್ನು ಹೇಗೆ ಪಡೆಯುವುದು';

  @override
  String get findNearestOffice => 'ಹತ್ತಿರದ ಕಚೇರಿ ಹುಡುಕಿ';

  @override
  String get shareScheme => 'ಯೋಜನೆ ಹಂಚಿಕೊಳ್ಳಿ';

  @override
  String shareText(
      String name, String benefit, String eligibility, String url) {
    return '$name\nಪ್ರಯೋಜನ: $benefit\nಅರ್ಹತೆ: $eligibility\nಅರ್ಜಿ ಸಲ್ಲಿಸಿ: $url\n\nAdhikar app ಮೂಲಕ ಕಂಡುಹಿಡಿಯಲಾಗಿದೆ';
  }

  @override
  String get applicationHistory => 'ಅರ್ಜಿ ಇತಿಹಾಸ';

  @override
  String get noApplications => 'ಇನ್ನೂ ಅರ್ಜಿಗಳಿಲ್ಲ. ಈಗಲೇ ಹುಡುಕಿ!';

  @override
  String get statusSubmitted => 'ಸಲ್ಲಿಸಲಾಗಿದೆ';

  @override
  String get statusUnderReview => 'ಪರಿಶೀಲನೆಯಲ್ಲಿ';

  @override
  String get statusApproved => 'ಅನುಮೋದಿಸಲಾಗಿದೆ';

  @override
  String get statusRejected => 'ನಿರಾಕರಿಸಲಾಗಿದೆ';

  @override
  String submittedDate(String date) {
    return 'ಸಲ್ಲಿಸಿದ ದಿನಾಂಕ: $date';
  }

  @override
  String referenceNumber(String number) {
    return 'ಉಲ್ಲೇಖ: $number';
  }

  @override
  String get offlineMessage =>
      'ಇಂಟರ್ನೆಟ್ ಇಲ್ಲ. ಉಳಿಸಿದ ಯೋಜನೆಗಳನ್ನು ತೋರಿಸಲಾಗುತ್ತಿದೆ.';

  @override
  String get settings => 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು';

  @override
  String get language => 'ಭಾಷೆ';

  @override
  String get currentLanguage => 'ಪ್ರಸ್ತುತ';

  @override
  String get voiceAndSound => 'ಧ್ವನಿ ಮತ್ತು ಶಬ್ದ';

  @override
  String get enableTTS => 'TTS ನರೇಶನ್ ಸಕ್ರಿಯಗೊಳಿಸಿ';

  @override
  String get autoPlayResults => 'ಫಲಿತಾಂಶಗಳನ್ನು ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಚಾಲಿಸಿ';

  @override
  String get speechSpeed => 'ಮಾತಿನ ವೇಗ';

  @override
  String get slow => 'ನಿಧಾನ';

  @override
  String get normal => 'ಸಾಮಾನ್ಯ';

  @override
  String get fast => 'ವೇಗ';

  @override
  String get notifications => 'ಅಧಿಸೂಚನೆಗಳು';

  @override
  String get statusAlerts => 'ಅರ್ಜಿ ಸ್ಥಿತಿ ಎಚ್ಚರಿಕೆಗಳು';

  @override
  String get documentReminders => 'ದಾಖಲೆ ಜ್ಞಾಪನಗಳು';

  @override
  String get newSchemeAlerts => 'ಹೊಸ ಯೋಜನೆ ಎಚ್ಚರಿಕೆಗಳು';

  @override
  String get accessibility => 'ಪ್ರವೇಶಿಸುವಿಕೆ';

  @override
  String get largeText => 'ದೊಡ್ಡ ಪಠ್ಯ ಮೋಡ್';

  @override
  String get highContrast => 'ಹೆಚ್ಚಿನ ವ್ಯತಿರೇಕ ಮೋಡ್';

  @override
  String get dataPrivacy => 'ಡೇಟಾ ಮತ್ತು ಗೌಪ್ಯತೆ';

  @override
  String get exportData => 'ನನ್ನ ಡೇಟಾ ರಫ್ತು ಮಾಡಿ';

  @override
  String get deleteAccount => 'ಖಾತೆ ಅಳಿಸಿ';

  @override
  String get deleteConfirmTitle => 'ಖಾತೆ ಅಳಿಸಬೇಕೇ?';

  @override
  String get deleteConfirmBody =>
      'ಇದು ನಿಮ್ಮ ಎಲ್ಲಾ ಡೇಟಾವನ್ನು ಶಾಶ್ವತವಾಗಿ ಅಳಿಸುತ್ತದೆ.';

  @override
  String get confirm => 'ದೃಢೀಕರಿಸಿ';

  @override
  String get about => 'ಬಗ್ಗೆ';

  @override
  String get appVersion => 'ಅಪ್ಲಿಕೇಶನ್ ಆವೃತ್ತಿ';

  @override
  String get contactSupport => 'ಬೆಂಬಲ ಸಂಪರ್ಕಿಸಿ';

  @override
  String get onboarding1Title => 'Adhikar ಗೆ ಸ್ವಾಗತ';

  @override
  String get onboarding1Body =>
      'ನಿಮಗೆ ಸಲ್ಲಬೇಕಾದ ಪ್ರತಿಯೊಂದು ಸರ್ಕಾರಿ ಕಲ್ಯಾಣ ಯೋಜನೆ — ನಿಮ್ಮ ಭಾಷೆಯಲ್ಲಿ.';

  @override
  String get onboarding2Title => 'ನಿಮ್ಮ ಪರಿಸ್ಥಿತಿ ಹೇಳಿ';

  @override
  String get onboarding2Body =>
      'ಮೈಕ್ ಒತ್ತಿ ನಿಮ್ಮ ಬಗ್ಗೆ ಹೇಳಿ — ವಯಸ್ಸು, ವೃತ್ತಿ, ಕುಟುಂಬ, ಆದಾಯ.';

  @override
  String get onboarding2Example =>
      'ನಾನು 45 ವರ್ಷದ ವಿಧವೆ ರೈತಳು, ನನ್ನ ಬಳಿ 2 ಎಕರೆ ಭೂಮಿ ಇದೆ...';

  @override
  String get onboarding3Title => 'ನಿಮ್ಮ ಹಕ್ಕುಗಳನ್ನು ತಿಳಿಯಿರಿ';

  @override
  String get onboarding3Body =>
      '200+ ಸರ್ಕಾರಿ ಯೋಜನೆಗಳಿಂದ ನಿಮಗೆ ಸರಿಯಾದ ಯೋಜನೆಗಳನ್ನು ಹುಡುಕಿ ತೋರಿಸುತ್ತೇವೆ.';

  @override
  String get onboarding4Title => 'ತಕ್ಷಣ ಅರ್ಜಿ ಸಲ್ಲಿಸಿ';

  @override
  String get onboarding4Body =>
      'ಫಾರ್ಮ್‌ಗಳು ಸ್ವಯಂಚಾಲಿತವಾಗಿ ತುಂಬಲ್ಪಡುತ್ತವೆ. ನಕ್ಷೆಯಲ್ಲಿ ಹತ್ತಿರದ ಕಚೇರಿ ಹುಡುಕಿ.';

  @override
  String get getStarted => 'ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get skipOnboarding => 'ಬಿಟ್ಟುಬಿಡಿ';

  @override
  String get next => 'ಮುಂದೆ';

  @override
  String get networkError => 'ಇಂಟರ್ನೆಟ್ ಇಲ್ಲ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get geminiError => 'AI ಲಭ್ಯವಿಲ್ಲ. ಮೂಲ ಹೊಂದಾಣಿಕೆ ಬಳಸಲಾಗುತ್ತಿದೆ.';

  @override
  String get firebaseError => 'ಸಿಂಕ್ ವಿಫಲವಾಗಿದೆ. ಡೇಟಾ ಸ್ಥಳೀಯವಾಗಿ ಉಳಿಸಲಾಗಿದೆ.';

  @override
  String get categoryAll => 'ಎಲ್ಲಾ';

  @override
  String get categoryAgriculture => 'ಕೃಷಿ';

  @override
  String get categoryHealth => 'ಆರೋಗ್ಯ';

  @override
  String get categoryEducation => 'ಶಿಕ್ಷಣ';

  @override
  String get categoryHousing => 'ವಸತಿ';

  @override
  String get categoryWomen => 'ಮಹಿಳೆ ಮತ್ತು ಮಕ್ಕಳು';

  @override
  String get categoryEmployment => 'ಉದ್ಯೋಗ';

  @override
  String get categoryDisability => 'ವಿಕಲಾಂಗತೆ';

  @override
  String get categorySenior => 'ಹಿರಿಯ ನಾಗರಿಕ';

  @override
  String get profileTitle => 'ನಿಮ್ಮ ಪ್ರೊಫೈಲ್';

  @override
  String get editProfile => 'ಪ್ರೊಫೈಲ್ ಸಂಪಾದಿಸಿ';

  @override
  String get name => 'ಹೆಸರು';

  @override
  String get age => 'ವಯಸ್ಸು';

  @override
  String get gender => 'ಲಿಂಗ';

  @override
  String get caste => 'ಜಾತಿ ವರ್ಗ';

  @override
  String get occupation => 'ವೃತ್ತಿ';

  @override
  String get income => 'ವಾರ್ಷಿಕ ಆದಾಯ';

  @override
  String get state => 'ರಾಜ್ಯ';

  @override
  String get district => 'ಜಿಲ್ಲೆ';

  @override
  String get landOwned => 'ಭೂಮಿ (ಎಕರೆ)';

  @override
  String get familySize => 'ಕುಟುಂಬ ಗಾತ್ರ';

  @override
  String get maritalStatus => 'ವೈವಾಹಿಕ ಸ್ಥಿತಿ';

  @override
  String get disability => 'ವಿಕಲಾಂಗತೆ';

  @override
  String get helpButton => 'ಸಹಾಯ ಬೇಕೇ?';

  @override
  String get pullToRefresh => 'ರಿಫ್ರೆಶ್ ಮಾಡಲು ಎಳೆಯಿರಿ';
}
