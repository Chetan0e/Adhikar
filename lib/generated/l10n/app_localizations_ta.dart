// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appName => 'அதிகார்';

  @override
  String get tagline => 'உங்கள் உரிமை. உங்கள் வீட்டு வாசலில்.';

  @override
  String get builtForBharat => 'பாரதத்திற்காக கட்டப்பட்டது 🇮🇳';

  @override
  String get poweredByAI => 'பாரதத்திற்காக AI ஆல் இயக்கப்படுகிறது';

  @override
  String get selectLanguage => 'மொழி தேர்வு';

  @override
  String get chooseLanguage => 'உங்கள் மொழியை தேர்ந்தெடுக்கவும்';

  @override
  String get continueButton => 'தொடரவும்';

  @override
  String get continueWithEnglish => 'ஆங்கிலத்தில் தொடரவும்';

  @override
  String get changeLanguage => 'மொழி மாற்றவும்';

  @override
  String languageChanged(String language) {
    return 'மொழி $language ஆக மாற்றப்பட்டது';
  }

  @override
  String get voiceInputTitle => 'உங்கள் நிலையை சொல்லுங்கள்';

  @override
  String get voiceInputSubtitle =>
      'உங்களைப் பற்றி, குடும்பம், வருமானம், தொழில் பற்றி பேசுங்கள்';

  @override
  String get transcriptLabel => 'உங்கள் பேச்சு';

  @override
  String get typeInstead => 'பேசுவதற்கு பதிலாக தட்டச்சு செய்யுங்கள்';

  @override
  String get transcriptHint => 'உங்கள் பேச்சு இங்கே தோன்றும்...';

  @override
  String get pleaseSpeak => 'தயவுசெய்து பேசுங்கள் அல்லது தட்டச்சு செய்யுங்கள்';

  @override
  String get listening => 'கேட்கிறோம்...';

  @override
  String get tapToSpeakAgain => 'மீண்டும் பேச தட்டவும்';

  @override
  String get enterYourInfo => 'உங்கள் தகவலை உள்ளிடுங்கள்';

  @override
  String get describeHint => 'உங்கள் நிலையை விவரிக்கவும்...';

  @override
  String get cancel => 'ரத்துசெய்';

  @override
  String get save => 'சேமி';

  @override
  String listeningIn(String language) {
    return 'கேட்கிறோம்: $language இல்';
  }

  @override
  String get speakPrompt =>
      'தயவுசெய்து உங்கள் நிலையை உங்கள் சொந்த வார்த்தைகளில் சொல்லுங்கள்';

  @override
  String get analyzingVoice => 'உங்கள் நிலையை புரிந்துகொள்கிறோம்...';

  @override
  String get matchingSchemes => 'உங்கள் திட்டங்களைத் தேடுகிறோம்...';

  @override
  String get generatingForm => 'உங்கள் விண்ணப்பத்தை தயார் செய்கிறோம்...';

  @override
  String schemesFound(int count) {
    return '$count திட்டங்கள் கண்டுபிடிக்கப்பட்டன';
  }

  @override
  String totalBenefit(String amount) {
    return '₹$amount / ஆண்டு';
  }

  @override
  String get totalEstimatedBenefits => 'மொத்த மதிப்பிடப்பட்ட பலன்கள்';

  @override
  String get eligibleSchemes => 'தகுதியான திட்டங்கள்';

  @override
  String get noSchemesFound => 'திட்டங்கள் எதுவும் கிடைக்கவில்லை';

  @override
  String get tryUpdatingProfile =>
      'உங்கள் சுயவிவர தகவலை புதுப்பிக்க முயற்சிக்கவும்';

  @override
  String get applyNow => 'இப்போதே விண்ணப்பிக்கவும்';

  @override
  String get back => 'திரும்பு';

  @override
  String get schemeDetails => 'திட்ட விவரங்கள்';

  @override
  String get eligibilityScore => 'தகுதி மதிப்பெண்';

  @override
  String get whyEligible => 'ஏன் தகுதியானீர்கள்:';

  @override
  String get description => 'விவரம்';

  @override
  String get requiredDocuments => 'தேவையான ஆவணங்கள்';

  @override
  String get applicationInfo => 'விண்ணப்ப தகவல்';

  @override
  String get ministry => 'அமைச்சகம்';

  @override
  String get applyAt => 'இங்கே விண்ணப்பிக்கவும்';

  @override
  String get visitOfficialWebsite => 'அதிகாரப்பூர்வ இணையதளத்தை பார்வையிடவும்';

  @override
  String get documentsNeeded => 'தேவையான ஆவணங்கள்';

  @override
  String get iHaveAllDocuments =>
      'எல்லா ஆவணங்களும் உள்ளன → இப்போதே விண்ணப்பிக்கவும்';

  @override
  String get missingDocuments => 'ஆவணங்கள் இல்லை → பின்னர் சேமிக்கவும்';

  @override
  String get howToGet => 'இதை எவ்வாறு பெறுவது';

  @override
  String get findNearestOffice => 'அருகில் உள்ள அலுவலகம் தேடவும்';

  @override
  String get shareScheme => 'திட்டத்தை பகிரவும்';

  @override
  String shareText(
      String name, String benefit, String eligibility, String url) {
    return '$name\nபலன்: $benefit\nதகுதி: $eligibility\nவிண்ணப்பிக்கவும்: $url\n\nAdhikar app மூலம் கண்டறியப்பட்டது';
  }

  @override
  String get applicationHistory => 'விண்ணப்ப வரலாறு';

  @override
  String get noApplications =>
      'இன்னும் விண்ணப்பங்கள் இல்லை. இப்போதே கண்டறியுங்கள்!';

  @override
  String get statusSubmitted => 'சமர்ப்பிக்கப்பட்டது';

  @override
  String get statusUnderReview => 'மதிப்பாய்வில்';

  @override
  String get statusApproved => 'அனுமதிக்கப்பட்டது';

  @override
  String get statusRejected => 'நிராகரிக்கப்பட்டது';

  @override
  String submittedDate(String date) {
    return 'சமர்ப்பிக்கப்பட்டது: $date';
  }

  @override
  String referenceNumber(String number) {
    return 'குறிப்பு: $number';
  }

  @override
  String get offlineMessage =>
      'இணையம் இல்லை. சேமிக்கப்பட்ட திட்டங்கள் காட்டப்படுகின்றன.';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get language => 'மொழி';

  @override
  String get currentLanguage => 'தற்போதைய';

  @override
  String get voiceAndSound => 'குரல் மற்றும் ஒலி';

  @override
  String get enableTTS => 'TTS நரேஷன் இயக்கவும்';

  @override
  String get autoPlayResults => 'முடிவுகளை தானாக இயக்கவும்';

  @override
  String get speechSpeed => 'பேச்சு வேகம்';

  @override
  String get slow => 'மெதுவாக';

  @override
  String get normal => 'சாதாரண';

  @override
  String get fast => 'வேகமாக';

  @override
  String get notifications => 'அறிவிப்புகள்';

  @override
  String get statusAlerts => 'விண்ணப்ப நிலை எச்சரிக்கைகள்';

  @override
  String get documentReminders => 'ஆவண நினைவூட்டல்கள்';

  @override
  String get newSchemeAlerts => 'புதிய திட்ட எச்சரிக்கைகள்';

  @override
  String get accessibility => 'அணுகல்';

  @override
  String get largeText => 'பெரிய உரை பயன்முறை';

  @override
  String get highContrast => 'உயர் மாறுபாடு பயன்முறை';

  @override
  String get dataPrivacy => 'தரவு மற்றும் தனியுரிமை';

  @override
  String get exportData => 'என் தரவை ஏற்றுமதி செய்';

  @override
  String get deleteAccount => 'கணக்கை நீக்கு';

  @override
  String get deleteConfirmTitle => 'கணக்கை நீக்கவா?';

  @override
  String get deleteConfirmBody =>
      'இது உங்கள் எல்லா தரவையும் நிரந்தரமாக நீக்கும். இந்த செயலை மாற்றியமைக்க முடியாது.';

  @override
  String get confirm => 'உறுதிப்படுத்து';

  @override
  String get about => 'பற்றி';

  @override
  String get appVersion => 'ஆப் பதிப்பு';

  @override
  String get contactSupport => 'ஆதரவை தொடர்பு கொள்ளவும்';

  @override
  String get onboarding1Title => 'Adhikar-க்கு வரவேற்கிறோம்';

  @override
  String get onboarding1Body =>
      'நீங்கள் பெறத்தகுதியான ஒவ்வொரு அரசு நலத்திட்டமும் — உங்கள் மொழியில்.';

  @override
  String get onboarding2Title => 'உங்கள் நிலையை சொல்லுங்கள்';

  @override
  String get onboarding2Body =>
      'மைக்ரோஃபோனை அழுத்தி உங்களைப் பற்றி சொல்லுங்கள் — வயது, தொழில், குடும்பம், வருமானம்.';

  @override
  String get onboarding2Example =>
      'நான் 45 வயதான விதவை விவசாயி, என்னிடம் 2 ஏக்கர் நிலம் உள்ளது...';

  @override
  String get onboarding3Title => 'உங்கள் உரிமைகளை அறிந்துகொள்ளுங்கள்';

  @override
  String get onboarding3Body =>
      '200+ அரசு திட்டங்களிலிருந்து உங்களுக்கு சரியான திட்டங்களை கண்டுபிடிக்கிறோம்.';

  @override
  String get onboarding4Title => 'உடனடியாக விண்ணப்பிக்கவும்';

  @override
  String get onboarding4Body =>
      'படிவங்கள் தானாக நிரப்பப்படுகின்றன. வரைபடத்தில் அருகிலுள்ள அலுவலகம் கண்டறியவும்.';

  @override
  String get getStarted => 'தொடங்கவும்';

  @override
  String get skipOnboarding => 'தவிர்';

  @override
  String get next => 'அடுத்து';

  @override
  String get networkError => 'இணையம் இல்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get geminiError =>
      'AI கிடைக்கவில்லை. அடிப்படை பொருத்தம் பயன்படுத்தப்படுகிறது.';

  @override
  String get firebaseError =>
      'ஒத்திசைவு தோல்வியுற்றது. தரவு உள்ளூரில் சேமிக்கப்பட்டது.';

  @override
  String get categoryAll => 'அனைத்தும்';

  @override
  String get categoryAgriculture => 'விவசாயம்';

  @override
  String get categoryHealth => 'சுகாதாரம்';

  @override
  String get categoryEducation => 'கல்வி';

  @override
  String get categoryHousing => 'வீட்டுவசதி';

  @override
  String get categoryWomen => 'பெண்கள் மற்றும் குழந்தை';

  @override
  String get categoryEmployment => 'வேலைவாய்ப்பு';

  @override
  String get categoryDisability => 'மாற்றுத்திறனாளி';

  @override
  String get categorySenior => 'மூத்த குடிமகன்';

  @override
  String get profileTitle => 'உங்கள் சுயவிவரம்';

  @override
  String get editProfile => 'சுயவிவரம் திருத்தவும்';

  @override
  String get name => 'பெயர்';

  @override
  String get age => 'வயது';

  @override
  String get gender => 'பாலினம்';

  @override
  String get caste => 'சாதி வகை';

  @override
  String get occupation => 'தொழில்';

  @override
  String get income => 'வருடாந்திர வருமானம்';

  @override
  String get state => 'மாநிலம்';

  @override
  String get district => 'மாவட்டம்';

  @override
  String get landOwned => 'நிலம் (ஏக்கர்)';

  @override
  String get familySize => 'குடும்ப அளவு';

  @override
  String get maritalStatus => 'திருமண நிலை';

  @override
  String get disability => 'மாற்றுத்திறன்';

  @override
  String get helpButton => 'உதவி தேவையா?';

  @override
  String get pullToRefresh => 'புதுப்பிக்க இழுக்கவும்';

  @override
  String get aiGreeting =>
      'வணக்கம்! நான் அதிகார் AI. அரசு திட்டங்களைப் பற்றி எதையும் கேளுங்கள்.';

  @override
  String get askScheme => 'எந்த திட்டத்தைப் பற்றியும் கேளுங்கள்...';

  @override
  String get profileReview => 'சுயவிவர மதிப்பாய்வு';

  @override
  String get noProfileData =>
      'சுயவிவரம் கிடைக்கவில்லை. தயவுசெய்து திரும்பி பேசுங்கள்.';

  @override
  String get discover => 'கண்டறியுங்கள்';

  @override
  String get schemes => 'திட்டங்கள்';

  @override
  String get aiChat => 'AI அரட்டை';

  @override
  String get history => 'வரலாறு';
}
