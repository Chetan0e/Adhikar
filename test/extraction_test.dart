import 'package:flutter_test/flutter_test.dart';
import 'package:adhikar/data/remote/gemini_service.dart';

void main() {
  test('extracts Marathi transcript correctly', () {
    const transcript =
        'माझे नाव चेतन आहे मी दहावीच्या विद्यार्थी आहे '
        'मी मराठी माध्यमात शिकतो माझ्या कुटुंबाचे '
        'वार्षिक उत्पन्न एक लाख आहे मी महाराष्ट्रात राहतो';

    final result = GeminiService().testLocalExtract(transcript);

    print('EXTRACTION RESULT: $result');

    expect(result['name'], equals('चेतन'));
    expect(result['occupation'], equals('student'));
    expect(result['state'], equals('Maharashtra'));
    expect(result['annual_income'], equals(100000));
    expect(result['education_level'], equals('secondary'));
    expect(result['gender'], equals('male'));
  });
}
