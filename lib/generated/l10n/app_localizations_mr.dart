// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appName => 'अधिकार';

  @override
  String get tagline => 'तुमचा हक्क. तुमच्या दारापर्यंत.';

  @override
  String get builtForBharat => 'भारतासाठी बनवले 🇮🇳';

  @override
  String get poweredByAI => 'भारतासाठी AI द्वारे संचालित';

  @override
  String get selectLanguage => 'भाषा निवडा';

  @override
  String get chooseLanguage => 'तुमची भाषा निवडा';

  @override
  String get continueButton => 'पुढे जा';

  @override
  String get continueWithEnglish => 'इंग्रजीत पुढे जा';

  @override
  String get changeLanguage => 'भाषा बदला';

  @override
  String languageChanged(String language) {
    return 'भाषा $language वर बदलली';
  }

  @override
  String get voiceInputTitle => 'तुमची परिस्थिती सांगा';

  @override
  String get voiceInputSubtitle =>
      'स्वतःबद्दल, कुटुंब, उत्पन्न आणि काम याबद्दल बोला';

  @override
  String get transcriptLabel => 'तुमचे बोलणे';

  @override
  String get typeInstead => 'बोलण्याऐवजी टाइप करा';

  @override
  String get transcriptHint => 'तुमचे बोलणे येथे दिसेल...';

  @override
  String get pleaseSpeak => 'कृपया बोला किंवा टाइप करा';

  @override
  String get listening => 'ऐकत आहे...';

  @override
  String get tapToSpeakAgain => 'पुन्हा बोलण्यासाठी टॅप करा';

  @override
  String get enterYourInfo => 'तुमची माहिती प्रविष्ट करा';

  @override
  String get describeHint => 'तुमची परिस्थिती सांगा...';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get save => 'जतन करा';

  @override
  String listeningIn(String language) {
    return 'ऐकत आहे: $language मध्ये';
  }

  @override
  String get speakPrompt => 'कृपया तुमची परिस्थिती तुमच्या शब्दांत सांगा';

  @override
  String get analyzingVoice => 'तुमचे बोलणे समजून घेत आहे...';

  @override
  String get matchingSchemes => 'तुमच्या योजना शोधत आहे...';

  @override
  String get generatingForm => 'तुमचा अर्ज तयार करत आहे...';

  @override
  String schemesFound(int count) {
    return '$count योजना सापडल्या';
  }

  @override
  String totalBenefit(String amount) {
    return '₹$amount / वर्ष';
  }

  @override
  String get totalEstimatedBenefits => 'एकूण अनुमानित लाभ';

  @override
  String get eligibleSchemes => 'पात्र योजना';

  @override
  String get noSchemesFound => 'कोणतीही योजना सापडली नाही';

  @override
  String get tryUpdatingProfile =>
      'पात्र योजना पाहण्यासाठी आपला प्रोफाइल अपडेट करा';

  @override
  String get applyNow => 'आता अर्ज करा';

  @override
  String get back => 'मागे';

  @override
  String get schemeDetails => 'योजना तपशील';

  @override
  String get eligibilityScore => 'पात्रता गुण';

  @override
  String get whyEligible => 'पात्र कसे?';

  @override
  String get description => 'वर्णन';

  @override
  String get requiredDocuments => 'आवश्यक कागदपत्रे';

  @override
  String get applicationInfo => 'अर्जाची माहिती';

  @override
  String get ministry => 'मंत्रालय';

  @override
  String get applyAt => 'येथे अर्ज करा';

  @override
  String get visitOfficialWebsite => 'अधिकृत वेबसाइट भेट द्या';

  @override
  String get documentsNeeded => 'आवश्यक कागदपत्रे';

  @override
  String get iHaveAllDocuments => 'सर्व कागदपत्रे आहेत → आत्ता अर्ज करा';

  @override
  String get missingDocuments => 'कागदपत्रे नाहीत → नंतरसाठी जतन करा';

  @override
  String get howToGet => 'कसे मिळवावे?';

  @override
  String get findNearestOffice => 'जवळचे कार्यालय शोधा';

  @override
  String get shareScheme => 'योजना शेअर करा';

  @override
  String shareText(
      String name, String benefit, String eligibility, String url) {
    return '$name\nलाभ: $benefit\nपात्रता: $eligibility\nअर्ज करा: $url\n\nअधिकार ऐपवर सापडले';
  }

  @override
  String get applicationHistory => 'आवेदन इतिहास';

  @override
  String get noApplications => 'कोई आवेदन नाहीत';

  @override
  String get allSchemes => 'सर्व योजना';

  @override
  String get forUser => 'साठी';

  @override
  String get hearResults => 'निकाल ऐका';

  @override
  String get eligible => 'पात्र';

  @override
  String get benefits => 'फायदे';

  @override
  String get noSchemesMatch => 'कोणतीही योजना जुळत नाही';

  @override
  String get noSchemesInCategory => 'या श्रेणीत कोणतीही योजना नाही';

  @override
  String get statusSubmitted => 'सादर केले';

  @override
  String get statusUnderReview => 'पुनरावलोकनात';

  @override
  String get statusApproved => 'मंजूर';

  @override
  String get statusRejected => 'नाकारले';

  @override
  String submittedDate(String date) {
    return 'सादर केले: $date';
  }

  @override
  String referenceNumber(String number) {
    return 'संदर्भ: $number';
  }

  @override
  String get offlineMessage => 'इंटरनेट नाही. जतन केलेल्या योजना दाखवत आहे.';

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String get language => 'भाषा';

  @override
  String get currentLanguage => 'सध्याची';

  @override
  String get voiceAndSound => 'आवाज आणि ध्वनी';

  @override
  String get enableTTS => 'TTS नरेशन सक्षम करा';

  @override
  String get autoPlayResults => 'परिणाम स्वयंचलितपणे चालवा';

  @override
  String get speechSpeed => 'बोलण्याचा वेग';

  @override
  String get slow => 'हळू';

  @override
  String get normal => 'सामान्य';

  @override
  String get fast => 'जलद';

  @override
  String get notifications => 'सूचना';

  @override
  String get statusAlerts => 'अर्ज स्थिती अलर्ट';

  @override
  String get documentReminders => 'कागदपत्र स्मरणपत्रे';

  @override
  String get newSchemeAlerts => 'नवीन योजना अलर्ट';

  @override
  String get accessibility => 'प्रवेशयोग्यता';

  @override
  String get largeText => 'मोठा मजकूर मोड';

  @override
  String get highContrast => 'उच्च कॉन्ट्रास्ट मोड';

  @override
  String get dataPrivacy => 'डेटा आणि गोपनीयता';

  @override
  String get exportData => 'माझा डेटा निर्यात करा';

  @override
  String get deleteAccount => 'खाते हटवा';

  @override
  String get deleteConfirmTitle => 'खाते हटवायचे?';

  @override
  String get deleteConfirmBody =>
      'यामुळे तुमचा सर्व डेटा कायमचा हटेल. ही क्रिया पूर्ववत करता येत नाही.';

  @override
  String get confirm => 'पुष्टी करा';

  @override
  String get about => 'बद्दल';

  @override
  String get appVersion => 'ऐप आवृत्ती';

  @override
  String get contactSupport => 'समर्थनाशी संपर्क करा';

  @override
  String get onboarding1Title => 'अधिकारमध्ये आपले स्वागत आहे';

  @override
  String get onboarding1Body =>
      'प्रत्येक सरकारी कल्याण योजना जी तुम्हाला मिळायला हवी — तुमच्या भाषेत.';

  @override
  String get onboarding2Title => 'तुमची परिस्थिती सांगा';

  @override
  String get onboarding2Body =>
      'मायक्रोफोन दाबा आणि स्वतःबद्दल सांगा — वय, काम, कुटुंब, उत्पन्न. आमची AI तुमची भाषा समजते.';

  @override
  String get onboarding2Example =>
      'मी 45 वर्षांची विधवा शेतकरी आहे, माझ्याकडे 2 एकर जमीन आहे...';

  @override
  String get onboarding3Title => 'तुमचे हक्क जाणून घ्या';

  @override
  String get onboarding3Body =>
      'आम्ही 200+ सरकारी योजनांमधून तुमच्यासाठी योग्य योजना शोधतो — लाभ रकमेसह.';

  @override
  String get onboarding4Title => 'त्वरित अर्ज करा';

  @override
  String get onboarding4Body =>
      'फॉर्म आपोआप भरले जातात. नकाशावर जवळचे कार्यालय शोधा. अर्जाची स्थिती लाइव्ह ट्रॅक करा.';

  @override
  String get getStarted => 'सुरू करा';

  @override
  String get skipOnboarding => 'वगळा';

  @override
  String get next => 'पुढे';

  @override
  String get networkError => 'इंटरनेट नाही. पुन्हा प्रयत्न करा.';

  @override
  String get geminiError => 'AI उपलब्ध नाही. मूलभूत जुळणी वापरत आहे.';

  @override
  String get firebaseError => 'सिंक अयशस्वी. डेटा स्थानिक पातळीवर जतन केला.';

  @override
  String get categoryAll => 'सर्व';

  @override
  String get categoryAgriculture => 'शेती';

  @override
  String get categoryHealth => 'आरोग्य';

  @override
  String get categoryEducation => 'शिक्षण';

  @override
  String get categoryHousing => 'गृहनिर्माण';

  @override
  String get categoryWomen => 'महिला आणि बाल';

  @override
  String get categoryEmployment => 'रोजगार';

  @override
  String get categoryDisability => 'दिव्यांगत्व';

  @override
  String get categorySenior => 'ज्येष्ठ नागरिक';

  @override
  String get profileTitle => 'तुमची प्रोफाइल';

  @override
  String get editProfile => 'प्रोफाइल संपादित करा';

  @override
  String get name => 'नाव';

  @override
  String get age => 'वय';

  @override
  String get gender => 'लिंग';

  @override
  String get caste => 'जातीवर्ग';

  @override
  String get occupation => 'व्यवसाय';

  @override
  String get income => 'वार्षिक उत्पन्न';

  @override
  String get state => 'राज्य';

  @override
  String get district => 'जिल्हा';

  @override
  String get landOwned => 'जमीन (एकर)';

  @override
  String get familySize => 'कुटुंबाचा आकार';

  @override
  String get maritalStatus => 'वैवाहिक स्थिती';

  @override
  String get disability => 'दिव्यांगत्व';

  @override
  String get helpButton => 'मदत हवी आहे?';

  @override
  String get pullToRefresh => 'रिफ्रेश करण्यासाठी खेचा';

  @override
  String get aiGreeting =>
      'नमस्कार! मी अधिकार AI आहे. सरकारी योजनांबद्दल काहीही विचारा.';

  @override
  String get askScheme => 'कोणत्याही योजनेबद्दल विचारा...';

  @override
  String get profileReview => 'प्रोफाइल पुनरावलोकन';

  @override
  String get noProfileData =>
      'प्रोफाइल सापडली नाही. कृपया मागे जा आणि पुन्हा बोला.';

  @override
  String get discover => 'शोधा';

  @override
  String get schemes => 'योजना';

  @override
  String get aiChat => 'AI गप्पा';

  @override
  String get history => 'इतिहास';

  @override
  String get personalInfo => 'वैयक्तिक माहिती';

  @override
  String get economicInfo => 'आर्थिक माहिती';

  @override
  String get socialStatus => 'सामाजिक स्थिती';

  @override
  String get fieldName => 'नाव';

  @override
  String get fieldAge => 'वय';

  @override
  String get fieldGender => 'लिंग';

  @override
  String get fieldState => 'राज्य';

  @override
  String get fieldDistrict => 'जिल्हा';

  @override
  String get fieldCaste => 'जात';

  @override
  String get fieldOccupation => 'व्यवसाय';

  @override
  String get fieldAnnualIncome => 'वार्षिक उत्पन्न (₹)';

  @override
  String get fieldLandHolding => 'जमीन (एकर)';

  @override
  String get fieldFamilySize => 'कुटुंब आकार';

  @override
  String get fieldBplCard => 'BPL कार्ड';

  @override
  String get fieldAadhaar => 'आधार कार्ड';

  @override
  String get fieldBankAccount => 'बँक खाते';

  @override
  String get fieldWidow => 'विधवा';

  @override
  String get fieldDisabled => 'दिव्यांग';

  @override
  String get fieldPregnant => 'गर्भवती';

  @override
  String get fieldEducation => 'शिक्षण';

  @override
  String get findEligibleSchemes => 'पात्र योजना शोधा';

  @override
  String get notDetected => 'आढळले नाही';

  @override
  String get members => 'सदस्य';

  @override
  String get acres => 'एकर';

  @override
  String get genderMale => 'पुरुष';

  @override
  String get genderFemale => 'महिला';

  @override
  String get occupationFarmer => 'शेतकरी';

  @override
  String get occupationStudent => 'विद्यार्थी';

  @override
  String get occupationDailyWage => 'दैनिक मजूर';

  @override
  String get occupationBusiness => 'व्यवसाय';

  @override
  String get occupationGovernment => 'सरकारी';

  @override
  String get occupationUnemployed => 'बेरोजगार';

  @override
  String get categoryWomenChild => 'महिला आणि बाल';

  @override
  String get share => 'सामायिक करा';

  @override
  String get documentsReady => 'कागदपत्रे तयार आहेत';

  @override
  String get saveForLater => 'नंतर साठी सेव्ह करा';

  @override
  String get applyAnyway => 'तरीही अर्ज करा';

  @override
  String get close => 'बंद करा';

  @override
  String get documentsMissing => 'कागदपत्रे नाहीत';

  @override
  String get documentsSaved => 'नंतर साठी सेव्ह केले - माझे अर्ज तपासा';

  @override
  String get documentsYouNeed => 'तुम्हाला आवश्यक कागदपत्रे';

  @override
  String get documentsReadyTitle => 'कागदपत्रे तयार';

  @override
  String get ofWord => 'पैकी';

  @override
  String get applyNowButton => 'आता अर्ज करा ✓';

  @override
  String get visitGovtOffice =>
      'नजीकच्या सरकारी कार्यालयात जा मान्यता प्राप्त ID पुराव्यासह.';

  @override
  String get fieldMinistry => 'मंत्रालय';
}
