import 'package:dio/dio.dart';
import '../constants/api_endpoints.dart';

class GeminiService {
  final Dio _dio = Dio();
  
  // Replace with your actual Gemini API key
  // Get from: https://makersuite.google.com/app/apikey
  String apiKey = const String.fromEnvironment('GEMINI_API_KEY', defaultValue: 'YOUR_API_KEY');

  GeminiService() {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  /// Set API key
  void setApiKey(String key) {
    apiKey = key;
  }

  /// Extract user profile from voice transcript using Gemini AI
  Future<Map<String, dynamic>> extractProfile(String text) async {
    final url = "${ApiEndpoints.geminiBaseUrl}/models/${ApiEndpoints.geminiModel}:generateContent?key=$apiKey";

    final prompt = """You are a government welfare eligibility assistant for India.
Extract structured profile information from the user's voice description.
Return ONLY valid JSON. No explanation, no markdown, no code blocks.

User's description:
$text

Expected JSON format:
{
  "name": "full name",
  "age": age in years,
  "gender": "male/female/other",
  "state": "state name",
  "district": "district name",
  "caste": "general/obc/sc/st",
  "occupation": "farmer/daily_wage/unemployed/teacher/etc",
  "annual_income": annual income in rupees (number only),
  "land_holding": land in acres (number, 0 if no land),
  "is_disabled": true/false,
  "is_widow": true/false,
  "has_bpl_card": true/false,
  "has_aadhar": true/false,
  "has_bank_account": true/false,
  "family_size": number of family members,
  "children_ages": [ages of children],
  "is_pregnant": true/false,
  "education_level": "illiterate/primary/secondary/graduate",
  "confidence": 0.0 to 1.0,
  "missing_info": ["info that couldn't be extracted"]
}

If a field cannot be determined from the text, use null or empty value.
For numbers, use actual numeric values, not strings.""";

    try {
      final response = await _dio.post(
        url,
        data: {
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        },
      );

      if (response.statusCode == 200) {
        final rawText = response.data['candidates'][0]['content']['parts'][0]['text'];
        return _cleanJson(rawText);
      } else {
        throw Exception('Gemini API error: ${response.statusCode}');
      }
    } catch (e) {
      print('Gemini extraction error: $e');
      // Return empty profile on error
      return _getEmptyProfile();
    }
  }

  /// Clean JSON response from Gemini (remove markdown code blocks)
  Map<String, dynamic> _cleanJson(String text) {
    try {
      // Remove markdown code blocks if present
      text = text.replaceAll('```json', '').replaceAll('```', '').trim();
      
      // Find JSON object
      final start = text.indexOf('{');
      final end = text.lastIndexOf('}');
      
      if (start == -1 || end == -1) {
        return _getEmptyProfile();
      }
      
      final jsonString = text.substring(start, end + 1);
      final json = Dio().transformer.transformResponse(
        RequestOptions(path: ''),
        ResponseBody.fromString(jsonString, 200),
      ) as Map<String, dynamic>;
      
      return json;
    } catch (e) {
      print('JSON parsing error: $e');
      return _getEmptyProfile();
    }
  }

  /// Get empty profile structure
  Map<String, dynamic> _getEmptyProfile() {
    return {
      "name": "",
      "age": 0,
      "gender": "",
      "state": "",
      "district": "",
      "caste": "",
      "occupation": "",
      "annual_income": 0,
      "land_holding": 0,
      "is_disabled": false,
      "is_widow": false,
      "has_bpl_card": false,
      "has_aadhar": false,
      "has_bank_account": false,
      "family_size": 0,
      "children_ages": [],
      "is_pregnant": false,
      "education_level": "",
      "confidence": 0.0,
      "missing_info": ["Could not extract from voice input"]
    };
  }

  /// Match schemes using Gemini AI (optional, can use local engine instead)
  Future<List<Map<String, dynamic>>> matchSchemesWithAI(
    Map<String, dynamic> profile,
    List<Map<String, dynamic>> schemes,
  ) async {
    final url = "${ApiEndpoints.geminiBaseUrl}/models/${ApiEndpoints.geminiModel}:generateContent?key=$apiKey";

    final prompt = """You are an expert on Indian government welfare schemes.
Given a user profile and a list of schemes with eligibility criteria,
return which schemes the user qualifies for and WHY.
Return ONLY valid JSON array.

User Profile:
$profile

Schemes:
${schemes.take(50).toList()} // Limit to 50 for token limits

Expected JSON array format:
[
  {
    "scheme_id": "scheme_id",
    "eligible": true/false,
    "confidence": 0.0 to 1.0,
    "reason": "brief reason",
    "estimated_benefit": "benefit description"
  }
]""";

    try {
      final response = await _dio.post(
        url,
        data: {
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        },
      );

      if (response.statusCode == 200) {
        final rawText = response.data['candidates'][0]['content']['parts'][0]['text'];
        return _cleanJsonArray(rawText);
      }
    } catch (e) {
      print('Gemini matching error: $e');
    }
    
    return [];
  }

  /// Clean JSON array from Gemini
  List<Map<String, dynamic>> _cleanJsonArray(String text) {
    try {
      text = text.replaceAll('```json', '').replaceAll('```', '').trim();
      final start = text.indexOf('[');
      final end = text.lastIndexOf(']');
      
      if (start == -1 || end == -1) {
        return [];
      }
      
      final jsonString = text.substring(start, end + 1);
      final json = Dio().transformer.transformResponse(
        RequestOptions(path: ''),
        ResponseBody.fromString(jsonString, 200),
      ) as List;
      
      return json.cast<Map<String, dynamic>>();
    } catch (e) {
      print('JSON array parsing error: $e');
      return [];
    }
  }
}
