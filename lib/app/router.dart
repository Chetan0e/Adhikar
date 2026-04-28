import 'package:flutter/material.dart';
import '../features/onboarding/screens/splash_screen.dart';
import '../features/onboarding/screens/language_select_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/voice_intake/screens/voice_capture_screen.dart';
import '../features/ai_chat/screens/ai_chat_screen.dart';
import '../features/profile/screens/profile_review_screen.dart';
import '../features/schemes/screens/scheme_list_screen.dart';
import '../features/schemes/screens/scheme_detail_screen.dart';
import '../features/schemes/screens/document_checklist_screen.dart';
import '../features/application/screens/form_fill_screen.dart';
import '../features/tracking/screens/application_status_screen.dart';
import '../features/tracking/screens/application_history_screen.dart';
import '../features/settings/screens/settings_screen.dart';

class AppRouter {
  static const splash = '/';
  static const language = '/language';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const voice = '/voice';
  static const chat = '/chat';
  static const profile = '/profile';
  static const schemes = '/schemes';
  static const schemeDetail = '/scheme-detail';
  static const documentChecklist = '/document-checklist';
  static const formFill = '/form-fill';
  static const tracking = '/tracking';
  static const applicationHistory = '/application-history';
  static const settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _page(const SplashScreen());

      case language:
        final args = settings.arguments as Map<String, dynamic>?;
        final isChanging = args?['isChanging'] as bool? ?? false;
        return _page(LanguageSelectScreen(isChanging: isChanging));

      case onboarding:
        return _page(const OnboardingScreen());

      case voice:
        return _page(const VoiceCaptureScreen());

      case home:
        return _page(const HomeScreen());

      case chat:
        return _page(const AiChatScreen());

      case profile:
        final args = settings.arguments as Map<String, dynamic>?;
        return _page(ProfileReviewScreen(profileData: args));

      case schemes:
        final args = settings.arguments as Map<String, dynamic>?;
        return _page(SchemeListScreen(userProfile: args));

      case schemeDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return _page(SchemeDetailScreen(schemeData: args));

      case documentChecklist:
        final args = settings.arguments as Map<String, dynamic>?;
        return _page(DocumentChecklistScreen(schemeData: args));

      case formFill:
        final args = settings.arguments as Map<String, dynamic>?;
        return _page(FormFillScreen(schemeData: args));

      case tracking:
        return _page(const ApplicationStatusScreen());

      case applicationHistory:
        return _page(const ApplicationHistoryScreen());

      case AppRouter.settings:
        return _page(const SettingsScreen());

      default:
        return _page(const Scaffold(
          body: Center(child: Text('Page not found')),
        ));
    }
  }

  static MaterialPageRoute _page(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }
}
