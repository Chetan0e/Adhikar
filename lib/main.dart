import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';
import 'core/blocs/language/language_cubit.dart';
import 'core/constants/hive_boxes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('.env file not found or could not be loaded: $e');
    debugPrint('App will run without environment variables. Use --dart-define for API keys.');
  }

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    debugPrint(
        'Please ensure google-services.json (Android) or GoogleService-Info.plist (iOS) is present.');
  }

  // Initialize Hive for offline storage
  await Hive.initFlutter();

  // Open Hive boxes
  await Hive.openBox(HiveBoxes.kUserProfileBox);
  await Hive.openBox(HiveBoxes.kSchemesBox);
  await Hive.openBox(HiveBoxes.kApplicationsBox);
  await Hive.openBox(HiveBoxes.kSyncQueueBox);
  await Hive.openBox(HiveBoxes.kSettingsBox);

  // Load saved language before rendering
  final languageCubit = LanguageCubit();
  await languageCubit.loadSavedLanguage();

  // Debug Firestore and seed schemes if needed
  await debugFirestore();

  runApp(
    BlocProvider<LanguageCubit>.value(
      value: languageCubit,
      child: const AdhikarApp(),
    ),
  );
}

Future<void> debugFirestore() async {
  try {
    print('=== FIRESTORE DEBUG START ===');
    
    // Check auth
    final user = FirebaseAuth.instance.currentUser;
    print('Auth user: ${user?.uid ?? "NOT LOGGED IN"}');
    
    // Check schemes collection
    final snap = await FirebaseFirestore.instance
        .collection('schemes')
        .get();
    print('Total scheme docs: ${snap.docs.length}');
    
    if (snap.docs.isEmpty) {
      print('ERROR: schemes collection is EMPTY — needs seeding');
      await seedSchemes();
    } else {
      print('Schemes already present in Firestore:');
      for (final doc in snap.docs) {
        print('Scheme: ${doc.id} → ${doc.data().keys.toList()}');
      }
    }
    print('=== FIRESTORE DEBUG END ===');
  } catch (e) {
    print('FIRESTORE ERROR: $e');
  }
}

Future<void> seedSchemes() async {
  final col = FirebaseFirestore.instance.collection('schemes');
  final existing = await col.limit(1).get();
  if (existing.docs.isNotEmpty) {
    print('Schemes already seeded. Skipping.');
    return;
  }

  print('Seeding schemes...');
  final batch = FirebaseFirestore.instance.batch();

  final schemes = [
    {
      'id': 'PM_KISAN_001',
      'name_en': 'PM-KISAN Samman Nidhi',
      'name_hi': 'पीएम-किसान सम्मान निधि',
      'name_mr': 'पीएम-किसान सन्मान निधी',
      'name_ta': 'பிரதம மந்திரி கிசான் சம்மான் நிதி',
      'name_te': 'పిఎం-కిసాన్ సమ్మాన్ నిధి',
      'name_kn': 'ಪಿಎಂ-ಕಿಸಾನ್ ಸಮ್ಮಾನ್ ನಿಧಿ',
      'name_bn': 'পিএম-কিসান সম্মান নিধি',
      'name_gu': 'પીએમ-કિસાન સન્માન નિધિ',
      'name_ml': '',
      'name_or': '',
      'name_pa': '',
      'description_en': 'Income support of ₹6,000 per year to small and marginal farmer families in three equal installments of ₹2,000 each.',
      'description_hi': 'छोटे और सीमांत किसान परिवारों को प्रति वर्ष ₹6,000 की आय सहायता तीन समान किस्तों में।',
      'description_mr': 'लहान आणि सीमांत शेतकरी कुटुंबांना वार्षिक ₹6,000 उत्पन्न सहाय्य तीन समान हप्त्यांमध्ये.',
      'description_ta': 'சிறு மற்றும் குறு விவசாய குடும்பங்களுக்கு ஆண்டுக்கு ₹6,000 வருமான ஆதரவு மூன்று சம தவணைகளில்.',
      'description_te': 'చిన్న మరియు సన్నకారు రైతు కుటుంబాలకు సంవత్సరానికి ₹6,000 ఆదాయ మద్దతు మూడు సమాన వాయిదాలలో.',
      'description_kn': '',
      'description_bn': '',
      'description_gu': '',
      'description_ml': '',
      'description_or': '',
      'description_pa': '',
      'category': 'agriculture',
      'ministry': 'Ministry of Agriculture & Farmers Welfare',
      'benefit_amount': '₹6,000/year',
      'eligibility': {
        'occupations': ['farmer'],
        'max_land_holding': 2.0,
        'requires_aadhar': true,
        'requires_bank_account': true,
      },
      'required_documents': [
        'Aadhar Card', 'Land Records / Khasra', 
        'Bank Passbook', 'Mobile Number'
      ],
      'application_url': 'https://pmkisan.gov.in',
      'application_office': 'Common Service Centre (CSC) or Patwari',
      'is_active': true,
      'last_updated': DateTime.now().toIso8601String(),
    },
    {
      'id': 'AYUSHMAN_001',
      'name_en': 'Ayushman Bharat PM-JAY',
      'name_hi': 'आयुष्मान भारत पीएम-जेएवाई',
      'name_mr': 'आयुष्मान भारत पीएम-जेएवाय',
      'name_ta': 'ஆயுஷ்மான் பாரத் பிஏம்-ஜேஏவை',
      'name_te': 'ఆయుష్మాన్ భారత్ పిఎం-జేఏవై',
      'name_kn': 'ಆಯುಷ್ಮಾನ್ ಭಾರತ್ ಪಿಎಂ-ಜೆಎವೈ',
      'name_bn': 'আয়ুষ্মান ভারত পিএম-জেএওয়াই',
      'name_gu': 'આયુષ્માન ભારત પીએમ-જેએવાય',
      'name_ml': '',
      'name_or': '',
      'name_pa': '',
      'description_en': 'Health coverage of ₹5 lakh per family per year for secondary and tertiary hospitalization.',
      'description_hi': 'माध्यमिक और तृतीयक अस्पताल में भर्ती के लिए प्रति परिवार प्रति वर्ष ₹5 लाख का स्वास्थ्य बीमा।',
      'description_mr': 'दुय्यम आणि तृतीय रुग्णालयात दाखल होण्यासाठी प्रति कुटुंब प्रति वर्ष ₹5 लाख आरोग्य विमा.',
      'description_ta': 'இரண்டாம் நிலை மற்றும் மூன்றாம் நிலை மருத்துவமனை அனுமதிக்கு குடும்பத்திற்கு ஆண்டுக்கு ₹5 லட்சம்.',
      'description_te': 'ద్వితీయ మరియు తృతీయ ఆసుపత్రి చికిత్సకు కుటుంబానికి సంవత్సరానికి ₹5 లక్షల ఆరోగ్య కవచం.',
      'description_kn': '',
      'description_bn': '',
      'description_gu': '',
      'description_ml': '',
      'description_or': '',
      'description_pa': '',
      'category': 'health',
      'ministry': 'Ministry of Health & Family Welfare',
      'benefit_amount': '₹5 lakh/year health cover',
      'eligibility': {'secc_listed': true},
      'required_documents': [
        'Aadhar Card', 'Ration Card', 'SECC/BPL Certificate'
      ],
      'application_url': 'https://pmjay.gov.in',
      'application_office': 'Common Service Centre (CSC)',
      'is_active': true,
      'last_updated': DateTime.now().toIso8601String(),
    },
    {
      'id': 'WIDOW_PENSION_001',
      'name_en': 'Widow Pension - NSAP',
      'name_hi': 'विधवा पेंशन - एनएसएपी',
      'name_mr': 'विधवा पेन्शन - एनएसएपी',
      'name_ta': 'விதவை ஓய்வூதியம் - என்எஸ்ஏபி',
      'name_te': 'వితంతు పెన్షన్ - ఎన్ఎస్ఎపి',
      'name_kn': 'ವಿಧವೆ ಪಿಂಚಣಿ - ಎನ್ಎಸ್ಎಪಿ',
      'name_bn': 'বিধবা পেনশন - এনএসএপি',
      'name_gu': 'વિધવા પેન્શન - એનએસએપી',
      'name_ml': '',
      'name_or': '',
      'name_pa': '',
      'description_en': 'Monthly pension of ₹300-500 for widows below poverty line aged 40-79.',
      'description_hi': '40-79 वर्ष की गरीबी रेखा से नीचे की विधवाओं को ₹300-500 मासिक पेंशन।',
      'description_mr': '40-79 वर्षे वयाच्या दारिद्र्यरेषेखालील विधवांना ₹300-500 मासिक पेन्शन.',
      'description_ta': '40-79 வயதுடைய வறுமைக் கோட்டிற்கு கீழுள்ள விதவைகளுக்கு மாதம் ₹300-500 ஓய்வூதியம்.',
      'description_te': '40-79 సంవత్సరాల పేదరేఖకు దిగువన ఉన్న వితంతువులకు నెలకు ₹300-500 పెన్షన్.',
      'description_kn': '',
      'description_bn': '',
      'description_gu': '',
      'description_ml': '',
      'description_or': '',
      'description_pa': '',
      'category': 'women',
      'ministry': 'Ministry of Rural Development',
      'benefit_amount': '₹300-500/month',
      'eligibility': {
        'genders': ['female'],
        'is_widow': true,
        'min_age': 40,
        'max_age': 79,
        'requires_bpl': true,
      },
      'required_documents': [
        'Aadhar Card', 'BPL Card', 
        'Husband Death Certificate', 'Bank Passbook'
      ],
      'application_url': 'https://nsap.nic.in',
      'application_office': 'Block Development Officer',
      'is_active': true,
      'last_updated': DateTime.now().toIso8601String(),
    },
    {
      'id': 'UJJWALA_001',
      'name_en': 'PM Ujjwala Yojana 2.0',
      'name_hi': 'पीएम उज्ज्वला योजना 2.0',
      'name_mr': 'पीएम उज्ज्वला योजना 2.0',
      'name_ta': 'பிரதம மந்திரி உஜ்வல திட்டம் 2.0',
      'name_te': 'పిఎం ఉజ్జ్వల యోజన 2.0',
      'name_kn': 'ಪಿಎಂ ಉಜ್ಜ್ವಲ ಯೋಜನೆ 2.0',
      'name_bn': 'পিএম উজ্জ্বলা যোজনা ২.০',
      'name_gu': 'પીએમ ઉજ્જ્વલા યોજના 2.0',
      'name_ml': '',
      'name_or': '',
      'name_pa': '',
      'description_en': 'Free LPG gas connection to women from BPL households to replace traditional cooking methods.',
      'description_hi': 'गरीबी रेखा से नीचे के परिवारों की महिलाओं को पारंपरिक खाना पकाने के तरीकों की जगह मुफ्त LPG गैस कनेक्शन।',
      'description_mr': 'दारिद्र्यरेषेखालील कुटुंबातील महिलांना पारंपारिक स्वयंपाकाच्या पद्धतींच्या जागी मोफत LPG गॅस कनेक्शन.',
      'description_ta': 'பாரம்பரிய சமையல் முறைகளுக்கு பதிலாக BPL குடும்பங்களின் பெண்களுக்கு இலவச LPG இணைப்பு.',
      'description_te': 'BPL కుటుంబాల మహిళలకు సాంప్రదాయ వంట పద్ధతులకు బదులుగా ఉచిత LPG కనెక్షన్.',
      'description_kn': '',
      'description_bn': '',
      'description_gu': '',
      'description_ml': '',
      'description_or': '',
      'description_pa': '',
      'category': 'women',
      'ministry': 'Ministry of Petroleum & Natural Gas',
      'benefit_amount': 'Free LPG Connection + Cylinder',
      'eligibility': {'genders': ['female'], 'requires_bpl': true},
      'required_documents': [
        'Aadhar Card', 'BPL/Ration Card', 
        'Bank Passbook', 'Address Proof'
      ],
      'application_url': 'https://pmuy.gov.in',
      'application_office': 'LPG Distributor',
      'is_active': true,
      'last_updated': DateTime.now().toIso8601String(),
    },
    {
      'id': 'MGNREGA_001',
      'name_en': 'MGNREGA - 100 Days Work',
      'name_hi': 'मनरेगा - 100 दिन काम',
      'name_mr': 'मनरेगा - 100 दिवस काम',
      'name_ta': 'மகன்ரேகா - 100 நாள் வேலை',
      'name_te': 'మహాత్మా గాంధీ నరేగా - 100 రోజుల పని',
      'name_kn': 'ಮನರೇಗಾ - 100 ದಿನ ಕೆಲಸ',
      'name_bn': 'মনরেগা - ১০০ দিনের কাজ',
      'name_gu': 'મનરેગા - 100 દિવસ કામ',
      'name_ml': '',
      'name_or': '',
      'name_pa': '',
      'description_en': 'Guaranteed 100 days of wage employment per year to every rural household at ₹220-300 per day.',
      'description_hi': 'ग्रामीण परिवारों को प्रति वर्ष 100 दिन की मजदूरी रोजगार की गारंटी ₹220-300 प्रतिदिन।',
      'description_mr': 'ग्रामीण कुटुंबांना दररोज ₹220-300 दराने वार्षिक 100 दिवस मजुरी रोजगाराची हमी.',
      'description_ta': 'கிராமப்புற குடும்பங்களுக்கு தினம் ₹220-300 வீதம் வருடத்திற்கு 100 நாட்கள் வேலை வாய்ப்பு உத்தரவாதம்.',
      'description_te': 'గ్రామీణ కుటుంబాలకు రోజుకు ₹220-300 వేతనంతో సంవత్సరానికి 100 రోజుల ఉద్యోగ హామీ.',
      'description_kn': '',
      'description_bn': '',
      'description_gu': '',
      'description_ml': '',
      'description_or': '',
      'description_pa': '',
      'category': 'employment',
      'ministry': 'Ministry of Rural Development',
      'benefit_amount': '100 days/year @ ₹220-300/day',
      'eligibility': {'area': 'rural'},
      'required_documents': [
        'Aadhar Card', 'Job Card (NREGA)', 'Bank Passbook'
      ],
      'application_url': 'https://nrega.nic.in',
      'application_office': 'Gram Panchayat',
      'is_active': true,
      'last_updated': DateTime.now().toIso8601String(),
    },
    {
      'id': 'PMAY_GRAMIN_001',
      'name_en': 'PM Awas Yojana - Gramin',
      'name_hi': 'पीएम आवास योजना - ग्रामीण',
      'name_mr': 'पीएम आवास योजना - ग्रामीण',
      'name_ta': 'பிரதம மந்திரி ஆவாஸ் யோஜனா - கிராமிண',
      'name_te': 'పిఎం ఆవాస్ యోజన - గ్రామీణ',
      'name_kn': 'ಪಿಎಂ ಆವಾಸ್ ಯೋಜನೆ - ಗ್ರಾಮೀಣ',
      'name_bn': 'পিএম আবাস যোজনা - গ্রামীণ',
      'name_gu': 'પીએમ આવાસ યોજના - ગ્રામીણ',
      'name_ml': '',
      'name_or': '',
      'name_pa': '',
      'description_en': 'Financial assistance of ₹1.2-1.3 lakh for construction of pucca house for homeless rural BPL families.',
      'description_hi': 'बेघर ग्रामीण बीपीएल परिवारों को पक्का घर बनाने के लिए ₹1.2-1.3 लाख की वित्तीय सहायता।',
      'description_mr': 'बेघर ग्रामीण बीपीएल कुटुंबांना पक्के घर बांधण्यासाठी ₹1.2-1.3 लाख आर्थिक मदत.',
      'description_ta': 'வீடற்ற கிராமப்புற BPL குடும்பங்களுக்கு நிரந்தர வீடு கட்ட ₹1.2-1.3 லட்சம் நிதி உதவி.',
      'description_te': 'నిరాశ్రయ గ్రామీణ BPL కుటుంబాలకు పక్కా ఇల్లు నిర్మించడానికి ₹1.2-1.3 లక్షల ఆర్థిక సహాయం.',
      'description_kn': '',
      'description_bn': '',
      'description_gu': '',
      'description_ml': '',
      'description_or': '',
      'description_pa': '',
      'category': 'housing',
      'ministry': 'Ministry of Rural Development',
      'benefit_amount': '₹1.2-1.3 lakh for house',
      'eligibility': {'area': 'rural', 'requires_bpl': true},
      'required_documents': [
        'Aadhar Card', 'BPL/SECC Certificate', 
        'Land Documents', 'Bank Passbook'
      ],
      'application_url': 'https://pmayg.nic.in',
      'application_office': 'Block Development Officer',
      'is_active': true,
      'last_updated': DateTime.now().toIso8601String(),
    },
    {
      'id': 'JSY_001',
      'name_en': 'Janani Suraksha Yojana',
      'name_hi': 'जननी सुरक्षा योजना',
      'name_mr': 'जननी सुरक्षा योजना',
      'name_ta': 'ஜனனி சுரக்ஷா யோஜனா',
      'name_te': 'జననీ సురక్షా యోజన',
      'name_kn': 'ಜನನಿ ಸುರಕ್ಷಾ ಯೋಜನೆ',
      'name_bn': 'জননী সুরক্ষা যোজনা',
      'name_gu': 'જનની સુરક્ષા યોજના',
      'name_ml': '',
      'name_or': '',
      'name_pa': '',
      'description_en': 'Cash benefit of ₹1,400 to rural pregnant BPL women for delivering baby at government hospital.',
      'description_hi': 'सरकारी अस्पताल में प्रसव के लिए ग्रामीण गर्भवती बीपीएल महिलाओं को ₹1,400 नकद।',
      'description_mr': 'सरकारी रुग्णालयात प्रसूतीसाठी ग्रामीण गर्भवती BPL महिलांना ₹1,400 रोख.',
      'description_ta': 'அரசு மருத்துவமனையில் பிரசவிக்கும் கிராமப்புற கர்ப்பிணி BPL பெண்களுக்கு ₹1,400 பணமாக.',
      'description_te': 'ప్రభుత్వ ఆసుపత్రిలో ప్రసవానికి వచ్చిన గ్రామీణ గర్భిణీ BPL మహిళలకు ₹1,400 నగదు.',
      'description_kn': '',
      'description_bn': '',
      'description_gu': '',
      'description_ml': '',
      'description_or': '',
      'description_pa': '',
      'category': 'health',
      'ministry': 'Ministry of Health & Family Welfare',
      'benefit_amount': '₹1,400 cash (rural)',
      'eligibility': {
        'genders': ['female'],
        'is_pregnant': true,
        'requires_bpl': true
      },
      'required_documents': [
        'Aadhar Card', 'BPL Card', 'ANC Registration Card'
      ],
      'application_url': 'https://nhm.gov.in',
      'application_office': 'Government Hospital',
      'is_active': true,
      'last_updated': DateTime.now().toIso8601String(),
    },
    {
      'id': 'PMKVY_001',
      'name_en': 'PM Kaushal Vikas Yojana',
      'name_hi': 'पीएम कौशल विकास योजना',
      'name_mr': 'पीएम कौशल विकास योजना',
      'name_ta': 'பிரதம மந்திரி கௌஷல் விகாஸ் யோஜனா',
      'name_te': 'పిఎం కౌశల్ వికాస్ యోజన',
      'name_kn': 'ಪಿಎಂ ಕೌಶಲ್ ವಿಕಾಸ ಯೋಜನೆ',
      'name_bn': 'পিএম কৌশল বিকাশ যোজনা',
      'name_gu': 'પીએમ કૌશલ વિકાસ યોજના',
      'name_ml': '',
      'name_or': '',
      'name_pa': '',
      'description_en': 'Free skill training with industry-recognized certification and ₹8,000 cash reward for youth aged 15-45.',
      'description_hi': '15-45 वर्ष के युवाओं को उद्योग-मान्यता प्राप्त प्रमाणपत्र के साथ मुफ्त कौशल प्रशिक्षण और ₹8,000 नकद पुरस्कार।',
      'description_mr': '15-45 वयाच्या युवकांसाठी उद्योग-मान्यताप्राप्त प्रमाणपत्रासह मोफत कौशल्य प्रशिक्षण आणि ₹8,000 रोख बक्षीस.',
      'description_ta': '15-45 வயது இளைஞர்களுக்கு தொழில்துறை அங்கீகாரம் பெற்ற சான்றிதழுடன் இலவச திறன் பயிற்சி மற்றும் ₹8,000 பரிசு.',
      'description_te': '15-45 సంవత్సరాల యువతకు పరిశ్రమ గుర్తింపు పొందిన సర్టిఫికేట్‌తో ఉచిత నైపుణ్య శిక్షణ మరియు ₹8,000 నగదు.',
      'description_kn': '',
      'description_bn': '',
      'description_gu': '',
      'description_ml': '',
      'description_or': '',
      'description_pa': '',
      'category': 'employment',
      'ministry': 'Ministry of Skill Development',
      'benefit_amount': 'Free training + ₹8,000 reward',
      'eligibility': {'min_age': 15, 'max_age': 45},
      'required_documents': [
        'Aadhar Card', 'Educational Certificate', 'Bank Passbook'
      ],
      'application_url': 'https://pmkvyofficial.org',
      'application_office': 'Training Centre',
      'is_active': true,
      'last_updated': DateTime.now().toIso8601String(),
    },
    {
      'id': 'MUDRA_001',
      'name_en': 'PM Mudra Yojana',
      'name_hi': 'पीएम मुद्रा योजना',
      'name_mr': 'पीएम मुद्रा योजना',
      'name_ta': 'பிரதம மந்திரி முத்ரா யோஜனா',
      'name_te': 'పిఎం ముద్రా యోజన',
      'name_kn': 'ಪಿಎಂ ಮುದ್ರಾ ಯೋಜನೆ',
      'name_bn': 'পিএম মুদ্রা যোজনা',
      'name_gu': 'પીએમ મુદ્રા યોજના',
      'name_ml': '',
      'name_or': '',
      'name_pa': '',
      'description_en': 'Collateral-free business loans from ₹50,000 to ₹10 lakh for small and micro enterprises.',
      'description_hi': 'छोटे और सूक्ष्म उद्यमों के लिए ₹50,000 से ₹10 लाख तक बिना ज़मानत के व्यापार ऋण।',
      'description_mr': 'लघु आणि सूक्ष्म उद्योगांसाठी ₹50,000 ते ₹10 लाख विनातारण व्यवसाय कर्ज.',
      'description_ta': 'சிறு மற்றும் நுண் தொழில்முனைவோருக்கு ₹50,000 முதல் ₹10 லட்சம் வரை ஈட்டமில்லா கடன்.',
      'description_te': 'చిన్న మరియు సూక్ష్మ సంస్థలకు ₹50,000 నుండి ₹10 లక్షల వరకు తనఖా లేని వ్యాపార రుణాలు.',
      'description_kn': '',
      'description_bn': '',
      'description_gu': '',
      'description_ml': '',
      'description_or': '',
      'description_pa': '',
      'category': 'employment',
      'ministry': 'Ministry of Finance',
      'benefit_amount': 'Loan ₹50,000 - ₹10 lakh',
      'eligibility': {'occupations': ['business', 'self_employed']},
      'required_documents': [
        'Aadhar Card', 'PAN Card', 
        'Business Proof', '6 months Bank Statements'
      ],
      'application_url': 'https://mudra.org.in',
      'application_office': 'Bank Branch',
      'is_active': true,
      'last_updated': DateTime.now().toIso8601String(),
    },
    {
      'id': 'NSP_SC_001',
      'name_en': 'National Scholarship - SC/ST/OBC',
      'name_hi': 'राष्ट्रीय छात्रवृत्ति - एससी/एसटी/ओबीसी',
      'name_mr': 'राष्ट्रीय शिष्यवृत्ती - एससी/एसटी/ओबीसी',
      'name_ta': 'தேசிய உதரிவிலக்கு - SC/ST/OBC',
      'name_te': 'జాతీయ స్కాలర్‌షిప్ - SC/ST/OBC',
      'name_kn': 'ರಾಷ್ಟ್ರೀಯ ವಿದ್ಯಾರ್ಥಿ ವೇತನ - SC/ST/OBC',
      'name_bn': 'জাতীয় বৃত্তি - এসসি/এসটি/ওবিসি',
      'name_gu': 'રાષ્ટ્રીય શિષ્યવૃત્તિ - SC/ST/OBC',
      'name_ml': '',
      'name_or': '',
      'name_pa': '',
      'description_en': 'Annual scholarship of ₹10,000 to ₹75,000 for SC/ST/OBC/minority students for education.',
      'description_hi': 'अनुसूचित जाति/जनजाति/अन्य पिछड़ा वर्ग/अल्पसंख्यक छात्रों के लिए शिक्षा हेतु ₹10,000 से ₹75,000 तक की वार्षिक छात्रवृत्ति।',
      'description_mr': 'SC/ST/OBC/अल्पसंख्याक विद्यार्थ्यांसाठी शिक्षणासाठी वार्षिक ₹10,000 ते ₹75,000 शिष्यवृत्ती.',
      'description_ta': 'SC/ST/OBC/சிறுபான்மை மாணவர்களுக்கு கல்விக்காக ஆண்டுக்கு ₹10,000 முதல் ₹75,000 வரை உதரிவிலக்கு.',
      'description_te': 'SC/ST/OBC/మైనారిటీ విద్యార్థులకు చదువుకోసం సంవత్సరానికి ₹10,000 నుండి ₹75,000 వరకు స్కాలర్‌షిప్.',
      'description_kn': '',
      'description_bn': '',
      'description_gu': '',
      'description_ml': '',
      'description_or': '',
      'description_pa': '',
      'category': 'education',
      'ministry': 'Ministry of Social Justice',
      'benefit_amount': '₹10,000 - ₹75,000/year',
      'eligibility': {
        'castes': ['sc', 'st', 'obc', 'minority'],
        'is_student': true,
      },
      'required_documents': [
        'Aadhar Card', 'Caste Certificate',
        'Income Certificate', 'School/College ID', 'Bank Passbook'
      ],
      'application_url': 'https://scholarships.gov.in',
      'application_office': 'School/College',
      'is_active': true,
      'last_updated': DateTime.now().toIso8601String(),
    },
    {
      'id': 'DISABILITY_PENSION_001',
      'name_en': 'Disability Pension - NSAP',
      'name_hi': 'दिव्यांग पेंशन - एनएसएपी',
      'name_mr': 'दिव्यांग पेन्शन - एनएसएपी',
      'name_ta': 'மாற்றுத்திறனாளி ஓய்வூதியம் - என்எஸ்ஏபி',
      'name_te': 'వికలాంగ పెన్షన్ - ఎన్ఎస్ఎపి',
      'name_kn': 'ಅಂಗವಿಕಲ ಪಿಂಚಣಿ - ಎನ್ಎಸ್ಎಪಿ',
      'name_bn': 'প্রতিবন্ধী পেনশন - এনএসএপি',
      'name_gu': 'દિવ્યાંગ પેન્શન - એનએસએપી',
      'name_ml': '',
      'name_or': '',
      'name_pa': '',
      'description_en': 'Monthly pension of ₹300 for persons with 80% or more disability from BPL families.',
      'description_hi': 'बीपीएल परिवारों के 80% या अधिक विकलांगता वाले व्यक्तियों के लिए ₹300 मासिक पेंशन।',
      'description_mr': 'BPL कुटुंबांतील 80% किंवा त्याहून अधिक अपंगत्व असलेल्या व्यक्तींसाठी ₹300 मासिक पेन्शन.',
      'description_ta': 'BPL குடும்பங்களிலிருந்து 80% அல்லது அதிகமான குறைபாடு உள்ளவர்களுக்கு மாதம் ₹300 ஓய்வூதியம்.',
      'description_te': 'BPL కుటుంబాల నుండి 80% లేదా అంతకంటే ఎక్కువ వికలాంగత కలిగిన వ్యక్తులకు నెలకు ₹300 పెన్షన్.',
      'description_kn': '',
      'description_bn': '',
      'description_gu': '',
      'description_ml': '',
      'description_or': '',
      'description_pa': '',
      'category': 'disability',
      'ministry': 'Ministry of Rural Development',
      'benefit_amount': '₹300/month',
      'eligibility': {
        'is_disabled': true,
        'disability_percent': 80,
        'requires_bpl': true
      },
      'required_documents': [
        'Aadhar Card', 'BPL Card',
        'Disability Certificate (80%+)', 'Bank Passbook'
      ],
      'application_url': 'https://nsap.nic.in',
      'application_office': 'Block Development Officer',
      'is_active': true,
      'last_updated': DateTime.now().toIso8601String(),
    },
    {
      'id': 'OLD_AGE_PENSION_001',
      'name_en': 'Old Age Pension - IGNOAPS',
      'name_hi': 'वृद्धावस्था पेंशन - इग्नोएपीएस',
      'name_mr': 'वृद्धापकाळ पेन्शन - आयजीएनओएपीएस',
      'name_ta': 'முதியோர் ஓய்வூதியம் - IGNOAPS',
      'name_te': 'వృద్ధాప్య పెన్షన్ - IGNOAPS',
      'name_kn': 'ವೃದ್ಧಾಪ್ಯ ಪಿಂಚಣಿ - IGNOAPS',
      'name_bn': 'বার্ধক্য পেনশন - IGNOAPS',
      'name_gu': 'વૃદ્ધ પેન્શન - IGNOAPS',
      'name_ml': '',
      'name_or': '',
      'name_pa': '',
      'description_en': 'Monthly pension of ₹200-500 for citizens aged 60 years and above from BPL families.',
      'description_hi': 'बीपीएल परिवारों के 60 वर्ष और उससे अधिक आयु के नागरिकों के लिए ₹200-500 मासिक पेंशन।',
      'description_mr': 'BPL कुटुंबांतील 60 वर्षे व त्याहून अधिक वयाच्या नागरिकांसाठी ₹200-500 मासिक पेन્શन.',
      'description_ta': 'BPL குடும்பங்களிலிருந்து 60 வயது மற்றும் அதற்கு மேற்பட்டவர்களுக்கு மாதம் ₹200-500 ஓய்வூதியம்.',
      'description_te': 'BPL కుటుంబాల నుండి 60 సంవత్సరాలు మరియు అంతకంటే ఎక్కువ వయసు పౌరులకు నెలకు ₹200-500 పెన్షన్.',
      'description_kn': '',
      'description_bn': '',
      'description_gu': '',
      'description_ml': '',
      'description_or': '',
      'description_pa': '',
      'category': 'senior',
      'ministry': 'Ministry of Rural Development',
      'benefit_amount': '₹200-500/month',
      'eligibility': {'min_age': 60, 'requires_bpl': true},
      'required_documents': [
        'Aadhar Card', 'BPL Card',
        'Age Proof', 'Bank Passbook'
      ],
      'application_url': 'https://nsap.nic.in',
      'application_office': 'Block Development Officer',
      'is_active': true,
      'last_updated': DateTime.now().toIso8601String(),
    },
  ];

  for (final scheme in schemes) {
    final id = scheme['id'] as String;
    final ref = col.doc(id);
    batch.set(ref, scheme);
  }
  
  await batch.commit();
  print('SUCCESS: ${schemes.length} schemes seeded to Firestore.');
}
