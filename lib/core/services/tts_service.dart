import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;

  /// Initialize text-to-speech
  Future<bool> init() async {
    try {
      await _tts.setSharedInstance(true);
      _isInitialized = true;
      
      // Set default settings
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      
      return true;
    } catch (e) {
      print('TTS initialization error: $e');
      return false;
    }
  }

  /// Set language for speech
  Future<void> setLanguage(String languageCode) async {
    await _tts.setLanguage(languageCode);
  }

  /// Speak text
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await init();
    }
    
    await _tts.speak(text);
  }

  /// Stop speaking
  Future<void> stop() async {
    await _tts.stop();
  }

  /// Pause speaking
  Future<void> pause() async {
    await _tts.pause();
  }

  /// Set speech rate (0.0 to 1.0)
  Future<void> setSpeechRate(double rate) async {
    await _tts.setSpeechRate(rate);
  }

  /// Set pitch (0.5 to 2.0)
  Future<void> setPitch(double pitch) async {
    await _tts.setPitch(pitch);
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    await _tts.setVolume(volume);
  }

  /// Check if currently speaking
  Future<bool> get isSpeaking async {
    return await _tts.isSpeaking;
  }
}
