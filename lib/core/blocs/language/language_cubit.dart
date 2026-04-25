import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../constants/hive_boxes.dart';
import '../../constants/supported_languages.dart';
import 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageState.initial());

  /// Load saved language from Hive on startup
  Future<void> loadSavedLanguage() async {
    final box = Hive.box(HiveBoxes.kSettingsBox);
    final savedCode = box.get('selected_language', defaultValue: 'en') as String;
    final locale = Locale(savedCode);
    emit(LanguageState(locale: locale, languageCode: savedCode));
  }

  /// Change language — persist to Hive and emit new state
  Future<void> changeLanguage(String languageCode) async {
    final box = Hive.box(HiveBoxes.kSettingsBox);
    await box.put('selected_language', languageCode);
    final locale = Locale(languageCode);
    emit(LanguageState(locale: locale, languageCode: languageCode));
  }

  /// Get current language code
  String get currentLanguageCode => state.languageCode;

  /// Get human-readable language name
  String get currentLanguageName =>
      SupportedLanguages.languages[state.languageCode] ?? 'English';

  /// Get TTS locale string (e.g. 'hi-IN')
  String get ttsLocale =>
      SupportedLanguages.ttsLocales[state.languageCode] ?? 'en-IN';

  /// Get STT locale string (e.g. 'hi_IN')
  String get sttLocale =>
      SupportedLanguages.sttLocales[state.languageCode] ?? 'en_IN';

  /// Check if onboarding is complete
  bool get isOnboardingComplete {
    final box = Hive.box(HiveBoxes.kSettingsBox);
    return box.get('onboarding_complete', defaultValue: false) as bool;
  }

  /// Mark onboarding as complete
  Future<void> completeOnboarding() async {
    final box = Hive.box(HiveBoxes.kSettingsBox);
    await box.put('onboarding_complete', true);
  }

  /// Check if language has been chosen at least once
  bool get hasChosenLanguage {
    final box = Hive.box(HiveBoxes.kSettingsBox);
    return box.containsKey('selected_language');
  }
}
