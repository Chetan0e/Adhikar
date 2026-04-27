import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/api_endpoints.dart';
import '../../core/services/connectivity_service.dart';

class GeminiService {
  final Dio _dio = Dio();
  final ConnectivityService _connectivityService;

  static String _apiKey =
      String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

  static const String _endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models'
      '/gemini-1.5-flash:generateContent';

  GeminiService({ConnectivityService? connectivityService})
      : _connectivityService = connectivityService ?? ConnectivityService() {
    // Try to load from dotenv if not set via compile-time
    if (_apiKey.isEmpty) {
      try {
        _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
        print('GeminiService: Loaded API key from dotenv');
      } catch (e) {
        print('GeminiService: Could not load API key from dotenv: $e');
      }
    } else {
      print('GeminiService: Using compile-time API key');
    }
    print('GeminiService: API key set: ${_apiKey.isNotEmpty}');
  }

  String get apiKey => _apiKey;

  void setApiKey(String key) => _apiKey = key;

  // ─────────────────────────────────────────────────────────────────────────
  // Extract user profile from voice transcript using Gemini AI
  // ─────────────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> extractProfile(String transcript) async {
    print('╔══ GEMINI extractProfile ══╗');
    print('║ Key set: ${_apiKey.isNotEmpty}');
    print('║ Key length: ${_apiKey.length}');
    print('║ Transcript: $transcript');
    print('╚═══════════════════════════╝');

    // ALWAYS build a smart local fallback first
    final fallback = _smartLocalExtract(transcript);
    print('Local fallback extracted: $fallback');

    if (_apiKey.isEmpty) {
      print('ERROR: No API key — returning local fallback');
      return fallback;
    }

    // Multi-language aware prompt
    final prompt = '''
You are an expert at understanding Indian languages including Hindi, Marathi, Tamil, Telugu, Kannada, Bengali, Gujarati.

Analyze this text spoken by an Indian rural citizen and extract information.
Text: "$transcript"

RULES:
- "विद्यार्थी" or "student" means occupation = student
- "शेतकरी" or "किसान" or "farmer" means occupation = farmer
- "विधवा" or "widow" means is_widow = true
- "दहावी" or "10th" or "बारावी" or "12th" means education_level = secondary
- Names are usually at the start after "नाव" or "naam" or "name is"
- Ages are numbers near "वर्ष" or "years old" or "साल"
- Extract the person's FIRST name only

Return ONLY this JSON, no other text, no markdown:
{
  "name": "extracted_name_or_null",
  "age": null_or_number,
  "gender": "male_or_female_or_null",
  "state": "state_name_or_null",
  "district": "district_name_or_null",
  "caste": "general_obc_sc_st_or_null",
  "occupation": "farmer_student_daily_wage_business_government_unemployed_or_null",
  "annual_income": null_or_number,
  "land_holding_acres": 0.0,
  "is_disabled": false,
  "is_widow": false,
  "has_bpl_card": null,
  "has_aadhar": null,
  "has_bank_account": null,
  "family_size": null_or_number,
  "children_ages": [],
  "is_pregnant": false,
  "education_level": "primary_secondary_graduate_or_null"
}
''';

    try {
      final uri = Uri.parse('$_endpoint?key=$_apiKey');

      final requestBody = jsonEncode({
        'contents': [{'parts': [{'text': prompt}]}],
        'generationConfig': {
          'temperature': 0.0,
          'maxOutputTokens': 400,
          'stopSequences': [],
        },
      });

      print('Calling Gemini API...');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      ).timeout(const Duration(seconds: 20));

      print('HTTP Status: ${response.statusCode}');

      if (response.statusCode != 200) {
        print('Gemini HTTP error: ${response.statusCode}');
        print('Response: ${response.body}');
        return fallback;
      }

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // Safe navigation through response
      final candidates = responseJson['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        print('No candidates in response');
        return fallback;
      }

      final content = candidates[0]['content'] as Map<String, dynamic>?;
      final parts = content?['parts'] as List?;
      if (parts == null || parts.isEmpty) {
        print('No parts in response');
        return fallback;
      }

      String rawText = (parts[0]['text'] as String? ?? '').trim();
      print('Gemini raw response: $rawText');

      // Strip all markdown
      rawText = rawText
          .replaceAll('```json', '')
          .replaceAll('```JSON', '')
          .replaceAll('```', '')
          .trim();

      // Extract JSON if there's surrounding text
      final jsonStart = rawText.indexOf('{');
      final jsonEnd = rawText.lastIndexOf('}');
      if (jsonStart >= 0 && jsonEnd > jsonStart) {
        rawText = rawText.substring(jsonStart, jsonEnd + 1);
      }

      print('Cleaned JSON: $rawText');

      final geminiProfile = jsonDecode(rawText) as Map<String, dynamic>;

      // MERGE: use Gemini result, fill gaps with local fallback
      final merged = Map<String, dynamic>.from(fallback);
      geminiProfile.forEach((key, value) {
        if (value != null && value != false && value != 0.0
            && value != '' && value != []) {
          merged[key] = value;
        }
      });

      print('Final merged profile: $merged');
      return merged;

    } on TimeoutException {
      print('Gemini timeout — using local fallback');
      return fallback;
    } on FormatException catch (e) {
      print('JSON parse error: $e — using local fallback');
      return fallback;
    } catch (e, stack) {
      print('Gemini error: $e');
      print(stack);
      return fallback;
    }
  }

  // Smart local extraction — works for all Indian languages (public for use by other screens)
  Map<String, dynamic> smartLocalExtract(String text) => _smartLocalExtract(text);

  // Smart local extraction — works for all Indian languages
  Map<String, dynamic> _smartLocalExtract(String text) {
    final t = text.toLowerCase();
    final words = text.split(RegExp(r'[\s,।\.]+'));
    print('SmartLocalExtract: Analyzing text in all languages');

    // Name extraction — word after name patterns in all languages
    String? name;
    final namePatterns = [
      // Hindi
      'नाव', 'नाम', 'मेरा नाम', 'मेरा नाम है', 'मेरा नाम हैं',
      // Marathi
      'नाव', 'माझे नाव', 'माझे नाव आहे',
      // English
      'naam', 'name is', 'my name is', 'my name',
      // Tamil
      'என் பெயர்', 'பெயர்',
      // Telugu
      'నా పేరు', 'పేరు',
      // Kannada
      'ನನ್ನ ಹೆಸರು', 'ಹೆಸರು',
      // Bengali
      'আমার নাম', 'নাম',
      // Gujarati
      'મારું નામ', 'નામ',
      // Malayalam
      'എന്റെ പേര്', 'പേര്',
      // Odia
      'ମା', 'ନାମ',
      // Punjabi
      'ਮੇਰਾ ਨਾਮ', 'ਨਾਮ',
    ];
    for (final pattern in namePatterns) {
      final idx = t.indexOf(pattern);
      if (idx >= 0) {
        final afterPattern = text.substring(idx + pattern.length).trim();
        final nameWords = afterPattern.split(RegExp(r'\s+'));
        if (nameWords.isNotEmpty && nameWords[0].isNotEmpty) {
          // Skip common words like "आहे", "है", "is", "आहे."
          final skip = ['आहे', 'है', 'is', 'am', 'आहे.', 'हैं', 'हुँ', 'ஆகும்', 'అన్ని', 'ನಾನು', 'আমি', 'હું', 'ഞാൻ', 'ମ', 'ਮੈਂ'];
          name = nameWords.firstWhere(
            (w) => !skip.contains(w.toLowerCase()) && w.length > 1,
            orElse: () => '',
          );
          if (name!.isEmpty) name = null;
          print('SmartLocalExtract: Extracted name: $name from pattern: $pattern');
        }
        break;
      }
    }

    // Age extraction — improved regex patterns for all languages
    int? age;
    // Look for number followed by age-related words in multiple languages
    final ageRegexes = [
      // Hindi: "35 साल", "35 वर्ष"
      RegExp(r'(\d{1,3})\s*(?:साल|वर्ष|वर्षों|साल का|वर्ष का)'),
      // Marathi: "35 वर्ष", "35 वय"
      RegExp(r'(\d{1,3})\s*(?:वर्ष|वय|वर्षांचा|वर्षाचा)'),
      // English: "35 years", "35 yrs"
      RegExp(r'(\d{1,3})\s*(?:years?|yrs?|year old|years old)'),
      // Tamil: "35 வயது"
      RegExp(r'(\d{1,3})\s*(?:வயது|வயதில்|வயஸு)'),
      // Telugu: "35 సంవత్సరాలు"
      RegExp(r'(\d{1,3})\s*(?:సంవత్సరాలు|సంవత్సరం|యేళ్ళు)'),
      // Kannada: "35 ವರ್ಷ"
      RegExp(r'(\d{1,3})\s*(?:ವರ್ಷ|ವಯಸ್ಸು|ವರ್ಷಗಳು)'),
      // Bengali: "35 বছর"
      RegExp(r'(\d{1,3})\s*(?:বছর|বছরের|বয়স)'),
      // Gujarati: "35 વર્ષ"
      RegExp(r'(\d{1,3})\s*(?:વર્ષ|વય|વર્ષનો)'),
      // Malayalam: "35 വയസ്സ്"
      RegExp(r'(\d{1,3})\s*(?:വയസ്സ്|വയസ്|വയ്യസ്സ്)'),
      // Odia: "35 ବର୍ଷ"
      RegExp(r'(\d{1,3})\s*(?:ବର୍ଷ|ବୟସ)'),
      // Punjabi: "35 ਸਾਲ"
      RegExp(r'(\d{1,3})\s*(?:ਸਾਲ|ਵਰ੍ਹੇ|ਉਮਰ)'),
    ];
    for (final regex in ageRegexes) {
      final ageMatch = regex.firstMatch(t);
      if (ageMatch != null) {
        age = int.tryParse(ageMatch.group(1) ?? '');
        if (age != null && age > 0 && age < 120) {
          print('SmartLocalExtract: Extracted age: $age');
          break;
        }
      }
    }
    // Fallback: look for standalone age patterns like "umr 35" or "age 35"
    if (age == null) {
      final fallbackRegex = RegExp(r'(?:umr|age|वय|उम्र|वयो)[\s:]+(\d{1,3})', caseSensitive: false);
      final match = fallbackRegex.firstMatch(t);
      if (match != null) {
        age = int.tryParse(match.group(1) ?? '');
        if (age != null && age > 0 && age < 120) {
          print('SmartLocalExtract: Extracted age (fallback): $age');
        }
      }
    }

    // Occupation detection — patterns in all languages
    String? occupation;
    // Student patterns
    if (t.contains('विद्यार्थी') || t.contains('student') ||
        t.contains('शाळा') || t.contains('कॉलेज') || t.contains('school') || t.contains('college') ||
        t.contains('10th') || t.contains('12th') || t.contains('10वी') || t.contains('12वी') ||
        t.contains('दहावी') || t.contains('बारावी') ||
        // Tamil
        t.contains('மாணவர்') || t.contains('பள்ளி') || t.contains('கல்லூரி') ||
        // Telugu
        t.contains('విద్యార్థి') || t.contains('పాఠశాల') || t.contains('కళాశాల') ||
        // Kannada
        t.contains('ವಿದ್ಯಾರ್ಥಿ') || t.contains('ಶಾಲೆ') || t.contains('ಕಾಲೇಜ್') ||
        // Bengali
        t.contains('ছাত্র') || t.contains('স্কুল') || t.contains('কলেজ') ||
        // Gujarati
        t.contains('વિદ્યાર્થી') || t.contains('શાળા') || t.contains('કૉલેજ') ||
        // Malayalam
        t.contains('വിദ്യാർത്ഥി') || t.contains('സ്കൂൾ') || t.contains('കോളേജ്') ||
        // Odia
        t.contains('ଛାତ') || t.contains('ିଦାଳ') || t.contains('କଲେଜ') ||
        // Punjabi
        t.contains('ਵਿਦਿਆਰਥੀ') || t.contains('ਸਕੂਲ') || t.contains('ਕਾਲਜ')) {
      occupation = 'student';
      print('SmartLocalExtract: Detected occupation: student');
    }
    // Farmer patterns
    else if (t.contains('शेतकरी') || t.contains('किसान') || t.contains('farmer') || t.contains('शेती') ||
        // Tamil
        t.contains('விவசாயி') || t.contains('வேளாண்') ||
        // Telugu
        t.contains('రైతు') || t.contains('రైతువాడు') ||
        // Kannada
        t.contains('ರೈತ') || t.contains('ಕೃಷಿಕ') ||
        // Bengali
        t.contains('কৃষক') || t.contains('চাষা') ||
        // Gujarati
        t.contains('ખેડૂત') || t.contains('કિસાન') ||
        // Malayalam
        t.contains('കർഷികൻ') || t.contains('കൃഷി') ||
        // Odia
        t.contains('ଚାଷା') || t.contains('କୃଷକ') ||
        // Punjabi
        t.contains('ਕਿਸਾਨ') || t.contains('ਕਿਸਾਨੀ')) {
      occupation = 'farmer';
      print('SmartLocalExtract: Detected occupation: farmer');
    }
    // Daily wage/labour patterns
    else if (t.contains('मजदूर') || t.contains('मजूर') || t.contains('labour') || t.contains('labor') ||
        t.contains('worker') || t.contains('कामगार') ||
        // Tamil
        t.contains('தொழிலாளி') || t.contains('கூலி') ||
        // Telugu
        t.contains('కూలీ') || t.contains('కార్మికుడు') ||
        // Kannada
        t.contains('ಕೂಲಿ') || t.contains('ಕಾರ್ಮಿಕರ್') ||
        // Bengali
        t.contains('শ্রমিক') || t.contains('কাজ') ||
        // Gujarati
        t.contains('મજૂર') || t.contains('કામદાર') ||
        // Malayalam
        t.contains('തൊഴിലാളി') || t.contains('വേല') ||
        // Odia
        t.contains('ଶର') || t.contains('ାର') ||
        // Punjabi
        t.contains('ਮਜਦੂਰ') || t.contains('ਮਜ਼ਦੂਰ')) {
      occupation = 'daily_wage';
      print('SmartLocalExtract: Detected occupation: daily_wage');
    }
    // Business patterns
    else if (t.contains('व्यवसाय') || t.contains('business') || t.contains('दुकान') || t.contains('shop') ||
        // Tamil
        t.contains('வணிகம்') || t.contains('கடை') ||
        // Telugu
        t.contains('వ్యాపారం') || t.contains('దుకాను') ||
        // Kannada
        t.contains('ವ್ಯಾಪಾರ') || t.contains('ಅಂಗಡಿ') ||
        // Bengali
        t.contains('ব্যবসা') || t.contains('দোকান') ||
        // Gujarati
        t.contains('વ્યવસાય') || t.contains('દુકાન') ||
        // Malayalam
        t.contains('വ്യാപാരം') || t.contains('കട') ||
        // Odia
        t.contains('ସା') || t.contains('ିକ') ||
        // Punjabi
        t.contains('ਵਪਾਰ') || t.contains('ਦੁਕਾਨ')) {
      occupation = 'business';
      print('SmartLocalExtract: Detected occupation: business');
    }
    // Government patterns
    else if (t.contains('सरकारी') || t.contains('government') || t.contains('govt') ||
        // Tamil
        t.contains('அரசு') ||
        // Telugu
        t.contains('ప్రభుత్వ') ||
        // Kannada
        t.contains('ಸರ್ಕಾರ') ||
        // Bengali
        t.contains('সরকার') ||
        // Gujarati
        t.contains('સરકાર') ||
        // Malayalam
        t.contains('സർകാർ') ||
        // Odia
        t.contains('ସରକାର') ||
        // Punjabi
        t.contains('ਸਰਕਾਰ')) {
      occupation = 'government';
      print('SmartLocalExtract: Detected occupation: government');
    }

    // Education detection — patterns in all languages
    String? education;
    // Secondary education (10th/12th/school)
    if (t.contains('दहावी') || t.contains('10th') || t.contains('10वी') ||
        t.contains('बारावी') || t.contains('12th') || t.contains('12वी') ||
        t.contains('शाळा') || t.contains('school') ||
        // Tamil
        t.contains('10ம்') || t.contains('12ம்') || t.contains('பள்ளி') ||
        // Telugu
        t.contains('10వ') || t.contains('12వ') || t.contains('పాఠశాల') ||
        // Kannada
        t.contains('10ನೇ') || t.contains('12ನೇ') || t.contains('ಶಾಲೆ') ||
        // Bengali
        t.contains('দশম') || t.contains('দ্বাদশ') || t.contains('স্কুল') ||
        // Gujarati
        t.contains('10મા') || t.contains('12મા') || t.contains('શાળા') ||
        // Malayalam
        t.contains('10ാം') || t.contains('12ാം') || t.contains('സ്കൂൾ') ||
        // Odia
        t.contains('ାଷ') || t.contains('ବବାଦଶ') || t.contains('ବିଦଭାଳ') ||
        // Punjabi
        t.contains('10ਵਾਂ') || t.contains('12ਵਾਂ') || t.contains('ਸਕੂਲ')) {
      education = 'secondary';
      print('SmartLocalExtract: Detected education: secondary');
    }
    // Graduate education (college/university)
    else if (t.contains('पदवी') || t.contains('graduate') || t.contains('college') || t.contains('university') ||
        // Tamil
        t.contains('பட்டம்') || t.contains('கல்லூரி') || t.contains('பல்கலை') ||
        // Telugu
        t.contains('డిగ్రీ') || t.contains('కళాశాల') || t.contains('విశ్వవిద్యాలయం') ||
        // Kannada
        t.contains('ಪದವಿ') || t.contains('ಕಾಲೇಜ್') || t.contains('ವಿಶ್ವವಿದ್ಯಾಲಯ') ||
        // Bengali
        t.contains('স্নাতক') || t.contains('কলেজ') || t.contains('বিশ্ববিদ্যালয') ||
        // Gujarati
        t.contains('પદવી') || t.contains('કૉલેજ') || t.contains('યુનિવર્સિટી') ||
        // Malayalam
        t.contains('ബിരുദ') || t.contains('കോളേജ്') || t.contains('സർവകലാശാല') ||
        // Odia
        t.contains('ସନ') || t.contains('ବିଦାଳ') || t.contains('ିଦ୍୯ାଳୟ') ||
        // Punjabi
        t.contains('ਗ੍ਰੈਜੂਏਟ') || t.contains('ਕਾਲਜ') || t.contains('ਯੂਨੀਵਰਸਿਟੀ')) {
      education = 'graduate';
      print('SmartLocalExtract: Detected education: graduate');
    }

    // Gender detection — patterns in all languages
    String? gender;
    if (t.contains('विधवा') || t.contains('widow') ||
        t.contains('गर्भवती') || t.contains('pregnant') ||
        t.contains('महिला') || t.contains('woman') || t.contains('female') ||
        // Tamil
        t.contains('விதவை') || t.contains('கர்ப்பமான') || t.contains('பெண்') ||
        // Telugu
        t.contains('విధవ') || t.contains('గర్భిణి') || t.contains('మహిళ') ||
        // Kannada
        t.contains('ವಿಧವೆ') || t.contains('ಗರ್ಭಿಣಿ') || t.contains('ಮಹಿಳೆ') ||
        // Bengali
        t.contains('বিধবা') || t.contains('গর্ভবতী') || t.contains('মহিলা') ||
        // Gujarati
        t.contains('વિધવા') || t.contains('ગર્ભવતી') || t.contains('મહિલા') ||
        // Malayalam
        t.contains('വിധവ') || t.contains('ഗർഭിണി') || t.contains('സ്ത്രീ') ||
        // Odia
        t.contains('ବା') || t.contains('') || t.contains('ମହିଲା') ||
        // Punjabi
        t.contains('ਵਿਧਵਾ') || t.contains('ਗਰਭਵਤੀ') || t.contains('ਔਰਤ')) {
      gender = 'female';
      print('SmartLocalExtract: Detected gender: female');
    }

    // Boolean flags — patterns in all languages
    final isWidow = t.contains('विधवा') || t.contains('widow') ||
        // Tamil
        t.contains('விதவை') ||
        // Telugu
        t.contains('విధవ') ||
        // Kannada
        t.contains('ವಿಧವೆ') ||
        // Bengali
        t.contains('বিধবা') ||
        // Gujarati
        t.contains('વિધવા') ||
        // Malayalam
        t.contains('വിധവ') ||
        // Odia
        t.contains('ବବ') ||
        // Punjabi
        t.contains('ਵਿਧਵਾ');

    final isPregnant = t.contains('गर्भवती') || t.contains('pregnant') ||
        // Tamil
        t.contains('கர்ப்பமான') ||
        // Telugu
        t.contains('గర్భిణి') ||
        // Kannada
        t.contains('ಗರ್ಭಿಣಿ') ||
        // Bengali
        t.contains('গর্ভবতী') ||
        // Gujarati
        t.contains('ગર્ભવતી') ||
        // Malayalam
        t.contains('ഗർഭിണി') ||
        // Odia
        t.contains('') ||
        // Punjabi
        t.contains('ਗਰਭਵਤੀ');

    final isDisabled = t.contains('अपंग') || t.contains('दिव्यांग') || t.contains('disabled') ||
        t.contains('handicap') ||
        // Tamil
        t.contains('ஊனமுற்றிய') || t.contains('ஊனமை') ||
        // Telugu
        t.contains('వికలాంగుడు') ||
        // Kannada
        t.contains('ದೈಹಿಕ ಅಂಗವೈಕಲ್ಯ') ||
        // Bengali
        t.contains('প্রতিবন্ধী') ||
        // Gujarati
        t.contains('અપંગ') ||
        // Malayalam
        t.contains('ശാരീരിക്കമുള്ള') ||
        // Odia
        t.contains('') ||
        // Punjabi
        t.contains('ਅਪੰਾਂਗ');

    final hasBpl = t.contains('बीपीएल') || t.contains('bpl') || t.contains('रेशन') ||
        t.contains('ration') ||
        // Tamil
        t.contains('ரேஷன்') ||
        // Telugu
        t.contains('రేషన్') ||
        // Kannada
        t.contains('ರೇಷನ್') ||
        // Bengali
        t.contains('রেশন') ||
        // Gujarati
        t.contains('રેશન') ||
        // Malayalam
        t.contains('റേഷൻ') ||
        // Odia
        t.contains('') ||
        // Punjabi
        t.contains('ਰੇਸ਼ਨ');

    final hasAadhar = t.contains('आधार') || t.contains('aadhar') || t.contains('aadhaar') ||
        // Tamil
        t.contains('ஆதார்') ||
        // Telugu
        t.contains('ఆధార్') ||
        // Kannada
        t.contains('ಆಧಾರ್') ||
        // Bengali
        t.contains('আধার') ||
        // Gujarati
        t.contains('આધાર') ||
        // Malayalam
        t.contains('ആധാർ') ||
        // Odia
        t.contains('') ||
        // Punjabi
        t.contains('ਆਧਾਰ');

    // Caste detection — patterns in all languages
    String? caste;
    if (t.contains('sc') || t.contains('scheduled caste') || t.contains('अनुसूचित जाति') ||
        t.contains('अनुसूचित') || t.contains('scheduled') ||
        t.contains('அட்டவணை சாதி') || t.contains('అనుసూచిత కులం') ||
        t.contains('ಅನುಸೂಚಿತ ಜಾತಿ') || t.contains('অনুসূচিত জাতি') ||
        t.contains('અનુસૂચિત જાતિ') || t.contains('അനുസൂചിത ജാതി') ||
        t.contains('ଅନୁସୂଚିତ ଜାତି') || t.contains('ਅਨੁਸੂਚਿਤ ਜਾਤਿ')) {
      caste = 'sc';
      print('SmartLocalExtract: Detected caste: SC');
    } else if (t.contains('st') || t.contains('scheduled tribe') || t.contains('अनुसूचित जनजाति') ||
               t.contains('जनजाति') || t.contains('tribe') ||
               t.contains('அட்டவணை பழங்குடி') || t.contains('అనుసూచిత గిరిజనులు') ||
               t.contains('ಅನುಸೂಚಿತ ಪಂಗಡ') || t.contains('অনুসূচিত উপজাতি') ||
               t.contains('અનુસૂચિત જનજાતિ') || t.contains('അനുസൂചിത വർഗം') ||
               t.contains('ଅନୁସୂଚିତ ଜନଜାତି') || t.contains('ਅਨੁਸੂਚਿਤ ਜਨਜਾਤਿ')) {
      caste = 'st';
      print('SmartLocalExtract: Detected caste: ST');
    } else if (t.contains('obc') || t.contains('other backward class') || t.contains('अन्य पिछड़ा वर्ग') ||
               t.contains('पिछड़ा') || t.contains('backward') ||
               t.contains('பிற பிற்படுத்தப்பட்ட வகுப்பு') || t.contains('ఇతర వెనుకబడిన తరగతి') ||
               t.contains('ಇತರ ಹಿಂದುಳಿದ ವರ್ಗ') || t.contains('অন্যান্য পিছিয়ে শ্রেণী') ||
               t.contains('અન્ય પછાત વર્ગ') || t.contains('മറ്റു പിന്നോക്ക വിഭാഗം') ||
               t.contains('ଅନ୍ୟାନ୍ୟ ପଛୁଆ ବର୍ଗ') || t.contains('ਅਨ ਪਛੜਾ ਵਰਗ')) {
      caste = 'obc';
      print('SmartLocalExtract: Detected caste: OBC');
    } else if (t.contains('general') || t.contains('सामान्य') || t.contains('open') ||
               t.contains('பொது') || t.contains('సాధారణ') ||
               t.contains('ಸಾಮಾನ್ಯ') || t.contains('সাধারণ') ||
               t.contains('સામાન્ય') || t.contains('സാധാരണ') ||
               t.contains('ସାଧାରଣ') || t.contains('ਆਮ')) {
      caste = 'general';
      print('SmartLocalExtract: Detected caste: General');
    }

    // Income extraction — patterns for detecting annual income
    int? annualIncome;
    final incomeRegexes = [
      // Hindi: "2 लाख", "200000", "2 lakh"
      RegExp(r'(\d{1,2})\s*(?:लाख|लाखों)'),
      RegExp(r'(\d{5,7})\s*(?:रुपये|रु|₹|rs\.?|rupees?)'),
      // English: "2 lakh", "200000", "2.5 lakh"
      RegExp(r'(\d{1,2}(?:\.\d)?)\s*(?:lakh|lac)'),
      RegExp(r'(\d{5,7})\s*(?:rs\.?|rupees?|₹)'),
      // Marathi: "2 लाख"
      RegExp(r'(\d{1,2})\s*(?:लाख)'),
      // Tamil: "2 லட்சம்"
      RegExp(r'(\d{1,2})\s*(?:லட்சம்)'),
      // Telugu: "2 లక్షలు"
      RegExp(r'(\d{1,2})\s*(?:లక్షలు|లక్ష)'),
      // Bengali: "2 লক্ষ"
      RegExp(r'(\d{1,2})\s*(?:লক্ষ)'),
    ];
    for (final regex in incomeRegexes) {
      final match = regex.firstMatch(t);
      if (match != null) {
        final value = match.group(1);
        if (value != null) {
          final numValue = double.tryParse(value);
          if (numValue != null) {
            // If value is small (like 2, 5), assume it's in lakhs and convert
            if (numValue < 10) {
              annualIncome = (numValue * 100000).toInt();
            } else {
              annualIncome = numValue.toInt();
            }
            print('SmartLocalExtract: Extracted annual income: $annualIncome');
            break;
          }
        }
      }
    }

    // Bank account detection
    final hasBankAccount = t.contains('bank') || t.contains('बैंक') || t.contains('बँक') ||
        t.contains('account') || t.contains('खाता') || t.contains('खाते') ||
        t.contains('passbook') || t.contains('पासबुक') || t.contains('passbook') ||
        t.contains('உங்க खाता') || t.contains('బ్యాంకు') ||
        t.contains('ಬ್ಯಾಂಕ್') || t.contains('ব্যাংক') ||
        t.contains('બેંક') || t.contains('ബാങ്ക്') ||
        t.contains('ବ୍ୟାଙ୍କ') || t.contains('ਬੈਂਕ');

    print('SmartLocalExtract: name=$name, age=$age, gender=$gender, occupation=$occupation, caste=$caste, income=$annualIncome, isWidow=$isWidow, isPregnant=$isPregnant, isDisabled=$isDisabled, hasBpl=$hasBpl, hasAadhar=$hasAadhar, hasBank=$hasBankAccount');

    return {
      'name': name,
      'age': age,
      'gender': gender,
      'state': null,
      'district': null,
      'caste': caste,
      'occupation': occupation,
      'annual_income': annualIncome,
      'land_holding_acres': 0.0,
      'is_disabled': isDisabled,
      'is_widow': isWidow,
      'has_bpl_card': hasBpl ? true : null,
      'has_aadhar': hasAadhar ? true : null,
      'has_bank_account': hasBankAccount ? true : null,
      'family_size': null,
      'children_ages': <int>[],
      'is_pregnant': isPregnant,
      'education_level': education,
      '_raw_transcript': text,
    };
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Match schemes using Gemini AI
  // ─────────────────────────────────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> matchSchemesWithAI(
    Map<String, dynamic> profile,
    List<Map<String, dynamic>> schemes,
  ) async {
    if (apiKey.isEmpty) return [];

    final prompt = '''You are an expert on Indian government welfare schemes.
Given a user profile and a list of schemes, return which schemes the user qualifies for.
Return ONLY a valid JSON array.

User Profile: ${jsonEncode(profile)}

Schemes: ${jsonEncode(schemes.take(40).toList())}

Expected JSON array:
[
  {
    "scheme_id": "scheme_id",
    "eligible": true,
    "confidence": 0.0 to 1.0,
    "reason": "brief eligibility reason",
    "estimated_benefit": "benefit description"
  }
]''';

    try {
      final url =
          '${ApiEndpoints.geminiBaseUrl}/models/${ApiEndpoints.geminiModel}:generateContent?key=$apiKey';
      final response = await _dio.post(url, data: {
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ]
      });

      if (response.statusCode == 200) {
        final rawText =
            response.data['candidates'][0]['content']['parts'][0]['text'] as String;
        return _parseJsonArray(rawText);
      }
    } catch (e) {
      debugPrint('[GeminiService] Matching error: $e');
    }
    return [];
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Chat response in user's language
  // ─────────────────────────────────────────────────────────────────────────
  Future<String> chat(
    String message, {
    required String languageCode,
    List<Map<String, String>> history = const [],
  }) async {
    print('AiChat.chat() called');
    print('API key empty: ${apiKey.isEmpty}');
    print('Language: $languageCode');
    print('Message: $message');

    // REAL internet check — not just connectivity_plus
    final hasNet = await _connectivityService.hasInternet();
    print('Has internet: $hasNet');

    if (!hasNet) {
      return _localizedOfflineMessage(languageCode);
    }

    if (apiKey.isEmpty) {
      return _localizedNoKeyMessage(languageCode);
    }

    final langName = _languageNames[languageCode] ?? 'Hindi';
    final systemInstruction =
        'You are Adhikar AI, a helpful assistant for Indian '
        'government welfare schemes. You MUST reply ONLY in '
        '$langName language. Never use English unless the user '
        'writes in English. Be warm, simple, and helpful.';

    // Build conversation history
    final contents = <Map<String, dynamic>>[];

    // Add system context as first message pair
    contents.add({
      'role': 'user',
      'parts': [{'text': systemInstruction}]
    });
    contents.add({
      'role': 'model',
      'parts': [{'text': localizedGreeting(languageCode)}]
    });

    // Add history
    for (final h in history) {
      contents.add({
        'role': h['role'] == 'user' ? 'user' : 'model',
        'parts': [{'text': h['content']}],
      });
    }

    // Add current message
    contents.add({
      'role': 'user',
      'parts': [{'text': message}],
    });

    try {
      final url =
          '${ApiEndpoints.geminiBaseUrl}/models/${ApiEndpoints.geminiModel}:generateContent?key=$apiKey';

      final response = await _dio.post(url, data: {
        'contents': contents,
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 1024,
        },
      }).timeout(const Duration(seconds: 30));

      print('Gemini chat HTTP ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        return data['candidates'][0]['content']['parts'][0]['text']
            as String;
      } else {
        print('Gemini chat error: ${response.data}');
        return _localizedErrorMessage(languageCode);
      }

    } on DioException catch (e) {
      print('Gemini chat DioException: ${e.message}');
      return _localizedErrorMessage(languageCode);
    } catch (e) {
      print('Gemini chat exception: $e');
      return _localizedErrorMessage(languageCode);
    }
  }

  String localizedGreeting(String code) => {
    'en': 'Hello! I am Adhikar AI. Ask me anything about government schemes.',
    'hi': 'नमस्ते! मैं अधिकार AI हूँ। सरकारी योजनाओं के बारे में कुछ भी पूछें।',
    'mr': 'नमस्कार! मी अधिकार AI आहे. सरकारी योजनांबद्दल काहीही विचारा.',
    'ta': 'வணக்கம்! நான் அதிகார் AI. அரசு திட்டங்களைப் பற்றி எதையும் கேளுங்கள்.',
    'te': 'నమస్కారం! నేను అధికార్ AI. ప్రభుత్వ పథకాల గురించి ఏదైనా అడగండి.',
    'kn': 'ನಮಸ್ಕಾರ! ನಾನು ಅಧಿಕಾರ್ AI. ಸರ್ಕಾರಿ ಯೋಜನೆಗಳ ಬಗ್ಗೆ ಏನನ್ನಾದರೂ ಕೇಳಿ.',
    'bn': 'নমস্কার! আমি অধিকার AI। সরকারি প্রকল্প সম্পর্কে যেকোনো প্রশ্ন করুন।',
    'gu': 'નમસ્કાર! હું અધિકાર AI છું. સરકારી યોજનાઓ વિશે કંઈ પણ પૂછો.',
  }[code] ?? 'नमस्ते! मैं अधिकार AI हूँ।';

  String _localizedOfflineMessage(String code) => {
    'en': 'No internet connection. Please check and try again.',
    'hi': 'इंटरनेट नहीं है। कृपया जांचें और पुनः प्रयास करें।',
    'mr': 'इंटरनेट कनेक्शन नाही. कृपया तपासा आणि पुन्हा प्रयत्न करा.',
    'ta': 'இணைய இணைப்பு இல்லை. சரிபார்த்து மீண்டும் முயற்சிக்கவும்.',
    'te': 'ఇంటర్నెట్ కనెక్షన్ లేదు. దయచేసి తనిఖీ చేసి మళ్ళీ ప్రయత్నించండి.',
    'kn': 'ಇಂಟರ್ನೆಟ್ ಸಂಪರ್ಕವಿಲ್ಲ. ದಯವಿಟ್ಟು ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.',
  }[code] ?? 'इंटरनेट नहीं है।';

  String _localizedNoKeyMessage(String code) => {
    'en': 'AI service not configured. Please set GEMINI_API_KEY.',
    'hi': 'AI सेवा कॉन्फ़िगर नहीं है। GEMINI_API_KEY सेट करें।',
    'mr': 'AI सेवा कॉन्फिगर केलेली नाही. GEMINI_API_KEY सेट करा.',
  }[code] ?? 'AI सेवा उपलब्ध नहीं।';

  String _localizedErrorMessage(String code) => {
    'en': 'Something went wrong. Please try again.',
    'hi': 'कुछ गड़बड़ हुई। कृपया पुनः प्रयास करें।',
    'mr': 'काहीतरी चुकले. कृपया पुन्हा प्रयत्न करा.',
    'ta': 'ஏதோ தவறு நடந்தது. மீண்டும் முயற்சிக்கவும்.',
    'te': 'ఏదో తప్పు జరిగింది. మళ్ళీ ప్రయత్నించండి.',
  }[code] ?? 'कुछ गड़बड़ हुई।';

  String _localizedTimeoutMessage(String code) => {
    'en': 'Request timed out. Please try again.',
    'hi': 'अनुरोध समय सीमा समाप्त। पुनः प्रयास करें।',
    'mr': 'विनंती वेळ संपली. पुन्हा प्रयत्न करा.',
  }[code] ?? 'समय सीमा समाप्त।';

  static const _languageNames = {
    'en': 'English', 'hi': 'Hindi', 'mr': 'Marathi',
    'ta': 'Tamil', 'te': 'Telugu', 'kn': 'Kannada',
    'bn': 'Bengali', 'gu': 'Gujarati', 'ml': 'Malayalam',
    'or': 'Odia', 'pa': 'Punjabi',
  };

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────

  Map<String, dynamic> _parseJson(String text) {
    try {
      // Remove markdown code blocks if present
      text = text.replaceAll('```json', '').replaceAll('```', '').trim();
      
      // Find JSON object boundaries
      final start = text.indexOf('{');
      final end = text.lastIndexOf('}');
      if (start == -1 || end == -1) {
        debugPrint('[GeminiService] No JSON object found in response');
        return _getEmptyProfile();
      }
      
      final jsonText = text.substring(start, end + 1);
      final decoded = jsonDecode(jsonText) as Map<String, dynamic>;
      
      // Validate required fields exist
      if (!decoded.containsKey('confidence')) {
        debugPrint('[GeminiService] Missing confidence field in response');
        decoded['confidence'] = 0.0;
      }
      if (!decoded.containsKey('missing_info')) {
        decoded['missing_info'] = <String>[];
      }
      
      return decoded;
    } on FormatException catch (e) {
      debugPrint('[GeminiService] JSON format error: $e');
      return _getEmptyProfile();
    } catch (e) {
      debugPrint('[GeminiService] JSON parse error: $e');
      return _getEmptyProfile();
    }
  }

  List<Map<String, dynamic>> _parseJsonArray(String text) {
    try {
      text = text.replaceAll('```json', '').replaceAll('```', '').trim();
      final start = text.indexOf('[');
      final end = text.lastIndexOf(']');
      if (start == -1 || end == -1) return [];
      final decoded = jsonDecode(text.substring(start, end + 1)) as List;
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('[GeminiService] JSON array parse error: $e');
      return [];
    }
  }

  /// Simple keyword-based offline extraction fallback
  Map<String, dynamic> _extractOffline(String text) {
    final lower = text.toLowerCase();
    return {
      'name': '',
      'age': 0,
      'gender': lower.contains('female') || lower.contains('woman') || lower.contains('महिला')
          ? 'female'
          : lower.contains('male') || lower.contains('man')
              ? 'male'
              : '',
      'state': '',
      'district': '',
      'caste': lower.contains('obc')
          ? 'obc'
          : lower.contains(' sc ') || lower.contains('scheduled caste')
              ? 'sc'
              : lower.contains(' st ') || lower.contains('scheduled tribe')
                  ? 'st'
                  : 'general',
      'occupation': lower.contains('farmer') || lower.contains('kisan') || lower.contains('किसान')
          ? 'farmer'
          : lower.contains('labour') || lower.contains('worker') || lower.contains('मजदूर')
              ? 'daily_wage'
              : '',
      'annual_income': lower.contains('bpl') ? 40000 : 0,
      'land_holding': 0,
      'is_disabled': lower.contains('disab') || lower.contains('दिव्यांग'),
      'is_widow': lower.contains('widow') || lower.contains('विधवा'),
      'has_bpl_card': lower.contains('bpl'),
      'has_aadhar': lower.contains('aadhar') || lower.contains('aadhaar') || lower.contains('आधार'),
      'has_bank_account': lower.contains('bank') || lower.contains('account'),
      'family_size': 0,
      'children_ages': <int>[],
      'is_pregnant': lower.contains('pregnant') || lower.contains('गर्भवती'),
      'education_level': '',
      'confidence': 0.4,
      'missing_info': ['Extracted offline — please verify'],
    };
  }

  Map<String, dynamic> _getEmptyProfile() => {
        'name': '',
        'age': 0,
        'gender': '',
        'state': '',
        'district': '',
        'caste': '',
        'occupation': '',
        'annual_income': 0,
        'land_holding': 0,
        'is_disabled': false,
        'is_widow': false,
        'has_bpl_card': false,
        'has_aadhar': false,
        'has_bank_account': false,
        'family_size': 0,
        'children_ages': <int>[],
        'is_pregnant': false,
        'education_level': '',
        'confidence': 0.0,
        'missing_info': ['Could not extract from input'],
      };
}
