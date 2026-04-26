// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'अधिकार';

  @override
  String get tagline => 'आपका अधिकार। आपके द्वार।';

  @override
  String get builtForBharat => 'भारत के लिए बनाया गया 🇮🇳';

  @override
  String get poweredByAI => 'AI द्वारा संचालित, भारत के लिए';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get chooseLanguage => 'अपनी भाषा चुनें';

  @override
  String get continueButton => 'आगे बढ़ें';

  @override
  String get continueWithEnglish => 'अंग्रेज़ी में जारी रखें';

  @override
  String get changeLanguage => 'भाषा बदलें';

  @override
  String languageChanged(String language) {
    return 'भाषा बदलकर $language हो गई';
  }

  @override
  String get voiceInputTitle => 'अपनी स्थिति बताएं';

  @override
  String get voiceInputSubtitle =>
      'खुद के बारे में, परिवार, आमदनी और काम के बारे में बोलें';

  @override
  String get transcriptLabel => 'आपकी बात';

  @override
  String get typeInstead => 'बोलने की जगह लिखें';

  @override
  String get transcriptHint => 'आपकी आवाज़ यहाँ दिखेगी...';

  @override
  String get pleaseSpeak => 'कृपया बोलें या लिखें';

  @override
  String get listening => 'सुन रहे हैं...';

  @override
  String get tapToSpeakAgain => 'फिर से बोलने के लिए टैप करें';

  @override
  String get enterYourInfo => 'अपनी जानकारी दर्ज करें';

  @override
  String get describeHint => 'अपनी स्थिति बताएं...';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सहेजें';

  @override
  String listeningIn(String language) {
    return 'सुन रहे हैं: $language में';
  }

  @override
  String get speakPrompt => 'कृपया अपनी स्थिति अपने शब्दों में बताएं';

  @override
  String get analyzingVoice => 'आपकी बात समझी जा रही है...';

  @override
  String get matchingSchemes => 'आपकी योजनाएं खोजी जा रही हैं...';

  @override
  String get generatingForm => 'आपका आवेदन तैयार किया जा रहा है...';

  @override
  String schemesFound(int count) {
    return '$count योजनाएं मिलीं';
  }

  @override
  String totalBenefit(String amount) {
    return '₹$amount / साल';
  }

  @override
  String get totalEstimatedBenefits => 'कुल अनुमानित लाभ';

  @override
  String get eligibleSchemes => 'पात्र योजनाएं';

  @override
  String get noSchemesFound => 'कोई योजना नहीं मिली';

  @override
  String get tryUpdatingProfile => 'अपनी प्रोफ़ाइल जानकारी अपडेट करें';

  @override
  String get applyNow => 'अभी आवेदन करें';

  @override
  String get back => 'वापस';

  @override
  String get schemeDetails => 'योजना विवरण';

  @override
  String get eligibilityScore => 'पात्रता स्कोर';

  @override
  String get whyEligible => 'क्यों पात्र हैं:';

  @override
  String get description => 'विवरण';

  @override
  String get requiredDocuments => 'आवश्यक दस्तावेज़';

  @override
  String get applicationInfo => 'आवेदन जानकारी';

  @override
  String get ministry => 'मंत्रालय';

  @override
  String get applyAt => 'यहाँ आवेदन करें';

  @override
  String get visitOfficialWebsite => 'आधिकारिक वेबसाइट देखें';

  @override
  String get documentsNeeded => 'ज़रूरी दस्तावेज़';

  @override
  String get iHaveAllDocuments => 'सभी दस्तावेज़ हैं → अभी आवेदन करें';

  @override
  String get missingDocuments => 'दस्तावेज़ नहीं हैं → बाद के लिए सहेजें';

  @override
  String get howToGet => 'यह कैसे प्राप्त करें';

  @override
  String get findNearestOffice => 'नज़दीकी कार्यालय खोजें';

  @override
  String get shareScheme => 'योजना शेयर करें';

  @override
  String shareText(
      String name, String benefit, String eligibility, String url) {
    return '$name\nलाभ: $benefit\nपात्रता: $eligibility\nआवेदन करें: $url\n\nअधिकार ऐप से मिला';
  }

  @override
  String get applicationHistory => 'आवेदन इतिहास';

  @override
  String get noApplications => 'कोई आवेदन नहीं। अभी खोजें!';

  @override
  String get statusSubmitted => 'जमा किया';

  @override
  String get statusUnderReview => 'समीक्षा में';

  @override
  String get statusApproved => 'स्वीकृत';

  @override
  String get statusRejected => 'अस्वीकृत';

  @override
  String submittedDate(String date) {
    return 'जमा किया: $date';
  }

  @override
  String referenceNumber(String number) {
    return 'संदर्भ: $number';
  }

  @override
  String get offlineMessage =>
      'इंटरनेट नहीं है। सहेजी हुई योजनाएं दिखाई जा रही हैं।';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get language => 'भाषा';

  @override
  String get currentLanguage => 'वर्तमान';

  @override
  String get voiceAndSound => 'आवाज़ और ध्वनि';

  @override
  String get enableTTS => 'TTS नरेशन सक्षम करें';

  @override
  String get autoPlayResults => 'परिणाम स्वतः चलाएं';

  @override
  String get speechSpeed => 'बोलने की गति';

  @override
  String get slow => 'धीमी';

  @override
  String get normal => 'सामान्य';

  @override
  String get fast => 'तेज़';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get statusAlerts => 'आवेदन स्थिति अलर्ट';

  @override
  String get documentReminders => 'दस्तावेज़ अनुस्मारक';

  @override
  String get newSchemeAlerts => 'नई योजना अलर्ट';

  @override
  String get accessibility => 'पहुंच';

  @override
  String get largeText => 'बड़ा टेक्स्ट मोड';

  @override
  String get highContrast => 'हाई कंट्रास्ट मोड';

  @override
  String get dataPrivacy => 'डेटा और गोपनीयता';

  @override
  String get exportData => 'मेरा डेटा निर्यात करें';

  @override
  String get deleteAccount => 'खाता हटाएं';

  @override
  String get deleteConfirmTitle => 'खाता हटाएं?';

  @override
  String get deleteConfirmBody =>
      'यह आपके सभी डेटा को स्थायी रूप से हटा देगा। यह क्रिया पूर्ववत नहीं की जा सकती।';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get about => 'के बारे में';

  @override
  String get appVersion => 'ऐप संस्करण';

  @override
  String get contactSupport => 'सहायता से संपर्क करें';

  @override
  String get onboarding1Title => 'अधिकार में आपका स्वागत है';

  @override
  String get onboarding1Body =>
      'हर सरकारी योजना जो आपको मिलनी चाहिए — आपकी भाषा में।';

  @override
  String get onboarding2Title => 'अपनी बात बोलें';

  @override
  String get onboarding2Body =>
      'माइक दबाएं और अपने बारे में बताएं — उम्र, काम, परिवार, आमदनी। हमारी AI आपकी भाषा समझती है।';

  @override
  String get onboarding2Example =>
      'मैं 45 साल की विधवा किसान हूं, मेरे पास 2 एकड़ ज़मीन है...';

  @override
  String get onboarding3Title => 'अपना हक जानें';

  @override
  String get onboarding3Body =>
      'हम 200+ सरकारी योजनाओं में से आपके लिए सही योजना निकालते हैं — लाभ राशि के साथ।';

  @override
  String get onboarding4Title => 'तुरंत आवेदन करें';

  @override
  String get onboarding4Body =>
      'फॉर्म खुद भरे जाते हैं। नज़दीकी कार्यालय का नक्शा देखें। आवेदन की स्थिति लाइव ट्रैक करें।';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get skipOnboarding => 'छोड़ें';

  @override
  String get next => 'आगे';

  @override
  String get networkError => 'इंटरनेट नहीं है। फिर से कोशिश करें।';

  @override
  String get geminiError =>
      'AI उपलब्ध नहीं है। बेसिक मिलान का उपयोग हो रहा है।';

  @override
  String get firebaseError => 'सिंक विफल। डेटा स्थानीय रूप से सहेजा गया।';

  @override
  String get categoryAll => 'सभी';

  @override
  String get categoryAgriculture => 'कृषि';

  @override
  String get categoryHealth => 'स्वास्थ्य';

  @override
  String get categoryEducation => 'शिक्षा';

  @override
  String get categoryHousing => 'आवास';

  @override
  String get categoryWomen => 'महिला एवं बाल';

  @override
  String get categoryEmployment => 'रोजगार';

  @override
  String get categoryDisability => 'दिव्यांगता';

  @override
  String get categorySenior => 'वरिष्ठ नागरिक';

  @override
  String get profileTitle => 'आपकी प्रोफ़ाइल';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get name => 'नाम';

  @override
  String get age => 'उम्र';

  @override
  String get gender => 'लिंग';

  @override
  String get caste => 'जाति वर्ग';

  @override
  String get occupation => 'व्यवसाय';

  @override
  String get income => 'वार्षिक आय';

  @override
  String get state => 'राज्य';

  @override
  String get district => 'जिला';

  @override
  String get landOwned => 'भूमि (एकड़ में)';

  @override
  String get familySize => 'परिवार का आकार';

  @override
  String get maritalStatus => 'वैवाहिक स्थिति';

  @override
  String get disability => 'दिव्यांगता';

  @override
  String get helpButton => 'मदद चाहिए?';

  @override
  String get pullToRefresh => 'रिफ्रेश करने के लिए खींचें';

  @override
  String get aiGreeting =>
      'नमस्ते! मैं अधिकार AI हूँ। सरकारी योजनाओं के बारे में कोई भी सवाल पूछें।';

  @override
  String get askScheme => 'कोई भी योजना के बारे में पूछें...';

  @override
  String get profileReview => 'प्रोफ़ाइल समीक्षा';

  @override
  String get noProfileData =>
      'प्रोफ़ाइल नहीं मिली। कृपया वापस जाएं और दोबारा बोलें।';

  @override
  String get discover => 'खोजें';

  @override
  String get schemes => 'योजनाएं';

  @override
  String get aiChat => 'AI चैट';

  @override
  String get history => 'इतिहास';
}
