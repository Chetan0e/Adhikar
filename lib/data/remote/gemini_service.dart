import 'dart:async';
import 'dart:convert';
import 'dart:core';
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
    print('╔══════════════════════════════════════╗');
    print('║  GeminiService INITIALIZATION         ║');
    print('╚══════════════════════════════════════╝');
    
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
    print('GeminiService: API key length: ${_apiKey.length}');
    print('GeminiService: First 8 chars: ${_apiKey.length > 8 ? _apiKey.substring(0, 8) : "N/A"}');
    print('╚══════════════════════════════════════╝');
  }

  String get apiKey => _apiKey;

  void setApiKey(String key) => _apiKey = key;

  // ─────────────────────────────────────────────────────────────────────────
  // Extract user profile from voice transcript using Gemini AI
  // ─────────────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> extractProfile(String transcript) async {
    print('extractProfile() CALLED');
    print('API KEY: "${_apiKey.substring(0, _apiKey.length > 8 ? 8 : _apiKey.length)}..." length=${_apiKey.length}');
    print('Transcript: "$transcript"');

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

  // Public wrapper for testing
  Map<String, dynamic> testLocalExtract(String text) => _smartLocalExtract(text);

  // Smart local extraction — works for all Indian languages
  Map<String, dynamic> _smartLocalExtract(String text) {
    // ── SETUP ─────────────────────────────────────────
    final orig = text.trim();
    // Normalize: remove zero-width chars, extra spaces
    final clean = orig
        .replaceAll('\u200b', '')
        .replaceAll('\u200c', '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final lower = clean.toLowerCase();

    print('╔═ _smartLocalExtract ════════════════════════╗');
    print('║ Input: "$clean"');
    print('╚═════════════════════════════════════════════╝');

    // ── 1. NAME ───────────────────────────────────────
    // Target: "माझे नाव चेतन आहे" → "चेतन"
    // Strategy: find trigger word, take NEXT non-filler word
    String? name;

    const nameTriggers = [
      'माझे नाव', 'माझं नाव',   // Marathi
      'मेरा नाम', 'मेरो नाम',   // Hindi
      'my name is', 'name is',   // English
      'நான் பெயர்', 'என் பெயர்', // Tamil
      'నా పేరు', 'నా పేరు',      // Telugu
      'ನನ್ನ ಹೆಸರು',              // Kannada
      'আমার নাম',               // Bengali
      'मारो नाम', 'मारू नाम',   // Gujarati
    ];

    const nameFillers = {
      'आहे', 'आहे.', 'है', 'है.', 'is', 'am', 'are',
      'हूं', 'हूँ', 'हो', 'था', 'थी', 'ते',
      'मी', 'मि', 'mi', 'the', 'a', 'an', 'my',
      'माझे', 'माझं', 'मेरा', 'मेरो',
    };

    for (final trigger in nameTriggers) {
      final idx = lower.indexOf(trigger.toLowerCase());
      if (idx == -1) continue;

      // Get text after the trigger
      final afterTrigger = clean.substring(idx + trigger.length).trim();
      final parts = afterTrigger.split(RegExp(r'\s+'));

      for (final part in parts) {
        final p = part.replaceAll(RegExp(r'[।,.!?]'), '').trim();
        if (p.isEmpty) continue;
        if (nameFillers.contains(p.toLowerCase())) continue;
        if (p.length < 2) continue;
        // Likely a name — take it
        name = p;
        break;
      }
      if (name != null) break;
    }

    print('NAME: $name');

    // ── 2. OCCUPATION ─────────────────────────────────
    // Check BEFORE gender because Marathi verbs are gendered
    String? occupation;

    // Order matters: more specific first
    const occupationKeywords = <String, List<String>>{
      'student': [
        'विद्यार्थी', 'विद्यार्थि',    // Marathi/Hindi
        'student', 'students',
        'शाळा', 'शाळेत',              // Marathi school
        'कॉलेज', 'college',
        'दहावी', 'दहावीच्या',          // 10th Marathi
        'बारावी', 'बारावीच्या',         // 12th Marathi
        'दसवीं', '10वीं',              // Hindi 10th
        'बारहवीं', '12वीं',
        '10th', '12th', 'ssc', 'hsc',
        'शिकतो', 'शिकते', 'शिकतोय',   // Marathi "studying"
        'शिकत', 'पढ़ता', 'पढ़ती',       // Hindi
        'पदवीधर', 'graduate',
        'vidyarthi',
      ],
      'farmer': [
        'शेतकरी', 'शेतकरि',
        'किसान', 'farmer',
        'शेती', 'शेत', 'खेती', 'खेत',
        'రైతు', 'விவசாயி', 'ರೈತ', 'কৃষক',
        'kisan',
      ],
      'daily_wage': [
        'मजूर', 'मजुर', 'मजदूर',
        'labour', 'laborer', 'worker',
        'कामगार',
        'కూలీ', 'தொழிலாளி',
      ],
      'business': [
        'व्यवसाय', 'व्यापार',
        'business', 'shop', 'दुकान', 'दुकानदार',
        'వ్యాపారం', 'வியாபாரம்',
      ],
      'government': [
        'सरकारी', 'government', 'govt',
        'नोकरी', 'job', 'service',
        'அரசு', 'అరసు',
      ],
      'unemployed': [
        'बेरोजगार', 'unemployed',
        'नोकरी नाही', 'काम नाही',
        'வேலையில்லா',
      ],
    };

    for (final entry in occupationKeywords.entries) {
      final found = entry.value.any((kw) =>
          lower.contains(kw.toLowerCase()));
      if (found) {
        occupation = entry.key;
        print('OCCUPATION: $occupation');
        break;
      }
    }

    // ── 3. EDUCATION ──────────────────────────────────
    String? education;

    if ([
      'दहावी', 'दहावीच्या', 'दहावीचे', '10th', '10वी', '10वीं',
      'बारावी', 'बारावीच्या', '12th', '12वी', '12वीं',
      'ssc', 'hsc', 'school', 'शाळा', 'माध्यमिक',
      'मराठी माध्यम', 'english medium', 'semi english',
    ].any((k) => lower.contains(k.toLowerCase()))) {
      education = 'secondary';
    } else if ([
      'पदवी', 'graduate', 'college', 'university',
      'बीए', 'b.a', 'bsc', 'bcom', 'engineering',
      'इंजिनिअरिंग', 'पदव्युत्तर', 'postgraduate',
    ].any((k) => lower.contains(k.toLowerCase()))) {
      education = 'graduate';
    } else if ([
      'primary', 'प्राथमिक', '5th', '7th', '8th',
    ].any((k) => lower.contains(k.toLowerCase()))) {
      education = 'primary';
    }

    print('EDUCATION: $education');

    // ── 4. GENDER ─────────────────────────────────────
    // Marathi is grammatically gendered — verbs tell us
    String? gender;

    // Male verb forms in Marathi: राहतो, शिकतो, करतो, जातो
    const maleIndicators = [
      'राहतो', 'शिकतो', 'करतो', 'जातो', 'येतो',  // Marathi male verbs
      'आहे मी', // generic but with male context
      'मुलगा', 'boy', 'भाऊ', 'brother',
      'बाबा', 'father', 'अण्णा',
      'అతను', 'ಅವನು', 'அவன்',
    ];

    const femaleIndicators = [
      'राहते', 'शिकते', 'करते', 'जाते', 'येते', // Marathi female verbs
      'विधवा', 'widow',
      'गर्भवती', 'pregnant',
      'महिला', 'woman', 'बाई', 'ताई',
      'मुलगी', 'girl', 'बहीण', 'sister',
      'आई', 'mother', 'ती', 'तिचे', 'तिला',
      'amma', 'ఆమె', 'ಅವಳು',
    ];

    if (femaleIndicators.any((k) => lower.contains(k.toLowerCase()))) {
      gender = 'female';
    } else if (maleIndicators.any((k) => lower.contains(k.toLowerCase()))) {
      gender = 'male';
    }

    print('GENDER: $gender');

    // ── 5. STATE ──────────────────────────────────────
    String? state;

    // Key: include locative forms like "महाराष्ट्रात" (in Maharashtra)
    const stateKeywords = <String, List<String>>{
      'Maharashtra': [
        'महाराष्ट्र', 'महाराष्ट्रात', 'महाराष्ट्राच्या',
        'maharashtra',
      ],
      'Uttar Pradesh': [
        'उत्तर प्रदेश', 'uttar pradesh', 'यूपी', 'up ',
      ],
      'Bihar': ['बिहार', 'bihar'],
      'Rajasthan': ['राजस्थान', 'rajasthan'],
      'Madhya Pradesh': ['मध्य प्रदेश', 'madhya pradesh'],
      'Gujarat': ['गुजरात', 'gujarat', 'ગુજરાત'],
      'Karnataka': ['कर्नाटक', 'karnataka', 'ಕರ್ನಾಟಕ'],
      'Tamil Nadu': ['तमिलनाडु', 'tamil nadu', 'தமிழ்நாடு'],
      'Andhra Pradesh': ['आंध्र प्रदेश', 'andhra', 'ఆంధ్రప్రదేశ్'],
      'Telangana': ['तेलंगाना', 'telangana', 'తెలంగాణ'],
      'West Bengal': ['पश्चिम बंगाल', 'west bengal', 'পশ্চিমবঙ্গ'],
      'Punjab': ['पंजाब', 'punjab', 'ਪੰਜਾਬ'],
      'Kerala': ['केरल', 'kerala'],
      'Odisha': ['ओडिशा', 'odisha'],
      'Haryana': ['हरियाणा', 'haryana'],
      'Chhattisgarh': ['छत्तीसगढ़', 'chhattisgarh'],
      'Jharkhand': ['झारखंड', 'jharkhand'],
      'Assam': ['असम', 'assam'],
    };

    for (final entry in stateKeywords.entries) {
      if (entry.value.any((kw) => lower.contains(kw.toLowerCase()))) {
        state = entry.key;
        print('STATE: $state');
        break;
      }
    }

    // ── 6. ANNUAL INCOME ──────────────────────────────
    int? annualIncome;

    // Map word-numbers in Marathi, Hindi, English
    // Note: Using final (not const) because Marathi/Hindi share some words
    final wordToNum = <String, int>{
      // Marathi (unique words first)
      'दोन': 2, 'नऊ': 9, 'दहा': 10,
      'वीस': 20, 'पन्नास': 50,
      // Hindi (unique words)
      'दो': 2, 'पाँच': 5, 'छह': 6, 'नौ': 9, 'दस': 10,
      'बीस': 20, 'पचास': 50,
      // Shared Marathi/Hindi words
      'एक': 1, 'तीन': 3, 'चार': 4, 'सात': 7, 'आठ': 8,
      'तीस': 30,
      // English
      'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5,
      'six': 6, 'seven': 7, 'eight': 8, 'nine': 9, 'ten': 10,
      'twenty': 20, 'thirty': 30, 'fifty': 50,
    };

    // Try: digit + lakh  →  "2 lakh", "2.5 lakh"
    final digitLakh = RegExp(
      r'(\d+(?:\.\d+)?)\s*(?:lakh|लाख|लख|లక్ష|லட்சம்|ಲಕ್ಷ|লাখ)',
      caseSensitive: false,
    );
    var m = digitLakh.firstMatch(lower);
    if (m != null) {
      final n = double.tryParse(m.group(1) ?? '');
      if (n != null && n > 0) {
        annualIncome = (n * 100000).round();
        print('INCOME (digit lakh): $annualIncome');
      }
    }

    // Try: word + lakh  →  "एक लाख", "दोन लाख"
    if (annualIncome == null) {
      for (final entry in wordToNum.entries) {
        final pattern = RegExp(
          '${RegExp.escape(entry.key)}\\s*(?:lakh|लाख|लख)',
          caseSensitive: false,
        );
        if (pattern.hasMatch(lower)) {
          annualIncome = entry.value * 100000;
          print('INCOME (word lakh "${entry.key}"): $annualIncome');
          break;
        }
      }
    }

    // Try: plain digit near income keyword  →  "उत्पन्न 50000"
    if (annualIncome == null) {
      final incomeKeyword = RegExp(
        r'(?:उत्पन्न|income|आय|कमाई|वेतन|salary|పాప|வருமான)'
        r'\s+(?:is\s+|आहे\s+|है\s+)?(\d[\d,]+)',
        caseSensitive: false,
      );
      final km = incomeKeyword.firstMatch(lower);
      if (km != null) {
        final n = int.tryParse((km.group(1) ?? '').replaceAll(',', ''));
        if (n != null && n >= 1000) {
          annualIncome = n;
          print('INCOME (keyword): $annualIncome');
        }
      }
    }

    // ── 7. AGE ────────────────────────────────────────
    int? age;

    final agePatterns = [
      // "45 वर्ष", "45 years", "45 साल", "45 वर्षांचा/ची"
      RegExp(
        r'(\d{1,3})\s*(?:वर्ष|वर्षांचा|वर्षांची|वर्षाचा|वर्षाची|'
        r'years?|साल|वय|yr|yrs|సంవత్సరాలు|வயது|ವರ್ಷ|বছর)',
        caseSensitive: false,
      ),
      // "वय 45", "age 45"
      RegExp(
        r'(?:वय|age|उम्र|आयु)\s+(\d{1,3})',
        caseSensitive: false,
      ),
    ];

    for (final p in agePatterns) {
      final am = p.firstMatch(lower);
      if (am != null) {
        // Try group 1 first, then group 2
        final numStr = am.group(1) ?? am.group(2);
        final a = int.tryParse(numStr ?? '');
        if (a != null && a >= 5 && a <= 100) {
          age = a;
          print('AGE: $age');
          break;
        }
      }
    }

    // ── 8. CASTE ─────────────────────────────────────
    String? caste;

    const casteKeywords = <String, List<String>>{
      'sc': ['sc', 'scheduled caste', 'अनुसूचित जाती', 'दलित', 'महार', 'मांग'],
      'st': ['st', 'scheduled tribe', 'अनुसूचित जमाती', 'आदिवासी', 'tribal'],
      'obc': ['obc', 'other backward', 'ओबीसी', 'इतर मागास', 'माळी', 'कुणबी'],
      'general': ['general', 'open', 'खुला', 'सामान्य', 'ब्राह्मण', 'मराठा'],
      'minority': ['minority', 'अल्पसंख्यांक', 'muslim', 'christian', 'मुस्लिम'],
    };

    for (final entry in casteKeywords.entries) {
      if (entry.value.any((k) => lower.contains(k.toLowerCase()))) {
        caste = entry.key;
        print('CASTE: $caste');
        break;
      }
    }

    // ── 9. BOOLEAN FLAGS ──────────────────────────────
    final isWidow = [
      'विधवा', 'widow', 'पतीचे निधन', 'नवरा गेला',
      'husband died', 'husband passed',
    ].any((k) => lower.contains(k.toLowerCase()));

    final isPregnant = [
      'गर्भवती', 'pregnant', 'गर्भ', 'बाळंत', 'प्रसूती',
      'గర్భిణి', 'கர்ப்பிணி',
    ].any((k) => lower.contains(k.toLowerCase()));

    final isDisabled = [
      'अपंग', 'दिव्यांग', 'disabled', 'disability',
      'wheelchair', 'अंध', 'बहिरे', 'व्यंग',
    ].any((k) => lower.contains(k.toLowerCase()));

    final hasBpl = [
      'बीपीएल', 'bpl', 'रेशन', 'गरीब रेषा', 'ration card',
      'below poverty', 'दारिद्र्य रेषा',
    ].any((k) => lower.contains(k.toLowerCase()));

    final hasAadhar = [
      'आधार', 'aadhar', 'aadhaar', 'uid',
    ].any((k) => lower.contains(k.toLowerCase()));

    final hasBankAccount = [
      'बँक', 'bank', 'खाते', 'account', 'बचत', 'savings',
    ].any((k) => lower.contains(k.toLowerCase()));

    // ── 10. FAMILY SIZE ───────────────────────────────
    int? familySize;
    final familyRegex = RegExp(
      r'(\d+)\s*(?:जण|members?|सदस्य|लोक|जना|माणसे)',
      caseSensitive: false,
    );
    final fm = familyRegex.firstMatch(lower);
    if (fm != null) {
      familySize = int.tryParse(fm.group(1) ?? '');
      print('FAMILY SIZE: $familySize');
    }

    // ── COMPILE RESULT ────────────────────────────────
    final result = <String, dynamic>{
      'name': name,
      'age': age,
      'gender': gender,
      'state': state,
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
      'family_size': familySize,
      'children_ages': <int>[],
      'is_pregnant': isPregnant,
      'education_level': education,
      '_raw_transcript': orig,
    };

    // Count extracted fields
    final extracted = result.entries
        .where((e) => e.key != '_raw_transcript' && e.value != null
            && e.value != false && e.value != 0.0 && e.value != <int>[])
        .map((e) => '${e.key}=${e.value}')
        .join(', ');
    print('EXTRACTED: $extracted');

    return result;
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
    print('╔══════════════════════════════════════╗');
    print('║  GeminiService.chat() CALLED          ║');
    print('╚══════════════════════════════════════╝');
    print('API key empty: ${apiKey.isEmpty}');
    print('API key length: ${apiKey.length}');
    print('Language: $languageCode');
    print('Message: $message');

    // REAL internet check — not just connectivity_plus
    final hasNet = await _connectivityService.hasInternet();
    print('Has internet: $hasNet');

    if (!hasNet) {
      print('ERROR: No internet connection');
      return _localizedOfflineMessage(languageCode);
    }

    if (apiKey.isEmpty) {
      print('ERROR: API key is empty');
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

      print('Making HTTP POST to: ${ApiEndpoints.geminiBaseUrl}/models/${ApiEndpoints.geminiModel}:generateContent');
      print('Request body contents length: ${contents.length}');

      final response = await _dio.post(url, data: {
        'contents': contents,
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 1024,
        },
      }).timeout(const Duration(seconds: 30));

      print('Gemini chat HTTP status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        final reply = data['candidates'][0]['content']['parts'][0]['text'] as String;
        print('Gemini reply received: ${reply.substring(0, reply.length > 100 ? 100 : reply.length)}...');
        return reply;
      } else {
        print('Gemini chat error response: ${response.data}');
        return _localizedErrorMessage(languageCode);
      }

    } on DioException catch (e) {
      print('Gemini chat DioException: ${e.message}');
      print('DioException type: ${e.type}');
      print('DioException response: ${e.response}');
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
