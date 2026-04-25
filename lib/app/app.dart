import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'router.dart';

class AdhikarApp extends StatelessWidget {
  const AdhikarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adhikar - Your Right. Delivered.',
      debugShowCheckedModeBanner: false,
      theme: getAppTheme(),
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
