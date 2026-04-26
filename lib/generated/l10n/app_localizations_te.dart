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
  String get eligibleSchemes => 'అర్హత పొందిన పథకాలు';

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
  String get applicationHistory => 'దరఖాస్తు చరిత్ర';

  @override
  String get noApplications => 'ఇంకా దరఖాస్తులు లేవు. ఇప్పుడే కనుగొనండి!';

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
  String get language => 'భాష';

  @override
  String get currentLanguage => 'ప్రస్తుత';

  @override
  String get voiceAndSound => 'వాయిస్ మరియు సౌండ్';

  @override
  String get enableTTS => 'TTS నేరేషన్ ఎనేబుల్ చేయండి';

  @override
  String get autoPlayResults => 'ఫలితాలను ఆటోప్లే చేయండి';

  @override
  String get speechSpeed => 'మాట్లాడే వేగం';

  @override
  String get slow => 'నెమ్మదిగా';

  @override
  String get normal => 'సాధారణ';

  @override
  String get fast => 'వేగంగా';

  @override
  String get notifications => 'నోటిఫికేషన్‌లు';

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
}
