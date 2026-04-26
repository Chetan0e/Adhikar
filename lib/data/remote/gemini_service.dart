import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/services/connectivity_service.dart';

class GeminiService {
  final Dio _dio = Dio();
  final ConnectivityService _connectivityService;

  String apiKey = dotenv.env['GEMINI_API_KEY'] ?? 
                  const String.fromEnvironment(
                    'GEMINI_API_KEY',
                    defaultValue: '',
                  );

  GeminiService({ConnectivityService? connectivityService})
      : _connectivityService = connectivityService ?? ConnectivityService();

  void setApiKey(String key) => apiKey = key;

  // ─────────────────────────────────────────────────────────────────────────
  // Extract user profile from voice transcript using Gemini AI
  // ─────────────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> extractProfile(
    String text, {
    String languageHint = '',
  }) async {
    print('[GeminiService] extractProfile called with text: "${text.substring(0, text.length > 50 ? 50 : text.length)}..."');
    
    // Guard: empty transcript
    if (text.trim().length < 5) {
      print('[GeminiService] WARN: Transcript too short: "$text"');
      return _extractOffline(text)..['_is_fallback'] = true;
    }

    // Guard: no API key
    if (apiKey.isEmpty) {
      print('[GeminiService] ERROR: GEMINI_API_KEY is empty! Run with --dart-define=GEMINI_API_KEY=your_key');
      return _extractOffline(text)..['_is_fallback'] = true;
    }

    // Check actual internet connectivity
    final hasInternet = await _connectivityService.hasInternet();
    if (!hasInternet) {
      print('[GeminiService] No internet connection — using offline extraction');
      return _extractOffline(text)..['_is_fallback'] = true;
    }

    final langNote = languageHint.isNotEmpty
        ? '\n$languageHint'
        : '';

    final prompt = '''Extract information from this text spoken by an Indian citizen.
Text may be in Hindi, Marathi, Tamil, Telugu, Kannada, or other Indian language.
Return ONLY a valid JSON object with no explanation and no markdown.

Text: "$text"

Return exactly this JSON (null for unknown values):
{
  "name": null,
  "age": null,
  "gender": null,
  "state": null,
  "district": null,
  "caste": null,
  "occupation": null,
  "annual_income": null,
  "land_holding_acres": null,
  "is_disabled": false,
  "is_widow": false,
  "has_bpl_card": null,
  "has_aadhar": null,
  "has_bank_account": null,
  "family_size": null,
  "children_ages": [],
  "is_pregnant": false,
  "education_level": null,
  "confidence": 0.0 to 1.0,
  "missing_info": []
}''';

    try {
      print('[GeminiService] Calling Gemini API...');
      final url =
          '${ApiEndpoints.geminiBaseUrl}/models/${ApiEndpoints.geminiModel}:generateContent?key=$apiKey';
      final response = await _dio.post(url, data: {
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.0,
          'maxOutputTokens': 512,
        }
      }).timeout(const Duration(seconds: 20));

      print('[GeminiService] HTTP status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final rawText =
            response.data['candidates'][0]['content']['parts'][0]['text'] as String;
        print('[GeminiService] Raw response: $rawText');
        
        final profile = _parseJson(rawText);
        print('[GeminiService] Parsed profile: $profile');
        debugPrint('[GeminiService] Profile extracted successfully');
        return profile;
      } else {
        print('[GeminiService] API error: ${response.statusCode}');
        print('[GeminiService] Error body: ${response.data}');
        return _extractOffline(text)..['_is_fallback'] = true;
      }
    } on DioException catch (e) {
      print('[GeminiService] Network error: ${e.message}');
      return _extractOffline(text)..['_is_fallback'] = true;
    } catch (e) {
      print('[GeminiService] Extraction error: $e');
      return _extractOffline(text)..['_is_fallback'] = true;
    }
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
  Future<String> chat(String userMessage, {String languageCode = 'en'}) async {
    if (apiKey.isEmpty) {
      return 'AI chat is not available offline. Please check your internet connection.';
    }

    // Check actual internet connectivity
    final hasInternet = await _connectivityService.hasInternet();
    if (!hasInternet) {
      return 'AI chat is not available offline. Please check your internet connection.';
    }

    const langInstructions = {
      'hi': 'Respond strictly in Hindi (Devanagari script).',
      'mr': 'Respond strictly in Marathi (Devanagari script).',
      'ta': 'Respond strictly in Tamil.',
      'te': 'Respond strictly in Telugu.',
      'kn': 'Respond strictly in Kannada.',
      'bn': 'Respond strictly in Bengali.',
      'gu': 'Respond strictly in Gujarati.',
      'ml': 'Respond strictly in Malayalam.',
      'or': 'Respond strictly in Odia.',
      'pa': 'Respond strictly in Punjabi (Gurmukhi script).',
    };

    final langNote = langInstructions[languageCode] ?? '';
    final prompt = '''You are Adhikar AI, a helpful assistant for Indian government welfare schemes.
$langNote
Answer the user's question clearly, briefly, and helpfully.
Focus only on government schemes, eligibility, documents, and benefits.

User: $userMessage''';

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
        ],
        'generationConfig': {
          'temperature': 0.4,
          'maxOutputTokens': 512,
        }
      });

      if (response.statusCode == 200) {
        return response.data['candidates'][0]['content']['parts'][0]['text']
            as String;
      }
    } on DioException catch (e) {
      debugPrint('[GeminiService] Chat network error: ${e.message}');
      return 'AI chat is not available offline. Please check your internet connection.';
    } catch (e) {
      debugPrint('[GeminiService] Chat error: $e');
    }
    return 'Sorry, I could not get a response. Please try again.';
  }

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
