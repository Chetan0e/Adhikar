// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'অধিকার';

  @override
  String get tagline => 'আপনার অধিকার। আপনার দরজায়।';

  @override
  String get builtForBharat => 'ভারতের জন্য তৈরি 🇮🇳';

  @override
  String get poweredByAI => 'এআই দ্বারা চালিত, ভারতের জন্য';

  @override
  String get selectLanguage => 'ভাষা নির্বাচন করুন';

  @override
  String get chooseLanguage => 'আপনার ভাষা বেছে নিন';

  @override
  String get continueButton => 'এগিয়ে যান';

  @override
  String get continueWithEnglish => 'ইংরেজিতে এগিয়ে যান';

  @override
  String get changeLanguage => 'ভাষা পরিবর্তন করুন';

  @override
  String languageChanged(String language) {
    return 'ভাষা $language এ পরিবর্তিত হয়েছে';
  }

  @override
  String get voiceInputTitle => 'আপনার পরিস্থিতি বলুন';

  @override
  String get voiceInputSubtitle =>
      'নিজের সম্পর্কে, পরিবার, আয়, পেশা সম্পর্কে বলুন';

  @override
  String get transcriptLabel => 'আপনার কথা';

  @override
  String get typeInstead => 'বলার পরিবর্তে টাইপ করুন';

  @override
  String get transcriptHint => 'আপনার কথা এখানে দেখাবে...';

  @override
  String get pleaseSpeak => 'অনুগ্রহ করে বলুন বা টাইপ করুন';

  @override
  String get listening => 'শুনছি...';

  @override
  String get tapToSpeakAgain => 'আবার বলতে ট্যাপ করুন';

  @override
  String get enterYourInfo => 'আপনার তথ্য দিন';

  @override
  String get describeHint => 'আপনার পরিস্থিতি বর্ণনা করুন...';

  @override
  String get cancel => 'বাতিল';

  @override
  String get save => 'সংরক্ষণ করুন';

  @override
  String listeningIn(String language) {
    return 'শুনছি: $language তে';
  }

  @override
  String get speakPrompt => 'অনুগ্রহ করে আপনার পরিস্থিতি নিজের ভাষায় বলুন';

  @override
  String get analyzingVoice => 'আপনার পরিস্থিতি বুঝছি...';

  @override
  String get matchingSchemes => 'আপনার প্রকল্পগুলো খুঁজছি...';

  @override
  String get generatingForm => 'আপনার আবেদন তৈরি করছি...';

  @override
  String schemesFound(int count) {
    return '$countটি প্রকল্প পাওয়া গেছে';
  }

  @override
  String totalBenefit(String amount) {
    return '₹$amount / বছর';
  }

  @override
  String get totalEstimatedBenefits => 'মোট আনুমানিক সুবিধা';

  @override
  String get eligibleSchemes => 'যোগ্য প্রকল্পগুলি';

  @override
  String get noSchemesFound => 'কোনো প্রকল্প পাওয়া যায়নি';

  @override
  String get tryUpdatingProfile =>
      'প্রযোজ্য প্রকল্পগুলি দেখতে আপনার প্রোফাইল আপডেট করুন';

  @override
  String get applyNow => 'এখনই আবেদন করুন';

  @override
  String get back => 'ফিরে যান';

  @override
  String get schemeDetails => 'প্রকল্পের বিবরণ';

  @override
  String get eligibilityScore => 'যোগ্যতার স্কোর';

  @override
  String get whyEligible => 'কেন যোগ্য:';

  @override
  String get description => 'বিবরণ';

  @override
  String get requiredDocuments => 'প্রয়োজনীয় নথিপত্র';

  @override
  String get applicationInfo => 'আবেদনের তথ্য';

  @override
  String get ministry => 'মন্ত্রণালয়';

  @override
  String get applyAt => 'এখানে আবেদন করুন';

  @override
  String get visitOfficialWebsite => 'সরকারি ওয়েবসাইট দেখুন';

  @override
  String get documentsNeeded => 'প্রয়োজনীয় নথিপত্র';

  @override
  String get iHaveAllDocuments => 'সব নথি আছে → এখনই আবেদন করুন';

  @override
  String get missingDocuments => 'নথি নেই → পরে সংরক্ষণ করুন';

  @override
  String get howToGet => 'এটি কীভাবে পাবেন';

  @override
  String get findNearestOffice => 'নিকটতম অফিস খুঁজুন';

  @override
  String get shareScheme => 'প্রকল্প শেয়ার করুন';

  @override
  String shareText(
      String name, String benefit, String eligibility, String url) {
    return '$name\nসুবিধা: $benefit\nযোগ্যতা: $eligibility\nআবেদন করুন: $url\n\nAdhikar অ্যাপে পাওয়া গেছে';
  }

  @override
  String get applicationHistory => 'আবেদনের ইতিহাস';

  @override
  String get noApplications => 'এখনো কোনো আবেদন নেই';

  @override
  String get allSchemes => 'সব প্রকল্পগুলি';

  @override
  String get forUser => 'এর জন্য';

  @override
  String get hearResults => 'ফলাফল শুনুন';

  @override
  String get eligible => 'যোগ্য';

  @override
  String get benefits => 'সুবিধা';

  @override
  String get noSchemesMatch => 'কোনো প্রকল্প মেলেনি';

  @override
  String get noSchemesInCategory => 'এই বিভাগে কোনো প্রকল্প নেই';

  @override
  String get statusSubmitted => 'জমা দেওয়া হয়েছে';

  @override
  String get statusUnderReview => 'পর্যালোচনায়';

  @override
  String get statusApproved => 'অনুমোদিত';

  @override
  String get statusRejected => 'প্রত্যাখ্যাত';

  @override
  String submittedDate(String date) {
    return 'জমা দেওয়া হয়েছে: $date';
  }

  @override
  String referenceNumber(String number) {
    return 'রেফারেন্স: $number';
  }

  @override
  String get offlineMessage =>
      'ইন্টারনেট নেই। সংরক্ষিত প্রকল্পগুলো দেখানো হচ্ছে।';

  @override
  String get settings => 'সেটিংস';

  @override
  String get language => 'ভাষা';

  @override
  String get currentLanguage => 'বর্তমান';

  @override
  String get voiceAndSound => 'ভয়েস ও সাউন্ড';

  @override
  String get enableTTS => 'TTS নেরেশন চালু করুন';

  @override
  String get autoPlayResults => 'ফলাফল স্বয়ংক্রিয়ভাবে চালান';

  @override
  String get speechSpeed => 'কথার গতি';

  @override
  String get slow => 'ধীরে';

  @override
  String get normal => 'স্বাভাবিক';

  @override
  String get fast => 'দ্রুত';

  @override
  String get notifications => 'বিজ্ঞপ্তি';

  @override
  String get statusAlerts => 'আবেদনের স্থিতি সতর্কতা';

  @override
  String get documentReminders => 'নথির স্মরণিকা';

  @override
  String get newSchemeAlerts => 'নতুন প্রকল্পের সতর্কতা';

  @override
  String get accessibility => 'অ্যাক্সেসিবিলিটি';

  @override
  String get largeText => 'বড় টেক্সট মোড';

  @override
  String get highContrast => 'হাই কনট্রাস্ট মোড';

  @override
  String get dataPrivacy => 'ডেটা ও গোপনীয়তা';

  @override
  String get exportData => 'আমার ডেটা রপ্তানি করুন';

  @override
  String get deleteAccount => 'অ্যাকাউন্ট মুছুন';

  @override
  String get deleteConfirmTitle => 'অ্যাকাউন্ট মুছবেন?';

  @override
  String get deleteConfirmBody => 'এটি আপনার সমস্ত ডেটা স্থায়ীভাবে মুছে দেবে।';

  @override
  String get confirm => 'নিশ্চিত করুন';

  @override
  String get about => 'সম্পর্কে';

  @override
  String get appVersion => 'অ্যাপ সংস্করণ';

  @override
  String get contactSupport => 'সহায়তায় যোগাযোগ করুন';

  @override
  String get onboarding1Title => 'Adhikar-এ স্বাগতম';

  @override
  String get onboarding1Body =>
      'আপনার প্রাপ্য প্রতিটি সরকারি কল্যাণ প্রকল্প — আপনার ভাষায়।';

  @override
  String get onboarding2Title => 'আপনার পরিস্থিতি বলুন';

  @override
  String get onboarding2Body =>
      'মাইক চাপুন এবং নিজের সম্পর্কে বলুন — বয়স, পেশা, পরিবার, আয়।';

  @override
  String get onboarding2Example =>
      'আমি ৪৫ বছরের বিধবা কৃষক, আমার কাছে ২ একর জমি আছে...';

  @override
  String get onboarding3Title => 'আপনার অধিকার জানুন';

  @override
  String get onboarding3Body =>
      '২০০+ সরকারি প্রকল্প থেকে আপনার জন্য সঠিক প্রকল্পগুলো খুঁজে দিই।';

  @override
  String get onboarding4Title => 'তাৎক্ষণিক আবেদন করুন';

  @override
  String get onboarding4Body =>
      'ফর্ম স্বয়ংক্রিয়ভাবে পূরণ হয়। মানচিত্রে নিকটতম অফিস খুঁজুন।';

  @override
  String get getStarted => 'শুরু করুন';

  @override
  String get skipOnboarding => 'এড়িয়ে যান';

  @override
  String get next => 'পরবর্তী';

  @override
  String get networkError => 'ইন্টারনেট নেই। আবার চেষ্টা করুন।';

  @override
  String get geminiError =>
      'AI পাওয়া যাচ্ছে না। মৌলিক মিলানো ব্যবহার করা হচ্ছে।';

  @override
  String get firebaseError =>
      'সিঙ্ক ব্যর্থ হয়েছে। ডেটা স্থানীয়ভাবে সংরক্ষিত।';

  @override
  String get categoryAll => 'সব';

  @override
  String get categoryAgriculture => 'কৃষি';

  @override
  String get categoryHealth => 'স্বাস্থ্য';

  @override
  String get categoryEducation => 'শিক্ষা';

  @override
  String get categoryHousing => 'আবাসন';

  @override
  String get categoryWomen => 'নারী ও শিশু';

  @override
  String get categoryEmployment => 'কর্মসংস্থান';

  @override
  String get categoryDisability => 'প্রতিবন্ধিতা';

  @override
  String get categorySenior => 'বরিষ্ঠ নাগরিক';

  @override
  String get profileTitle => 'আপনার প্রোফাইল';

  @override
  String get editProfile => 'প্রোফাইল সম্পাদনা করুন';

  @override
  String get name => 'নাম';

  @override
  String get age => 'বয়স';

  @override
  String get gender => 'লিঙ্গ';

  @override
  String get caste => 'জাতি শ্রেণী';

  @override
  String get occupation => 'পেশা';

  @override
  String get income => 'বার্ষিক আয়';

  @override
  String get state => 'রাজ্য';

  @override
  String get district => 'জেলা';

  @override
  String get landOwned => 'জমি (একরে)';

  @override
  String get familySize => 'পরিবারের আকার';

  @override
  String get maritalStatus => 'বৈবাহিক অবস্থা';

  @override
  String get disability => 'প্রতিবন্ধিতা';

  @override
  String get helpButton => 'সাহায্য দরকার?';

  @override
  String get pullToRefresh => 'রিফ্রেশ করতে টানুন';

  @override
  String get aiGreeting =>
      'নমস্কার! আমি অধিকার AI। সরকারি প্রকল্প সম্পর্কে যেকোনো প্রশ্ন করুন।';

  @override
  String get askScheme => 'যেকোনো প্রকল্প সম্পর্কে জিজ্ঞাসা করুন...';

  @override
  String get profileReview => 'প্রোফাইল পর্যালোচনা';

  @override
  String get noProfileData =>
      'প্রোফাইল পাওয়া যায়নি। দয়া করে ফিরে যান এবং আবার বলুন।';

  @override
  String get discover => 'আবিষ্কার করুন';

  @override
  String get schemes => 'প্রকল্পসমূহ';

  @override
  String get aiChat => 'AI চ্যাট';

  @override
  String get history => 'ইতিহাস';

  @override
  String get personalInfo => 'ব্যক্তিগত তথ্য';

  @override
  String get economicInfo => 'অর্থনৈতিক তথ্য';

  @override
  String get socialStatus => 'সামাজিক অবস্থা';

  @override
  String get fieldName => 'নাম';

  @override
  String get fieldAge => 'বয়স';

  @override
  String get fieldGender => 'লিঙ্গ';

  @override
  String get fieldState => 'রাজ্য';

  @override
  String get fieldDistrict => 'জেলা';

  @override
  String get fieldCaste => 'জাতি';

  @override
  String get fieldOccupation => 'পেশা';

  @override
  String get fieldAnnualIncome => 'বার্ষিক আয (₹)';

  @override
  String get fieldLandHolding => 'জমি (একর)';

  @override
  String get fieldFamilySize => 'পরিবারের আকার';

  @override
  String get fieldBplCard => 'BPL কার্ড';

  @override
  String get fieldAadhaar => 'আধার কার্ড';

  @override
  String get fieldBankAccount => 'ব্যাংক অ্যাকাউন্ট';

  @override
  String get fieldWidow => 'বিধবা';

  @override
  String get fieldDisabled => 'প্রতিবন্ধী';

  @override
  String get fieldPregnant => 'গর্ভবতী';

  @override
  String get fieldEducation => 'শিক্ষা';

  @override
  String get findEligibleSchemes => 'যোগ্য প্রকল্প খুঁজুন';

  @override
  String get notDetected => 'সনাক্ত হয়নি';

  @override
  String get members => 'সদস্য';

  @override
  String get acres => 'একর';

  @override
  String get genderMale => 'পুরুষ';

  @override
  String get genderFemale => 'মহিলা';

  @override
  String get occupationFarmer => 'কৃষক';

  @override
  String get occupationStudent => 'ছাত্র';

  @override
  String get occupationDailyWage => 'দিনমজুর';

  @override
  String get occupationBusiness => 'ব্যবসা';

  @override
  String get occupationGovernment => 'সরকারি';

  @override
  String get occupationUnemployed => 'বেকার';

  @override
  String get categoryWomenChild => 'Women & Child';

  @override
  String get share => 'Share';

  @override
  String get documentsReady => 'Documents Ready';

  @override
  String get saveForLater => 'Save for Later';

  @override
  String get applyAnyway => 'Apply Anyway';

  @override
  String get close => 'Close';

  @override
  String get documentsMissing =>
      'documents missing. Gather them before applying.';

  @override
  String get documentsSaved => 'Saved for later — check My Applications';

  @override
  String get documentsYouNeed => 'Documents You Need';

  @override
  String get documentsReadyTitle => 'Documents Ready';

  @override
  String get ofWord => 'of';

  @override
  String get applyNowButton => 'Apply Now ✓';

  @override
  String get visitGovtOffice =>
      'Visit your nearest government office with valid ID proof.';

  @override
  String get fieldMinistry => 'Ministry';
}
