import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/api_endpoints.dart';

class GeminiService {
  final Dio _dio = Dio();

  String apiKey = const String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  GeminiService() {
    _dio.options
      ..connectTimeout = const Duration(seconds: 30)
      ..receiveTimeout = const Duration(seconds: 30);
  }

  void setApiKey(String key) => apiKey = key;

  // ─────────────────────────────────────────────────────────────────────────
  // Extract user profile from voice transcript using Gemini AI
  // ─────────────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> extractProfile(
    String text, {
    String languageHint = '',
  }) async {
    if (apiKey.isEmpty) {
      debugPrint('[GeminiService] No API key — using offline extraction');
      return _extractOffline(text);
    }

    final langNote = languageHint.isNotEmpty
        ? '\n$languageHint'
        : '';

    final prompt = '''You are a government welfare eligibility assistant for India.$langNote
Extract structured profile information from the user\'s voice description.
Return ONLY valid JSON. No explanation, no markdown, no code blocks.

User\'s description:
$text

Expected JSON format:
{
  "name": "full name or empty string",
  "age": age in years as integer,
  "gender": "male/female/other or empty",
  "state": "state name or empty",
  "district": "district name or empty",
  "caste": "general/obc/sc/st or empty",
  "occupation": "farmer/daily_wage/unemployed/teacher/etc or empty",
  "annual_income": annual income in rupees as integer,
  "land_holding": land in acres as number,
  "is_disabled": true or false,
  "is_widow": true or false,
  "has_bpl_card": true or false,
  "has_aadhar": true or false,
  "has_bank_account": true or false,
  "family_size": number of family members as integer,
  "children_ages": [],
  "is_pregnant": true or false,
  "education_level": "illiterate/primary/secondary/graduate or empty",
  "confidence": 0.0 to 1.0,
  "missing_info": ["list of info that could not be extracted"]
}

Use null or empty/0 for fields you cannot determine.''';

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
          'temperature': 0.1,
          'maxOutputTokens': 1024,
        }
      });

      if (response.statusCode == 200) {
        final rawText =
            response.data['candidates'][0]['content']['parts'][0]['text'] as String;
        return _parseJson(rawText);
      } else {
        throw Exception('Gemini API error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('[GeminiService] Network error: ${e.message}');
      return _extractOffline(text);
    } catch (e) {
      debugPrint('[GeminiService] Extraction error: $e');
      return _extractOffline(text);
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
      text = text.replaceAll('```json', '').replaceAll('```', '').trim();
      final start = text.indexOf('{');
      final end = text.lastIndexOf('}');
      if (start == -1 || end == -1) return _getEmptyProfile();
      return jsonDecode(text.substring(start, end + 1)) as Map<String, dynamic>;
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
