import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/router.dart';
import '../../../../core/blocs/language/language_cubit.dart';
import '../../../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final cubit = context.read<LanguageCubit>();

    // Smart routing logic:
    // 1. No language chosen yet → Language selection screen
    // 2. Language chosen, onboarding NOT complete → Onboarding
    // 3. Language chosen, onboarding complete → Voice/Home screen
    if (!cubit.hasChosenLanguage) {
      Navigator.pushReplacementNamed(context, AppRouter.language);
    } else if (!cubit.isOnboardingComplete) {
      Navigator.pushReplacementNamed(context, AppRouter.onboarding);
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Government Emblem / Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.accentWhite,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.account_balance,
                size: 60,
                color: AppColors.primary,
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 32),

            // App Name
            const Text(
              'ADHIKAR',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.accentWhite,
                letterSpacing: 4,
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

            const SizedBox(height: 12),

            // Tagline
            Text(
              'Your Right. Delivered.',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.accentWhite.withOpacity(0.9),
                letterSpacing: 1,
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

            const SizedBox(height: 48),

            // Powered by text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Powered by AI for ',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.accentWhite.withOpacity(0.8),
                  ),
                ),
                const Text('🇮🇳', style: TextStyle(fontSize: 18)),
                Text(
                  ' Bharat',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.accentWhite.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 600.ms, duration: 600.ms),

            const SizedBox(height: 64),

            // Loading indicator
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.accentWhite),
              ),
            ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
