import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/router.dart';
import '../../../../core/blocs/language/language_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/supported_languages.dart';

class LanguageSelectScreen extends StatefulWidget {
  final bool isChanging; // true when accessed from Settings (not first-time)

  const LanguageSelectScreen({super.key, this.isChanging = false});

  @override
  State<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends State<LanguageSelectScreen> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = context.read<LanguageCubit>().currentLanguageCode;
  }

  @override
  Widget build(BuildContext context) {
    final isChanging = widget.isChanging;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isChanging
          ? AppBar(
              title: const Text('Change Language'),
              elevation: 0,
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isChanging) const SizedBox(height: 32),

              // Header
              Text(
                'Choose your language',
                style: Theme.of(context).textTheme.displaySmall,
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 8),

              Text(
                'अपनी भाषा चुनें / ഭഷ / ভাষা / ഭḗẓa',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

              const SizedBox(height: 32),

              // Language Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: SupportedLanguages.languages.length,
                  itemBuilder: (context, index) {
                    final code =
                        SupportedLanguages.languages.keys.elementAt(index);
                    final name = SupportedLanguages.languages[code]!;
                    final isSelected = _selectedLanguage == code;

                    return _LanguageCard(
                      code: code,
                      name: name,
                      isSelected: isSelected,
                      onTap: () => setState(() => _selectedLanguage = code),
                      delay: index * 80,
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  child: Text(isChanging ? 'Save Language' : 'Continue'),
                ),
              ).animate().fadeIn(delay: 600.ms, duration: 400.ms),

              if (!isChanging) ...[
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() => _selectedLanguage = 'en');
                      _handleContinue();
                    },
                    child: const Text('Continue with English'),
                  ),
                ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleContinue() async {
    final cubit = context.read<LanguageCubit>();
    await cubit.changeLanguage(_selectedLanguage);

    if (!mounted) return;

    if (widget.isChanging) {
      // Show toast
      final langName = SupportedLanguages.languages[_selectedLanguage] ?? '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Language changed to $langName'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } else {
      // First time: go to onboarding
      Navigator.pushReplacementNamed(context, AppRouter.onboarding);
    }
  }
}

class _LanguageCard extends StatelessWidget {
  final String code;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;
  final int delay;

  const _LanguageCard({
    required this.code,
    required this.name,
    required this.isSelected,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getLanguageEmoji(code),
              style: const TextStyle(fontSize: 36),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Icon(Icons.check_circle, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay), duration: 400.ms);
  }

  String _getLanguageEmoji(String code) {
    const emojis = {
      'en': '🌐',
      'hi': '🙏',
      'mr': '🌾',
      'ta': '🎭',
      'te': '💠',
      'kn': '🏛️',
      'bn': '🌸',
      'gu': '🦚',
      'ml': '🌴',
      'or': '🔱',
      'pa': '⚔️',
    };
    return emojis[code] ?? '🌐';
  }
}
