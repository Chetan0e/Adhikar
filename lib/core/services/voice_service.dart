import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceService {
  final SpeechToText _speech = SpeechToText();
  bool _isInitialized = false;
  String _currentLocale = 'en-IN';

  /// Initialize speech recognition
  Future<bool> init() async {
    // Request microphone permission
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      return false;
    }

    _isInitialized = await _speech.initialize(
      onError: (error) => print('Speech error: $error'),
      onStatus: (status) => print('Speech status: $status'),
    );
    return _isInitialized;
  }

  /// Set language for speech recognition
  void setLanguage(String languageCode) {
    _currentLocale = languageCode;
  }

  /// Start listening to speech
  void startListening({
    required Function(String) onResult,
    Function(String)? onPartialResult,
    Function()? onListeningStarted,
    Function()? onListeningComplete,
  }) {
    if (!_isInitialized) {
      throw Exception('Voice service not initialized');
    }

    _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
          onListeningComplete?.call();
        } else if (onPartialResult != null) {
          onPartialResult(result.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      localeId: _currentLocale,
      partialResults: true,
      listenMode: ListenMode.confirmation,
      listenOptions: SpeechListenOptions(
        cancelOnError: true,
        partialResults: true,
      ),
    );
  }

  /// Stop listening
  void stopListening() {
    _speech.stop();
  }

  /// Cancel listening
  void cancelListening() {
    _speech.cancel();
  }

  /// Check if currently listening
  bool get isListening => _speech.isListening;

  /// Get available locales
  Future<List<LocaleName>> get availableLocales async {
    return await _speech.locales();
  }

  /// Check if speech is available
  bool get isAvailable => _speech.isAvailable;
}
