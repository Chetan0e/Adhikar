import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/supported_languages.dart';

class LanguageSelectScreen extends StatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  State<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends State<LanguageSelectScreen> {
  String _selectedLanguage = 'mr'; // Default to Marathi as mentioned in docs

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Select Language'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Choose your language',
                style: Theme.of(context).textTheme.displaySmall,
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 8),

              Text(
                'अपनी भाषा चुनें',
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
                    childAspectRatio: 1.2,
                  ),
                  itemCount: SupportedLanguages.languages.length,
                  itemBuilder: (context, index) {
                    final code = SupportedLanguages.languages.keys.elementAt(index);
                    final name = SupportedLanguages.languages[code]!;
                    final isSelected = _selectedLanguage == code;

                    return _LanguageCard(
                      code: code,
                      name: name,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedLanguage = code;
                        });
                      },
                      delay: index * 100,
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
                  child: const Text('Continue'),
                ),
              ).animate().fadeIn(delay: 600.ms, duration: 400.ms),

              const SizedBox(height: 16),

              // Skip option
              Center(
                child: TextButton(
                  onPressed: _handleContinue,
                  child: const Text('Continue with English'),
                ),
              ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleContinue() async {
    // Save selected language
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', _selectedLanguage);
    await prefs.setString('speech_code', SupportedLanguages.speechCodes[_selectedLanguage]!);

    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRouter.voice);
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
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Language icon/emoji
            Text(
              _getLanguageEmoji(code),
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 12),
            // Language name
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay), duration: 400.ms);
  }

  String _getLanguageEmoji(String code) {
    switch (code) {
      case 'hi':
        return '🇮🇳';
      case 'mr':
        return '🇮🇳';
      case 'ta':
        return '🇮🇳';
      case 'te':
        return '🇮🇳';
      case 'kn':
        return '🇮🇳';
      case 'bn':
        return '🇮🇳';
      case 'gu':
        return '🇮🇳';
      case 'ml':
        return '🇮🇳';
      case 'pa':
        return '🇮🇳';
      case 'en':
        return '🌐';
      default:
        return '🌐';
    }
  }
}
