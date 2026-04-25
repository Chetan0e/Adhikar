// Hive box names for offline storage
class HiveBoxes {
  static const String kUserProfileBox = 'user_profiles';
  static const String kSchemesBox = 'schemes_cache';
  static const String kApplicationsBox = 'applications';
  static const String kSyncQueueBox = 'sync_queue';
  static const String kSettingsBox = 'settings';

  // Settings keys (used inside kSettingsBox)
  static const String kSelectedLanguage = 'selected_language';
  static const String kOnboardingComplete = 'onboarding_complete';
  static const String kTtsEnabled = 'tts_enabled';
  static const String kAutoPlayResults = 'auto_play_results';
  static const String kSpeechRate = 'speech_rate';
  static const String kLargeTextMode = 'large_text_mode';
  static const String kHighContrastMode = 'high_contrast_mode';
  static const String kStatusAlerts = 'status_alerts';
  static const String kDocumentReminders = 'document_reminders';
  static const String kNewSchemeAlerts = 'new_scheme_alerts';
}
