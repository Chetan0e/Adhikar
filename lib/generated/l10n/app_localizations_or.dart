// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Oriya (`or`).
class AppLocalizationsOr extends AppLocalizations {
  AppLocalizationsOr([String locale = 'or']) : super(locale);

  @override
  String get appName => 'ଅଧିକାର';

  @override
  String get tagline => 'ଆପଣଙ୍କ ଅଧିକାର। ଆପଣଙ୍କ ଦ୍ୱାରରେ।';

  @override
  String get builtForBharat => 'ଭାରତ ପାଇଁ ନିର୍ମିତ 🇮🇳';

  @override
  String get poweredByAI => 'ଭାରତ ପାଇଁ AI ଦ୍ୱାରା ଚାଳିତ';

  @override
  String get selectLanguage => 'ଭାଷା ଚୟନ କରନ୍ତୁ';

  @override
  String get chooseLanguage => 'ଆପଣଙ୍କ ଭାଷା ବାଛନ୍ତୁ';

  @override
  String get continueButton => 'ଆଗକୁ';

  @override
  String get continueWithEnglish => 'ଇଂରେଜୀରେ ଆଗକୁ';

  @override
  String get changeLanguage => 'ଭାଷା ବଦଳାନ୍ତୁ';

  @override
  String languageChanged(String language) {
    return 'ଭାଷା $language ରେ ବଦଳି ଗଲା';
  }

  @override
  String get voiceInputTitle => 'ଆପଣଙ୍କ ସ୍ଥିତି କହନ୍ତୁ';

  @override
  String get voiceInputSubtitle =>
      'ନିଜ ବିଷୟରେ, ପରିବାର, ଆୟ, ଚାକିରି ବିଷୟରେ କୁହନ୍ତୁ';

  @override
  String get transcriptLabel => 'ଆପଣଙ୍କ କଥା';

  @override
  String get typeInstead => 'ଟାଇପ୍ କରନ୍ତୁ';

  @override
  String get transcriptHint => 'ଆପଣଙ୍କ କଥା ଏଠି...';

  @override
  String get pleaseSpeak => 'ଦୟାକରି କୁହନ୍ତୁ';

  @override
  String get listening => 'ଶୁଣୁଛୁ...';

  @override
  String get tapToSpeakAgain => 'ପୁଣି କୁହନ୍ତୁ';

  @override
  String get enterYourInfo => 'ସୂଚନା ଦିଅନ୍ତୁ';

  @override
  String get describeHint => 'ସ୍ଥିତି ବର୍ଣ୍ଣନା...';

  @override
  String get cancel => 'ବାତିଲ';

  @override
  String get save => 'ସଂରକ୍ଷଣ';

  @override
  String listeningIn(String language) {
    return 'ଶୁଣୁଛୁ: $language';
  }

  @override
  String get speakPrompt => 'ଆପଣଙ୍କ ସ୍ଥିତି କୁହନ୍ତୁ';

  @override
  String get analyzingVoice => 'ବୁଝୁଛୁ...';

  @override
  String get matchingSchemes => 'ଯୋଜନା ଖୋଜୁଛୁ...';

  @override
  String get generatingForm => 'ଆବେଦନ ପ୍ରସ୍ତୁତ...';

  @override
  String schemesFound(int count) {
    return '$count ଯୋଜନା';
  }

  @override
  String totalBenefit(String amount) {
    return '₹$amount / ବର୍ଷ';
  }

  @override
  String get totalEstimatedBenefits => 'ମୋଟ ଲାଭ';

  @override
  String get eligibleSchemes => 'ଯୋଗ୍ୟ ଯୋଜନା';

  @override
  String get noSchemesFound => 'ଯୋଜନା ମିଳିଲା ନାହିଁ';

  @override
  String get tryUpdatingProfile => 'ପ୍ରୋଫାଇଲ ଅଦ୍ୟତନ';

  @override
  String get applyNow => 'ଆବେଦନ';

  @override
  String get back => 'ଫେରନ୍ତୁ';

  @override
  String get schemeDetails => 'ଯୋଜନା ବିବରଣ';

  @override
  String get eligibilityScore => 'ସ୍କୋର';

  @override
  String get whyEligible => 'କାରଣ:';

  @override
  String get description => 'ବିବରଣ';

  @override
  String get requiredDocuments => 'ଦଲିଲ';

  @override
  String get applicationInfo => 'ଆବେଦନ';

  @override
  String get ministry => 'ମନ୍ତ୍ରଣାଳୟ';

  @override
  String get applyAt => 'ଏଠୁ ଆବେଦନ';

  @override
  String get visitOfficialWebsite => 'ୱେବସାଇଟ';

  @override
  String get documentsNeeded => 'ଆବଶ୍ୟକ ଦଲିଲ';

  @override
  String get iHaveAllDocuments => 'ଦଲିଲ ଅଛି → ଆବେଦନ';

  @override
  String get missingDocuments => 'ଦଲିଲ ନାହିଁ → ସଂରକ୍ଷଣ';

  @override
  String get howToGet => 'କିପରି';

  @override
  String get findNearestOffice => 'ନିକଟ ଅଫିସ';

  @override
  String get shareScheme => 'ଶେୟାର';

  @override
  String shareText(
      String name, String benefit, String eligibility, String url) {
    return '$name\nଲାଭ: $benefit\nଯୋଗ୍ୟ: $eligibility\nଆବେଦନ: $url\n\nAdhikar app';
  }

  @override
  String get applicationHistory => 'ଇତିହାସ';

  @override
  String get noApplications => 'ଆବେଦନ ନାହିଁ!';

  @override
  String get statusSubmitted => 'ଦାଖଲ';

  @override
  String get statusUnderReview => 'ସମୀକ୍ଷା';

  @override
  String get statusApproved => 'ଅନୁମୋଦିତ';

  @override
  String get statusRejected => 'ପ୍ରତ୍ୟାଖ୍ୟାତ';

  @override
  String submittedDate(String date) {
    return 'ଦାଖଲ: $date';
  }

  @override
  String referenceNumber(String number) {
    return 'Ref: $number';
  }

  @override
  String get offlineMessage => 'ଇଣ୍ଟରନେଟ ନାହିଁ।';

  @override
  String get settings => 'ସେଟିଂ';

  @override
  String get language => 'ଭାଷା';

  @override
  String get currentLanguage => 'ଏବେ';

  @override
  String get voiceAndSound => 'ଶବ୍ଦ';

  @override
  String get enableTTS => 'TTS';

  @override
  String get autoPlayResults => 'ଅଟୋ';

  @override
  String get speechSpeed => 'ଗତି';

  @override
  String get slow => 'ଧୀର';

  @override
  String get normal => 'ସ୍ୱାଭାବିକ';

  @override
  String get fast => 'ଦ୍ରୁତ';

  @override
  String get notifications => 'ବିଜ୍ଞପ୍ତି';

  @override
  String get statusAlerts => 'ସ୍ଥିତି';

  @override
  String get documentReminders => 'ଦଲିଲ';

  @override
  String get newSchemeAlerts => 'ନୂଆ';

  @override
  String get accessibility => 'ପ୍ରବେଶ';

  @override
  String get largeText => 'ବଡ ଟେକ୍ସଟ';

  @override
  String get highContrast => 'କଣ୍ଟ୍ରାସ୍ଟ';

  @override
  String get dataPrivacy => 'ଗୋପନୀୟ';

  @override
  String get exportData => 'ଡେଟା';

  @override
  String get deleteAccount => 'ଡିଲିଟ';

  @override
  String get deleteConfirmTitle => 'ଡିଲିଟ?';

  @override
  String get deleteConfirmBody => 'ସମସ୍ତ ଡେଟା ଯିବ।';

  @override
  String get confirm => 'ହଁ';

  @override
  String get about => 'ବିଷୟ';

  @override
  String get appVersion => 'ସଂସ୍କରଣ';

  @override
  String get contactSupport => 'ସମ୍ପର୍କ';

  @override
  String get onboarding1Title => 'Adhikar ରେ ସ୍ୱାଗତ';

  @override
  String get onboarding1Body => 'ଆପଣଙ୍କ ଭାଷାରେ ସରକାରୀ ଯୋଜନା।';

  @override
  String get onboarding2Title => 'କୁହନ୍ତୁ';

  @override
  String get onboarding2Body => 'ମାଇକ ଦାବି ବୟସ, ଚାକିରି, ପରିବାର, ଆୟ କୁହନ୍ତୁ।';

  @override
  String get onboarding2Example => 'ମୁଁ 45 ବର୍ଷ ଉଇ ବିଧବା ଚାଷୀ, 2 ଏକର ଜମି...';

  @override
  String get onboarding3Title => 'ଅଧିକାର';

  @override
  String get onboarding3Body => '200+ ଯୋଜନା।';

  @override
  String get onboarding4Title => 'ଆବେଦନ';

  @override
  String get onboarding4Body => 'ଫର୍ମ ଭରା ହୁଏ। ଅଫିସ ଖୋଜ।';

  @override
  String get getStarted => 'ଆରମ୍ଭ';

  @override
  String get skipOnboarding => 'ଛାଡ';

  @override
  String get next => 'ଆଗ';

  @override
  String get networkError => 'ଇଣ୍ଟରନେଟ ନାହିଁ।';

  @override
  String get geminiError => 'AI ନାହିଁ।';

  @override
  String get firebaseError => 'ସିଙ୍କ ଫେଲ।';

  @override
  String get categoryAll => 'ସବୁ';

  @override
  String get categoryAgriculture => 'କୃଷି';

  @override
  String get categoryHealth => 'ସ୍ୱାସ୍ଥ୍ୟ';

  @override
  String get categoryEducation => 'ଶିକ୍ଷା';

  @override
  String get categoryHousing => 'ଗୃହ';

  @override
  String get categoryWomen => 'ମହିଳା';

  @override
  String get categoryEmployment => 'ରୋଜଗାର';

  @override
  String get categoryDisability => 'ଅକ୍ଷମ';

  @override
  String get categorySenior => 'ବୟସ୍କ';

  @override
  String get profileTitle => 'ପ୍ରୋଫାଇଲ';

  @override
  String get editProfile => 'ସଂପାଦନ';

  @override
  String get name => 'ନାମ';

  @override
  String get age => 'ବୟସ';

  @override
  String get gender => 'ଲିଙ୍ଗ';

  @override
  String get caste => 'ଜାତି';

  @override
  String get occupation => 'ଚାକିରି';

  @override
  String get income => 'ଆୟ';

  @override
  String get state => 'ରାଜ୍ୟ';

  @override
  String get district => 'ଜିଲ୍ଲା';

  @override
  String get landOwned => 'ଜମି';

  @override
  String get familySize => 'ପରିବାର';

  @override
  String get maritalStatus => 'ବୈବାହିକ';

  @override
  String get disability => 'ଅକ୍ଷମ';

  @override
  String get helpButton => 'ସାହାଯ୍ୟ?';

  @override
  String get pullToRefresh => 'ରିଫ୍ରେଶ';

  @override
  String get aiGreeting =>
      'ନମସ୍କାର! ମୁଁ ଅଧିକାର AI। ସରକାରୀ ଯୋଜନା ବିଷୟରେ କିଛି ପଚାର କରନ୍ତୁ।';

  @override
  String get askScheme => 'କୌଣସି ଯୋଜନା ବିଷୟରେ ପଚାର କରନ୍ତୁ...';

  @override
  String get profileReview => 'ପ୍ରୋଫାଇଲ ସମୀକ୍ଷା';

  @override
  String get noProfileData =>
      'ପ୍ରୋଫାଇଲ ମିଳିଲା ନାହିଁ। ଦୟାକରି ଫେରନ୍ତୁ ଏବଂ ପୁଣି କୁହନ୍ତୁ।';

  @override
  String get discover => 'ଖୋଜନ୍ତୁ';

  @override
  String get schemes => 'ଯୋଜନା';

  @override
  String get aiChat => 'AI ଚାଟ୍';

  @override
  String get history => 'ଇତିହାସ';
}
