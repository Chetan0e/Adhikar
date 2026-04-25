import 'package:flutter/material.dart';
import '../features/onboarding/screens/splash_screen.dart';
import '../features/onboarding/screens/language_select_screen.dart';
import '../features/voice_intake/screens/voice_capture_screen.dart';
import '../features/profile/screens/profile_review_screen.dart';
import '../features/schemes/screens/scheme_list_screen.dart';
import '../features/schemes/screens/scheme_detail_screen.dart';
import '../features/application/screens/form_fill_screen.dart';
import '../features/tracking/screens/application_status_screen.dart';

class AppRouter {
  static const splash = '/';
  static const language = '/language';
  static const voice = '/voice';
  static const profile = '/profile';
  static const schemes = '/schemes';
  static const schemeDetail = '/scheme-detail';
  static const formFill = '/form-fill';
  static const tracking = '/tracking';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _page(const SplashScreen());
      case language:
        return _page(const LanguageSelectScreen());
      case voice:
        return _page(const VoiceCaptureScreen());
      case profile:
        return _page(const ProfileReviewScreen());
      case schemes:
        return _page(const SchemeListScreen());
      case schemeDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return _page(SchemeDetailScreen(schemeData: args));
      case formFill:
        final args = settings.arguments as Map<String, dynamic>?;
        return _page(FormFillScreen(schemeData: args));
      case tracking:
        return _page(const ApplicationStatusScreen());
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
