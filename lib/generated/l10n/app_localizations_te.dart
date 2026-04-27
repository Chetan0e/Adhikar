// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appName => 'అధికార్';

  @override
  String get tagline => 'మీ హక్కు. మీ గుమ్మం వద్దకు.';

  @override
  String get builtForBharat => 'భారత్ కోసం నిర్మించబడింది 🇮🇳';

  @override
  String get poweredByAI => 'భారత్ కోసం AI చేత నడపబడుతోంది';

  @override
  String get selectLanguage => 'భాష ఎంచుకోండి';

  @override
  String get chooseLanguage => 'మీ భాషను ఎంచుకోండి';

  @override
  String get continueButton => 'కొనసాగించు';

  @override
  String get continueWithEnglish => 'ఆంగ్లంలో కొనసాగించు';

  @override
  String get changeLanguage => 'భాష మార్చు';

  @override
  String languageChanged(String language) {
    return 'భాష $language కి మార్చబడింది';
  }

  @override
  String get voiceInputTitle => 'మీ పరిస్థితి చెప్పండి';

  @override
  String get voiceInputSubtitle =>
      'మీ గురించి, కుటుంబం, ఆదాయం, వృత్తి గురించి మాట్లాడండి';

  @override
  String get transcriptLabel => 'మీ మాటలు';

  @override
  String get typeInstead => 'మాట్లాడే బదులు టైప్ చేయండి';

  @override
  String get transcriptHint => 'మీ మాటలు ఇక్కడ కనిపిస్తాయి...';

  @override
  String get pleaseSpeak => 'దయచేసి మాట్లాడండి లేదా టైప్ చేయండి';

  @override
  String get listening => 'వింటున్నాం...';

  @override
  String get tapToSpeakAgain => 'మళ్ళీ మాట్లాడటానికి నొక్కండి';

  @override
  String get enterYourInfo => 'మీ సమాచారాన్ని నమోదు చేయండి';

  @override
  String get describeHint => 'మీ పరిస్థితిని వివరించండి...';

  @override
  String get cancel => 'రద్దు చేయి';

  @override
  String get save => 'సేవ్ చేయి';

  @override
  String listeningIn(String language) {
    return 'వింటున్నాం: $language లో';
  }

  @override
  String get speakPrompt => 'దయచేసి మీ పరిస్థితిని మీ మాటల్లో చెప్పండి';

  @override
  String get analyzingVoice => 'మీ పరిస్థితిని అర్థం చేసుకుంటున్నాం...';

  @override
  String get matchingSchemes => 'మీ పథకాలను వెతుకుతున్నాం...';

  @override
  String get generatingForm => 'మీ దరఖాస్తును సిద్ధం చేస్తున్నాం...';

  @override
  String schemesFound(int count) {
    return '$count పథకాలు కనుగొనబడ్డాయి';
  }

  @override
  String totalBenefit(String amount) {
    return '₹$amount / సంవత్సరం';
  }

  @override
  String get totalEstimatedBenefits => 'మొత్తం అంచనా ప్రయోజనాలు';

  @override
  String get eligibleSchemes => 'అర్హమైన పథకాలు';

  @override
  String get noSchemesFound => 'ఏ పథకాలూ కనుగొనబడలేదు';

  @override
  String get tryUpdatingProfile => 'మీ ప్రొఫైల్ సమాచారాన్ని నవీకరించండి';

  @override
  String get applyNow => 'ఇప్పుడే దరఖాస్తు చేయండి';

  @override
  String get back => 'వెనుకకు';

  @override
  String get schemeDetails => 'పథకం వివరాలు';

  @override
  String get eligibilityScore => 'అర్హత స్కోరు';

  @override
  String get whyEligible => 'ఎందుకు అర్హులు:';

  @override
  String get description => 'వివరణ';

  @override
  String get requiredDocuments => 'అవసరమైన పత్రాలు';

  @override
  String get applicationInfo => 'దరఖాస్తు సమాచారం';

  @override
  String get ministry => 'మంత్రిత్వ శాఖ';

  @override
  String get applyAt => 'ఇక్కడ దరఖాస్తు చేయండి';

  @override
  String get visitOfficialWebsite => 'అధికారిక వెబ్‌సైట్ సందర్శించండి';

  @override
  String get documentsNeeded => 'అవసరమైన పత్రాలు';

  @override
  String get iHaveAllDocuments =>
      'అన్ని పత్రాలు ఉన్నాయి → ఇప్పుడే దరఖాస్తు చేయండి';

  @override
  String get missingDocuments => 'పత్రాలు లేవు → తర్వాత కోసం సేవ్ చేయండి';

  @override
  String get howToGet => 'దీన్ని ఎలా పొందాలి';

  @override
  String get findNearestOffice => 'సమీప కార్యాలయాన్ని కనుగొనండి';

  @override
  String get shareScheme => 'పథకాన్ని పంచుకోండి';

  @override
  String shareText(
      String name, String benefit, String eligibility, String url) {
    return '$name\nప్రయోజనం: $benefit\nఅర్హత: $eligibility\nదరఖాస్తు చేయండి: $url\n\nAdhikar app ద్వారా కనుగొనబడింది';
  }

  @override
  String get applicationHistory => 'అప్లికేషన్ చరిత్ర';

  @override
  String get noApplications => 'అప్లికేషన్లు లేవు';

  @override
  String get allSchemes => 'అన్ని పథకాలు';

  @override
  String get forUser => 'కోసం';

  @override
  String get hearResults => 'ఫలితాలను వినండి';

  @override
  String get eligible => 'అర్హత';

  @override
  String get benefits => 'ప్రయోజనలు';

  @override
  String get noSchemesMatch => 'సరిపోలే పథకాలు లేవు';

  @override
  String get noSchemesInCategory => 'ఈ వర్గంలో పథకాలు లేవు';

  @override
  String get statusSubmitted => 'సమర్పించబడింది';

  @override
  String get statusUnderReview => 'సమీక్షలో';

  @override
  String get statusApproved => 'ఆమోదించబడింది';

  @override
  String get statusRejected => 'తిరస్కరించబడింది';

  @override
  String submittedDate(String date) {
    return 'సమర్పించబడింది: $date';
  }

  @override
  String referenceNumber(String number) {
    return 'రెఫరెన్స్: $number';
  }

  @override
  String get offlineMessage =>
      'ఇంటర్నెట్ లేదు. సేవ్ చేసిన పథకాలు చూపిస్తున్నాం.';

  @override
  String get settings => 'సెట్టింగ్‌లు';

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
  String get statusAlerts => 'దరఖాస్తు స్థితి హెచ్చరికలు';

  @override
  String get documentReminders => 'పత్రం రిమైండర్లు';

  @override
  String get newSchemeAlerts => 'కొత్త పథకం హెచ్చరికలు';

  @override
  String get accessibility => 'యాక్సెసిబిలిటీ';

  @override
  String get largeText => 'పెద్ద టెక్స్ట్ మోడ్';

  @override
  String get highContrast => 'అధిక కాంట్రాస్ట్ మోడ్';

  @override
  String get dataPrivacy => 'డేటా మరియు గోప్యత';

  @override
  String get exportData => 'నా డేటాను ఎక్స్‌పోర్ట్ చేయండి';

  @override
  String get deleteAccount => 'ఖాతాను తొలగించు';

  @override
  String get deleteConfirmTitle => 'ఖాతాను తొలగించాలా?';

  @override
  String get deleteConfirmBody =>
      'ఇది మీ అన్ని డేటాను శాశ్వతంగా తొలగిస్తుంది. ఈ చర్యను రద్దు చేయలేరు.';

  @override
  String get confirm => 'నిర్ధారించు';

  @override
  String get about => 'గురించి';

  @override
  String get appVersion => 'యాప్ వెర్షన్';

  @override
  String get contactSupport => 'సపోర్ట్‌ను సంప్రదించండి';

  @override
  String get onboarding1Title => 'Adhikar కి స్వాగతం';

  @override
  String get onboarding1Body =>
      'మీకు రావాల్సిన ప్రతి ప్రభుత్వ సంక్షేమ పథకం — మీ భాషలో.';

  @override
  String get onboarding2Title => 'మీ పరిస్థితి చెప్పండి';

  @override
  String get onboarding2Body =>
      'మైక్ నొక్కి మీ గురించి చెప్పండి — వయసు, వృత్తి, కుటుంబం, ఆదాయం.';

  @override
  String get onboarding2Example =>
      'నేను 45 సంవత్సరాల వితంతువు రైతు, నా దగ్గర 2 ఎకరాల భూమి ఉంది...';

  @override
  String get onboarding3Title => 'మీ హక్కులు తెలుసుకోండి';

  @override
  String get onboarding3Body =>
      '200+ ప్రభుత్వ పథకాల నుండి మీకు సరైన పథకాలను కనుగొంటాం.';

  @override
  String get onboarding4Title => 'తక్షణమే దరఖాస్తు చేయండి';

  @override
  String get onboarding4Body =>
      'ఫారాలు స్వయంచాలకంగా నింపబడతాయి. మ్యాప్‌లో సమీప కార్యాలయాన్ని కనుగొనండి.';

  @override
  String get getStarted => 'ప్రారంభించు';

  @override
  String get skipOnboarding => 'దాటవేయి';

  @override
  String get next => 'తదుపరి';

  @override
  String get networkError => 'ఇంటర్నెట్ లేదు. మళ్ళీ ప్రయత్నించండి.';

  @override
  String get geminiError =>
      'AI అందుబాటులో లేదు. ప్రాథమిక మ్యాచింగ్ ఉపయోగిస్తున్నాం.';

  @override
  String get firebaseError =>
      'సింక్ విఫలమైంది. డేటా స్థానికంగా సేవ్ చేయబడింది.';

  @override
  String get categoryAll => 'అన్నీ';

  @override
  String get categoryAgriculture => 'వ్యవసాయం';

  @override
  String get categoryHealth => 'ఆరోగ్యం';

  @override
  String get categoryEducation => 'విద్య';

  @override
  String get categoryHousing => 'గృహనిర్మాణం';

  @override
  String get categoryWomen => 'మహిళలు మరియు శిశువు';

  @override
  String get categoryEmployment => 'ఉపాధి';

  @override
  String get categoryDisability => 'వికలాంగత';

  @override
  String get categorySenior => 'వృద్ధ పౌరులు';

  @override
  String get profileTitle => 'మీ ప్రొఫైల్';

  @override
  String get editProfile => 'ప్రొఫైల్ సవరించు';

  @override
  String get name => 'పేరు';

  @override
  String get age => 'వయసు';

  @override
  String get gender => 'లింగం';

  @override
  String get caste => 'కులం వర్గం';

  @override
  String get occupation => 'వృత్తి';

  @override
  String get income => 'వార్షిక ఆదాయం';

  @override
  String get state => 'రాష్ట్రం';

  @override
  String get district => 'జిల్లా';

  @override
  String get landOwned => 'భూమి (ఎకరాల్లో)';

  @override
  String get familySize => 'కుటుంబ పరిమాణం';

  @override
  String get maritalStatus => 'వైవాహిక స్థితి';

  @override
  String get disability => 'వికలాంగత';

  @override
  String get helpButton => 'సహాయం కావాలా?';

  @override
  String get pullToRefresh => 'రిఫ్రెష్ చేయడానికి లాగండి';

  @override
  String get aiGreeting =>
      'నమస్కారం! నేను అధికార్ AI. ప్రభుత్వ పథకాల గురించి ఏదైనా అడగండి.';

  @override
  String get askScheme => 'ఏదైనా పథకం గురించి అడగండి...';

  @override
  String get profileReview => 'ప్రొఫైల్ సమీక్ష';

  @override
  String get noProfileData =>
      'ప్రొఫైల్ కనుగొనబడలేదు. దయచేసి వెనుకకు వెళ్లి మళ్ళీ మాట్లాడండి.';

  @override
  String get discover => 'కనుగొనండి';

  @override
  String get schemes => 'పథకాలు';

  @override
  String get aiChat => 'AI చాట్';

  @override
  String get history => 'చరిత్ర';

  @override
  String get personalInfo => 'వ్యక్తిగత సమాచారం';

  @override
  String get economicInfo => 'ఆర్థిక సమాచారం';

  @override
  String get socialStatus => 'సామాజిక స్థితి';

  @override
  String get fieldName => 'పేరు';

  @override
  String get fieldAge => 'వయస్సు';

  @override
  String get fieldGender => 'లింగం';

  @override
  String get fieldState => 'రాష్ట్రం';

  @override
  String get fieldDistrict => 'జిల్లా';

  @override
  String get fieldCaste => 'కులం';

  @override
  String get fieldOccupation => 'వృత్తి';

  @override
  String get fieldAnnualIncome => 'వార్షిక ఆదాయం (₹)';

  @override
  String get fieldLandHolding => 'భూమి (ఎకరాలు)';

  @override
  String get fieldFamilySize => 'కుటుంబ పరిమాణం';

  @override
  String get fieldBplCard => 'BPL కార్డు';

  @override
  String get fieldAadhaar => 'ఆధార్ కార్డు';

  @override
  String get fieldBankAccount => 'బ్యాంక్ ఖాతా';

  @override
  String get fieldWidow => 'వితంతువు';

  @override
  String get fieldDisabled => 'వికలాంగులు';

  @override
  String get fieldPregnant => 'గర్భవతి';

  @override
  String get fieldEducation => 'విద్య';

  @override
  String get findEligibleSchemes => 'అర్హమైన పథకాలను కనుగొనండి';

  @override
  String get notDetected => 'కనుగొనబడలేదు';

  @override
  String get members => 'సభ్యులు';

  @override
  String get acres => 'ఎకరాలు';

  @override
  String get genderMale => 'పురుషుడు';

  @override
  String get genderFemale => 'స్త్రీ';

  @override
  String get occupationFarmer => 'రైతు';

  @override
  String get occupationStudent => 'విద్యార్థి';

  @override
  String get occupationDailyWage => 'రోజువారీ కూలీ';

  @override
  String get occupationBusiness => 'వ్యాపారం';

  @override
  String get occupationGovernment => 'ప్రభుత్వం';

  @override
  String get occupationUnemployed => 'నిరుద్యోగం';

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
