// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Adhikar';

  @override
  String get tagline => 'Your Right. Delivered.';

  @override
  String get builtForBharat => 'Built for Bharat 🇮🇳';

  @override
  String get poweredByAI => 'Powered by AI for Bharat';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get chooseLanguage => 'Choose your language';

  @override
  String get continueButton => 'Continue';

  @override
  String get continueWithEnglish => 'Continue with English';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String languageChanged(String language) {
    return 'Language changed to $language';
  }

  @override
  String get voiceInputTitle => 'Describe your situation';

  @override
  String get voiceInputSubtitle =>
      'Speak about yourself, your family, income, occupation, etc.';

  @override
  String get transcriptLabel => 'Transcript';

  @override
  String get typeInstead => 'Type instead of speaking';

  @override
  String get transcriptHint => 'Your speech will appear here...';

  @override
  String get pleaseSpeak => 'Please speak or type your information';

  @override
  String get listening => 'Listening...';

  @override
  String get tapToSpeakAgain => 'Tap to speak again';

  @override
  String get enterYourInfo => 'Enter your information';

  @override
  String get describeHint => 'Describe your situation...';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String listeningIn(String language) {
    return 'Listening in: $language';
  }

  @override
  String get speakPrompt => 'Please describe your situation in your own words';

  @override
  String get analyzingVoice => 'Understanding your situation...';

  @override
  String get matchingSchemes => 'Finding your benefits...';

  @override
  String get generatingForm => 'Preparing your application...';

  @override
  String schemesFound(int count) {
    return '$count Schemes Eligible';
  }

  @override
  String totalBenefit(String amount) {
    return '₹$amount / year';
  }

  @override
  String get totalEstimatedBenefits => 'Total Estimated Benefits';

  @override
  String get eligibleSchemes => 'Eligible Schemes';

  @override
  String get noSchemesFound => 'No schemes found';

  @override
  String get tryUpdatingProfile => 'Try updating your profile information';

  @override
  String get applyNow => 'Apply Now';

  @override
  String get back => 'Back';

  @override
  String get schemeDetails => 'Scheme Details';

  @override
  String get eligibilityScore => 'Eligibility Score';

  @override
  String get whyEligible => 'Why Eligible:';

  @override
  String get description => 'Description';

  @override
  String get requiredDocuments => 'Required Documents';

  @override
  String get applicationInfo => 'Application Information';

  @override
  String get ministry => 'Ministry';

  @override
  String get applyAt => 'Apply At';

  @override
  String get visitOfficialWebsite => 'Visit Official Website';

  @override
  String get documentsNeeded => 'Documents You Need';

  @override
  String get iHaveAllDocuments => 'I have all documents → Apply Now';

  @override
  String get missingDocuments => 'Missing documents → Save for later';

  @override
  String get howToGet => 'How to get this';

  @override
  String get findNearestOffice => 'Find Nearest Office';

  @override
  String get shareScheme => 'Share Scheme';

  @override
  String shareText(
      String name, String benefit, String eligibility, String url) {
    return '$name\nBenefit: $benefit\nEligibility: $eligibility\nApply at: $url\n\nFound using Adhikar app';
  }

  @override
  String get applicationHistory => 'Application History';

  @override
  String get noApplications => 'No applications yet. Discover your schemes!';

  @override
  String get statusSubmitted => 'Submitted';

  @override
  String get statusUnderReview => 'Under Review';

  @override
  String get statusApproved => 'Approved';

  @override
  String get statusRejected => 'Rejected';

  @override
  String submittedDate(String date) {
    return 'Submitted: $date';
  }

  @override
  String referenceNumber(String number) {
    return 'Ref: $number';
  }

  @override
  String get offlineMessage => 'You\'re offline. Showing saved schemes.';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get currentLanguage => 'Current';

  @override
  String get voiceAndSound => 'Voice & Sound';

  @override
  String get enableTTS => 'Enable TTS Narration';

  @override
  String get autoPlayResults => 'Auto-play Results';

  @override
  String get speechSpeed => 'Speech Speed';

  @override
  String get slow => 'Slow';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Fast';

  @override
  String get notifications => 'Notifications';

  @override
  String get statusAlerts => 'Application Status Alerts';

  @override
  String get documentReminders => 'Document Reminders';

  @override
  String get newSchemeAlerts => 'New Scheme Alerts';

  @override
  String get accessibility => 'Accessibility';

  @override
  String get largeText => 'Large Text Mode';

  @override
  String get highContrast => 'High Contrast Mode';

  @override
  String get dataPrivacy => 'Data & Privacy';

  @override
  String get exportData => 'Export My Data';

  @override
  String get deleteAccount => 'Delete My Account';

  @override
  String get deleteConfirmTitle => 'Delete Account?';

  @override
  String get deleteConfirmBody =>
      'This will permanently delete all your data. This action cannot be undone.';

  @override
  String get confirm => 'Confirm';

  @override
  String get about => 'About';

  @override
  String get appVersion => 'App Version';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get onboarding1Title => 'Welcome to Adhikar';

  @override
  String get onboarding1Body =>
      'Your personal guide to every government welfare scheme you deserve — in your language.';

  @override
  String get onboarding2Title => 'Speak Your Situation';

  @override
  String get onboarding2Body =>
      'Just tap the mic and describe yourself — your age, occupation, family, income. Our AI understands your language.';

  @override
  String get onboarding2Example =>
      'I am a 45-year-old widow farmer with 2 acres of land...';

  @override
  String get onboarding3Title => 'Discover Your Benefits';

  @override
  String get onboarding3Body =>
      'We match your profile to 200+ government schemes and show you exactly what you\'re entitled to — with benefit amounts.';

  @override
  String get onboarding4Title => 'Apply Instantly';

  @override
  String get onboarding4Body =>
      'We auto-fill application forms for you. Find the nearest office on the map. Track your application status live.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get skipOnboarding => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get networkError => 'No internet. Please try again.';

  @override
  String get geminiError => 'AI unavailable. Using basic matching.';

  @override
  String get firebaseError => 'Sync failed. Data saved locally.';

  @override
  String get categoryAll => 'All';

  @override
  String get categoryAgriculture => 'Agriculture';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryEducation => 'Education';

  @override
  String get categoryHousing => 'Housing';

  @override
  String get categoryWomen => 'Women & Child';

  @override
  String get categoryEmployment => 'Employment';

  @override
  String get categoryDisability => 'Disability';

  @override
  String get categorySenior => 'Senior Citizen';

  @override
  String get profileTitle => 'Your Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get name => 'Name';

  @override
  String get age => 'Age';

  @override
  String get gender => 'Gender';

  @override
  String get caste => 'Caste Category';

  @override
  String get occupation => 'Occupation';

  @override
  String get income => 'Annual Income';

  @override
  String get state => 'State';

  @override
  String get district => 'District';

  @override
  String get landOwned => 'Land Owned (acres)';

  @override
  String get familySize => 'Family Size';

  @override
  String get maritalStatus => 'Marital Status';

  @override
  String get disability => 'Disability';

  @override
  String get helpButton => 'Need help?';

  @override
  String get pullToRefresh => 'Pull to refresh';
}
