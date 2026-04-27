// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appName => 'અધિકાર';

  @override
  String get tagline => 'તમારો અધિકાર. તમારા દ્વારે.';

  @override
  String get builtForBharat => 'ભારત માટે 🇮🇳';

  @override
  String get poweredByAI => 'AI દ્વારા સંચાલિત, ભારત માટે';

  @override
  String get selectLanguage => 'ભાષા પસંદ કરો';

  @override
  String get chooseLanguage => 'તમારી ભાષા પસંદ કરો';

  @override
  String get continueButton => 'આગળ';

  @override
  String get continueWithEnglish => 'અંગ્રેજીમાં ચાલુ';

  @override
  String get changeLanguage => 'ભાષા બદલો';

  @override
  String languageChanged(String language) {
    return 'ભાષા $language માં બદલાઈ';
  }

  @override
  String get voiceInputTitle => 'તમારી પરિસ્થિતિ જણાવો';

  @override
  String get voiceInputSubtitle => 'તમારા વિશે, પરિવાર, આવક, વ્યવસાય વિશે બોલો';

  @override
  String get transcriptLabel => 'તમારી વાત';

  @override
  String get typeInstead => 'ટાઈપ કરો';

  @override
  String get transcriptHint => 'તમારી વાત અહીં...';

  @override
  String get pleaseSpeak => 'કૃપા કરીને બોલો';

  @override
  String get listening => 'સાંભળી રહ્યા...';

  @override
  String get tapToSpeakAgain => 'ફરી બોલો';

  @override
  String get enterYourInfo => 'માહિતી દાખલ કરો';

  @override
  String get describeHint => 'પરિસ્થિતિ વર્ણવો...';

  @override
  String get cancel => 'રદ';

  @override
  String get save => 'સાચવો';

  @override
  String listeningIn(String language) {
    return 'સાંભળી: $language';
  }

  @override
  String get speakPrompt => 'તમારી પરિસ્થિતિ જણાવો';

  @override
  String get analyzingVoice => 'સમજી રહ્યા...';

  @override
  String get matchingSchemes => 'યોજનાઓ શોધી રહ્યા...';

  @override
  String get generatingForm => 'અરજી તૈયાર...';

  @override
  String schemesFound(int count) {
    return '$count યોજનાઓ';
  }

  @override
  String totalBenefit(String amount) {
    return '₹$amount / વર્ષ';
  }

  @override
  String get totalEstimatedBenefits => 'કુલ અંદાજ';

  @override
  String get eligibleSchemes => 'યોગ્ય યોજનાઓ';

  @override
  String get noSchemesFound => 'કોઈ યોજના ન મળી';

  @override
  String get tryUpdatingProfile =>
      'યોગ્ય યોજનાઓ જોવા માટે તમારી પ્રોફાઇલ અપડેટ કરો';

  @override
  String get applyNow => 'અરજી કરો';

  @override
  String get back => 'પાછા';

  @override
  String get schemeDetails => 'વિગત';

  @override
  String get eligibilityScore => 'સ્કોર';

  @override
  String get whyEligible => 'કારણ:';

  @override
  String get description => 'વર્ણન';

  @override
  String get requiredDocuments => 'દસ્તાવેજો';

  @override
  String get applicationInfo => 'અરજી';

  @override
  String get ministry => 'મંત્રાલય';

  @override
  String get applyAt => 'ક્યાં';

  @override
  String get visitOfficialWebsite => 'વેબસાઇટ';

  @override
  String get documentsNeeded => 'જરૂરી દસ્તાવેજો';

  @override
  String get iHaveAllDocuments => 'દસ્તાવેજ છે → અરજી';

  @override
  String get missingDocuments => 'દસ્તાવેજ નથી → સાચવો';

  @override
  String get howToGet => 'કેવી રીતે';

  @override
  String get findNearestOffice => 'નજીકી ઓફિસ';

  @override
  String get shareScheme => 'શેર';

  @override
  String shareText(
      String name, String benefit, String eligibility, String url) {
    return '$name\nલાભ: $benefit\nપાત્રતા: $eligibility\nઅરજી: $url\n\nAdhikar app';
  }

  @override
  String get applicationHistory => 'ઇતિહાસ';

  @override
  String get noApplications => 'અરજી નથી';

  @override
  String get allSchemes => 'બધી યોજનાઓ';

  @override
  String get forUser => 'માટે';

  @override
  String get hearResults => 'પરિણામ સાંભળો';

  @override
  String get eligible => 'યોગ્ય';

  @override
  String get benefits => 'લાભો';

  @override
  String get noSchemesMatch => 'કોઈ યોજના બંધબેસતી નથી';

  @override
  String get noSchemesInCategory => 'આ શ્રેણીમાં કોઈ યોજના નથી';

  @override
  String get statusSubmitted => 'સબમિટ';

  @override
  String get statusUnderReview => 'સમીક્ષા';

  @override
  String get statusApproved => 'મંજૂર';

  @override
  String get statusRejected => 'નામંજૂર';

  @override
  String submittedDate(String date) {
    return 'સબમિટ: $date';
  }

  @override
  String referenceNumber(String number) {
    return 'Ref: $number';
  }

  @override
  String get offlineMessage => 'ઇન્ટરનેટ નથી.';

  @override
  String get settings => 'સેટિંગ્સ';

  @override
  String get language => 'ભાષા';

  @override
  String get currentLanguage => 'વર્તમાન';

  @override
  String get voiceAndSound => 'અવાજ';

  @override
  String get enableTTS => 'TTS ચાલુ';

  @override
  String get autoPlayResults => 'ઓટો';

  @override
  String get speechSpeed => 'ઝડપ';

  @override
  String get slow => 'ધીમી';

  @override
  String get normal => 'સામાન્ય';

  @override
  String get fast => 'ઝડપી';

  @override
  String get notifications => 'સૂચનાઓ';

  @override
  String get statusAlerts => 'સ્થિતિ';

  @override
  String get documentReminders => 'દસ્તાવેજ';

  @override
  String get newSchemeAlerts => 'નવી';

  @override
  String get accessibility => 'સુલભ';

  @override
  String get largeText => 'મોટો ટેક્સ્ટ';

  @override
  String get highContrast => 'કોન્ટ્રાસ્ટ';

  @override
  String get dataPrivacy => 'ગોપનીયતા';

  @override
  String get exportData => 'ડેટા નિકાસ';

  @override
  String get deleteAccount => 'ખાતું ભૂંસો';

  @override
  String get deleteConfirmTitle => 'ભૂંસવું?';

  @override
  String get deleteConfirmBody => 'ડેટા કાયમ ભૂંસાશે.';

  @override
  String get confirm => 'હા';

  @override
  String get about => 'વિશે';

  @override
  String get appVersion => 'વર્ઝન';

  @override
  String get contactSupport => 'સંપર્ક';

  @override
  String get onboarding1Title => 'Adhikar માં સ્વાગત';

  @override
  String get onboarding1Body => 'તમારી ભાષામાં સરકારી યોજનાઓ.';

  @override
  String get onboarding2Title => 'બોલો';

  @override
  String get onboarding2Body => 'માઇક દાબો ને ઉંમર, કામ, પરિવાર, આવક જણાવો.';

  @override
  String get onboarding2Example => 'હું 45 વર્ષની વિધવા ખેડૂત, 2 એકર જમીન...';

  @override
  String get onboarding3Title => 'અધિકારો';

  @override
  String get onboarding3Body => '200+ યોજનાઓ.';

  @override
  String get onboarding4Title => 'અરજી';

  @override
  String get onboarding4Body => 'ફોર્મ ભરાઈ જાય. ઓફિસ શોધો.';

  @override
  String get getStarted => 'શરૂ';

  @override
  String get skipOnboarding => 'છોડો';

  @override
  String get next => 'આગળ';

  @override
  String get networkError => 'ઇન્ટરનેટ નથી.';

  @override
  String get geminiError => 'AI નથી.';

  @override
  String get firebaseError => 'સ્ ‌‌  ‌.';

  @override
  String get categoryAll => 'બધા';

  @override
  String get categoryAgriculture => 'કૃષિ';

  @override
  String get categoryHealth => 'સ્વાસ્થ્ય';

  @override
  String get categoryEducation => 'શિક્ષણ';

  @override
  String get categoryHousing => 'આવાસ';

  @override
  String get categoryWomen => 'મહિલા';

  @override
  String get categoryEmployment => 'રોજગાર';

  @override
  String get categoryDisability => 'વિકલાંગ';

  @override
  String get categorySenior => 'વૃ‌ ‌';

  @override
  String get profileTitle => 'પ્રોફાઇલ';

  @override
  String get editProfile => 'ફેરફ‌ ‌';

  @override
  String get name => 'નામ';

  @override
  String get age => 'ઉ‌ ‌';

  @override
  String get gender => '‌ ‌';

  @override
  String get caste => '‌ ‌';

  @override
  String get occupation => '‌ ‌';

  @override
  String get income => '‌ ‌';

  @override
  String get state => '‌ ‌';

  @override
  String get district => '‌ ‌';

  @override
  String get landOwned => '‌ ‌';

  @override
  String get familySize => '‌ ‌';

  @override
  String get maritalStatus => '‌ ‌';

  @override
  String get disability => '‌ ‌';

  @override
  String get helpButton => '‌ ‌';

  @override
  String get pullToRefresh => 'રિફ્રેશ કરવા ટાંકો';

  @override
  String get aiGreeting =>
      'નમસ્તે! હું અધિકાર AI છું. સરકારી યોજનાઓ વિશે કંઈ પણ પૂછો.';

  @override
  String get askScheme => 'કોઈપણ યોજના વિશે પૂછો...';

  @override
  String get profileReview => 'પ્રોફાઇલ સમીક્ષા';

  @override
  String get noProfileData =>
      'પ્રોફાઇલ મળી નથી. કૃપા કરીને પાછા જાઓ અને ફરી બોલો.';

  @override
  String get discover => 'શોધો';

  @override
  String get schemes => 'યોજનાઓ';

  @override
  String get aiChat => 'AI ચેટ';

  @override
  String get history => 'ઇતિહાસ';

  @override
  String get personalInfo => 'વ્યક્તિગત માહિતી';

  @override
  String get economicInfo => 'આર્થિક માહિતી';

  @override
  String get socialStatus => 'સામાજિક સ્થિતિ';

  @override
  String get fieldName => 'નામ';

  @override
  String get fieldAge => 'વય';

  @override
  String get fieldGender => 'લિંગ';

  @override
  String get fieldState => 'રાજ્ય';

  @override
  String get fieldDistrict => 'જિલ્લો';

  @override
  String get fieldCaste => 'જાતિ';

  @override
  String get fieldOccupation => 'વ્યવસાય';

  @override
  String get fieldAnnualIncome => 'વાર્ષિક આવક (₹)';

  @override
  String get fieldLandHolding => 'જમીન (એકર)';

  @override
  String get fieldFamilySize => 'કુટુંબનું કદ';

  @override
  String get fieldBplCard => 'BPL કાર્ડ';

  @override
  String get fieldAadhaar => 'આધાર કાર્ડ';

  @override
  String get fieldBankAccount => 'બેંક ખાતું';

  @override
  String get fieldWidow => 'વિધવા';

  @override
  String get fieldDisabled => 'દિવ્યાંગ';

  @override
  String get fieldPregnant => 'ગર્ભવતી';

  @override
  String get fieldEducation => 'શિક્ષણ';

  @override
  String get findEligibleSchemes => 'યોગ્ય યોજનાઓ શોધો';

  @override
  String get notDetected => 'મળ્યું નથી';

  @override
  String get members => 'સભ્યો';

  @override
  String get acres => 'એકર';

  @override
  String get genderMale => 'પુરુષ';

  @override
  String get genderFemale => 'સ્ત્રી';

  @override
  String get occupationFarmer => 'ખેડૂત';

  @override
  String get occupationStudent => 'વિદ્યાર્થી';

  @override
  String get occupationDailyWage => 'દૈનિક મજૂર';

  @override
  String get occupationBusiness => 'વ્યવસાય';

  @override
  String get occupationGovernment => 'સરકારી';

  @override
  String get occupationUnemployed => 'બેરોજગાર';

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
  String get of => 'of';

  @override
  String get applyNowButton => 'Apply Now ✓';

  @override
  String get visitGovtOffice =>
      'Visit your nearest government office with valid ID proof.';

  @override
  String get fieldMinistry => 'Ministry';
}
