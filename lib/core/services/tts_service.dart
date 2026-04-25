import 'package:flutter_tts/flutter_tts.dart';
import '../constants/supported_languages.dart';

/// TtsService — speaks text in the selected language.
/// Use [speak] for general TTS, [stop] to halt.
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;
  bool _speaking = false;
  double _speechRate = 0.45;

  /// Initialize with defaults
  Future<void> init() async {
    try {
      await _tts.setSharedInstance(true);
      await _tts.setSpeechRate(_speechRate);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);

      _tts.setStartHandler(() => _speaking = true);
      _tts.setCompletionHandler(() => _speaking = false);
      _tts.setErrorHandler((_) => _speaking = false);

      _isInitialized = true;
    } catch (e) {
      // Graceful failure — silent mode or no TTS engine
      _isInitialized = false;
    }
  }

  /// Speak [text] in [languageCode] (e.g. 'hi', 'mr').
  Future<void> speak(String text, String languageCode) async {
    if (!_isInitialized) await init();
    try {
      final locale = SupportedLanguages.ttsLocales[languageCode] ?? 'hi-IN';
      await _tts.setLanguage(locale);
      await _tts.setSpeechRate(_speechRate);
      await _tts.setPitch(1.0);
      await _tts.speak(text);
    } catch (_) {
      // Silently catch TTS errors (e.g., silent mode)
    }
  }

  /// Stop speaking
  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
    _speaking = false;
  }

  /// Set speech rate (0.0–1.0)
  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate;
    await _tts.setSpeechRate(rate);
  }

  bool get isSpeaking => _speaking;

  /// Check if a language is available for TTS
  Future<bool> isLanguageAvailable(String languageCode) async {
    try {
      final locale = SupportedLanguages.ttsLocales[languageCode] ?? 'hi-IN';
      return await _tts.isLanguageAvailable(locale) == true;
    } catch (_) {
      return false;
    }
  }
}
