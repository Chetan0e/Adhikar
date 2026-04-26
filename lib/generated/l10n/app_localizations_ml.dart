// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appName => 'അധികാർ';

  @override
  String get tagline => 'നിങ്ങളുടെ അവകാശം. നിങ്ങളുടെ വാതിലിൽ.';

  @override
  String get builtForBharat => 'ഭാരതത്തിനായി നിർമ്മിച്ചത് 🇮🇳';

  @override
  String get poweredByAI => 'ഭാരതത്തിനായി AI ഉപയോഗിച്ച് പ്രവർത്തിക്കുന്നു';

  @override
  String get selectLanguage => 'ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get chooseLanguage => 'നിങ്ങളുടെ ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get continueButton => 'തുടരുക';

  @override
  String get continueWithEnglish => 'ഇംഗ്ലീഷിൽ തുടരുക';

  @override
  String get changeLanguage => 'ഭാഷ മാറ്റുക';

  @override
  String languageChanged(String language) {
    return 'ഭാഷ $language ലേക്ക് മാറ്റി';
  }

  @override
  String get voiceInputTitle => 'നിങ്ങളുടെ സ്ഥിതി പറയൂ';

  @override
  String get voiceInputSubtitle =>
      'നിങ്ങളെക്കുറിച്ചും കുടുംബം, വരുമാനം, തൊഴിൽ എന്നിവയെക്കുറിച്ചും പറയൂ';

  @override
  String get transcriptLabel => 'നിങ്ങളുടെ വാക്കുകൾ';

  @override
  String get typeInstead => 'ടൈപ്പ് ചെയ്യുക';

  @override
  String get transcriptHint => 'നിങ്ങളുടെ വാക്കുകൾ ഇവിടെ...';

  @override
  String get pleaseSpeak => 'ദയവായി സംസാരിക്കൂ';

  @override
  String get listening => 'കേൾക്കുന്നു...';

  @override
  String get tapToSpeakAgain => 'വീണ്ടും പറയൂ';

  @override
  String get enterYourInfo => 'വിവരം നൽകൂ';

  @override
  String get describeHint => 'സ്ഥിതി വിവരിക്കൂ...';

  @override
  String get cancel => 'റദ്ദ്';

  @override
  String get save => 'സേവ്';

  @override
  String listeningIn(String language) {
    return 'കേൾക്കുന്നു: $language';
  }

  @override
  String get speakPrompt => 'നിങ്ങളുടെ സ്ഥിതി പറയൂ';

  @override
  String get analyzingVoice => 'മനസ്സിലാക്കുന്നു...';

  @override
  String get matchingSchemes => 'പദ്ധതികൾ തിരയുന്നു...';

  @override
  String get generatingForm => 'അപേക്ഷ തയ്യാറാക്കുന്നു...';

  @override
  String schemesFound(int count) {
    return '$count പദ്ധതികൾ';
  }

  @override
  String totalBenefit(String amount) {
    return '₹$amount / വർഷം';
  }

  @override
  String get totalEstimatedBenefits => 'ആകെ ആനുകൂല്യം';

  @override
  String get eligibleSchemes => 'അർഹമായ പദ്ധതികൾ';

  @override
  String get noSchemesFound => 'പദ്ധതികൾ കിട്ടിയില്ല';

  @override
  String get tryUpdatingProfile => 'പ്രൊഫൈൽ അപ്‌ഡേറ്റ് ചെയ്യൂ';

  @override
  String get applyNow => 'ഇപ്പോൾ അപേക്ഷിക്കൂ';

  @override
  String get back => 'തിരികെ';

  @override
  String get schemeDetails => 'വിവരം';

  @override
  String get eligibilityScore => 'സ്കോർ';

  @override
  String get whyEligible => 'കാരണം:';

  @override
  String get description => 'വിവരണം';

  @override
  String get requiredDocuments => 'രേഖകൾ';

  @override
  String get applicationInfo => 'അപേക്ഷ';

  @override
  String get ministry => 'മന്ത്രാലയം';

  @override
  String get applyAt => 'അപേക്ഷിക്കൂ';

  @override
  String get visitOfficialWebsite => 'വെബ്സൈറ്റ്';

  @override
  String get documentsNeeded => 'ആവശ്യ രേഖകൾ';

  @override
  String get iHaveAllDocuments => 'രേഖകൾ ഉണ്ട് → അപേക്ഷ';

  @override
  String get missingDocuments => 'രേഖകൾ ഇല്ല → സേവ്';

  @override
  String get howToGet => 'എങ്ങനെ?';

  @override
  String get findNearestOffice => 'ഓഫീസ്';

  @override
  String get shareScheme => 'ഷെയർ';

  @override
  String shareText(
      String name, String benefit, String eligibility, String url) {
    return '$name\nആനുകൂല്യം: $benefit\nഅർഹത: $eligibility\nഅപേക്ഷ: $url\n\nAdhikar app';
  }

  @override
  String get applicationHistory => 'ചരിത്രം';

  @override
  String get noApplications => 'അപേക്ഷ ഇല്ല!';

  @override
  String get statusSubmitted => 'സമർപ്പിച്ചു';

  @override
  String get statusUnderReview => 'പരിശോധനയിൽ';

  @override
  String get statusApproved => 'അംഗീകരിച്ചു';

  @override
  String get statusRejected => 'നിരസിച്ചു';

  @override
  String submittedDate(String date) {
    return 'സമർപ്പിച്ചു: $date';
  }

  @override
  String referenceNumber(String number) {
    return 'Ref: $number';
  }

  @override
  String get offlineMessage => 'ഇന്റർനെറ്റ് ഇല്ല.';

  @override
  String get settings => 'ക്രമീകരണം';

  @override
  String get language => 'ഭാഷ';

  @override
  String get currentLanguage => 'നിലവിലുള്ളത്';

  @override
  String get voiceAndSound => 'ശബ്ദം';

  @override
  String get enableTTS => 'TTS';

  @override
  String get autoPlayResults => 'ഓട്ടോ';

  @override
  String get speechSpeed => 'വേഗത';

  @override
  String get slow => 'സ്ലോ';

  @override
  String get normal => 'സാധാരണ';

  @override
  String get fast => 'വേഗം';

  @override
  String get notifications => 'അറിയിപ്പ്';

  @override
  String get statusAlerts => 'സ്ഥിതി';

  @override
  String get documentReminders => 'രേഖ';

  @override
  String get newSchemeAlerts => 'പുതിയ';

  @override
  String get accessibility => 'ആക്സസ്';

  @override
  String get largeText => 'വലിയ ടെക്സ്റ്റ്';

  @override
  String get highContrast => 'കോൺട്രാസ്റ്റ്';

  @override
  String get dataPrivacy => 'സ്വകാര്യത';

  @override
  String get exportData => 'ഡേറ്റ';

  @override
  String get deleteAccount => 'ഡിലീറ്റ്';

  @override
  String get deleteConfirmTitle => 'ഡിലീറ്റ്?';

  @override
  String get deleteConfirmBody => 'ഡേറ്റ നഷ്ടമാകും.';

  @override
  String get confirm => 'ഉറപ്പ്';

  @override
  String get about => 'കുറിച്ച്';

  @override
  String get appVersion => 'പതിപ്പ്';

  @override
  String get contactSupport => 'ബന്ധം';

  @override
  String get onboarding1Title => 'Adhikar-ലേക്ക് സ്വാഗതം';

  @override
  String get onboarding1Body => 'നിങ്ങളുടെ ഭാഷയിൽ സർക്കാർ പദ്ധതികൾ.';

  @override
  String get onboarding2Title => 'പറയൂ';

  @override
  String get onboarding2Body =>
      'മൈക്ക് അമർത്തി പ്രായം, ജോലി, കുടുംബം, വരുമാനം പറയൂ.';

  @override
  String get onboarding2Example =>
      'ഞാൻ 45 വയസ്സുള്ള വിധവ കർഷക, 2 ഏക്കർ ഭൂമി...';

  @override
  String get onboarding3Title => 'അവകാശം';

  @override
  String get onboarding3Body => '200+ പദ്ധതികൾ.';

  @override
  String get onboarding4Title => 'അപേക്ഷ';

  @override
  String get onboarding4Body => 'ഫോം നിറയ്ക്കും. ഓഫീസ് കണ്ടുപിടിക്കൂ.';

  @override
  String get getStarted => 'തുടങ്ങൂ';

  @override
  String get skipOnboarding => 'ഒഴിവാക്കൂ';

  @override
  String get next => 'അടുത്തത്';

  @override
  String get networkError => 'ഇന്റർനെറ്റ് ഇല്ല.';

  @override
  String get geminiError => 'AI ഇല്ല.';

  @override
  String get firebaseError => 'സിൻക് ഇല്ല.';

  @override
  String get categoryAll => 'എല്ലാം';

  @override
  String get categoryAgriculture => 'കൃഷി';

  @override
  String get categoryHealth => 'ആരോഗ്യം';

  @override
  String get categoryEducation => 'വിദ്യാഭ്യാസം';

  @override
  String get categoryHousing => 'ഭവനം';

  @override
  String get categoryWomen => 'സ്ത്രീ';

  @override
  String get categoryEmployment => 'തൊഴിൽ';

  @override
  String get categoryDisability => 'ഭിന്നശേഷി';

  @override
  String get categorySenior => 'മൂത്തവർ';

  @override
  String get profileTitle => 'പ്രൊഫൈൽ';

  @override
  String get editProfile => 'എഡിറ്റ്';

  @override
  String get name => 'പേര്';

  @override
  String get age => 'പ്രായം';

  @override
  String get gender => 'ലിംഗം';

  @override
  String get caste => 'ജാതി';

  @override
  String get occupation => 'ജോലി';

  @override
  String get income => 'വരുമാനം';

  @override
  String get state => 'സംസ്ഥാനം';

  @override
  String get district => 'ജില്ല';

  @override
  String get landOwned => 'ഭൂമി';

  @override
  String get familySize => 'കുടുംബം';

  @override
  String get maritalStatus => 'വിവാഹം';

  @override
  String get disability => 'ഭിന്നശേഷി';

  @override
  String get helpButton => 'സഹായം?';

  @override
  String get pullToRefresh => 'റിഫ്രഷ്';

  @override
  String get aiGreeting =>
      'നമസ്കാരം! ഞാൻ അധിക്കാര് AI ആണ്. സർക്കാർ പദ്ധതികളെ കുറിച്ച് എന്തെങ്കിലും ചോദിക്കുക.';

  @override
  String get askScheme => 'ഏതെങ്കിലും പദ്ധതിയെ കുറിച്ച് ചോദിക്കുക...';

  @override
  String get profileReview => 'പ്രൊഫൈൽ അവലോകനം';

  @override
  String get noProfileData =>
      'പ്രൊഫൈൽ കിട്ടിയില്ല. ദയവായി തിരികെ പോയി വീണ്ടും സംസാരിക്കുക.';

  @override
  String get discover => 'കണ്ടെത്തുക';

  @override
  String get schemes => 'പദ്ധതികൾ';

  @override
  String get aiChat => 'AI ചാറ്റ്';

  @override
  String get history => 'ചരിത്രം';
}
