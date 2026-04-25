import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/blocs/language/language_cubit.dart';
import '../core/blocs/language/language_state.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/offline_banner.dart';
import '../generated/l10n/app_localizations.dart';
import 'router.dart';

class AdhikarApp extends StatelessWidget {
  const AdhikarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, langState) {
        return MaterialApp(
          title: 'Adhikar',
          debugShowCheckedModeBanner: false,
          theme: getAppTheme(),

          // Localization configuration
          locale: langState.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,

          // Routing
          initialRoute: AppRouter.splash,
          onGenerateRoute: AppRouter.generateRoute,
          builder: (context, child) {
            return OfflineBanner(child: child!);
          },
        );
      },
    );
  }
}
