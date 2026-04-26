import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/router.dart';
import '../../../../core/blocs/language/language_cubit.dart';
import '../../../../core/blocs/language/language_state.dart';
import '../../../../core/constants/supported_languages.dart';
import '../../../../core/services/tts_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TtsService _tts = TtsService();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _tts.init();
    // Auto-narrate first slide after brief delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _narrateCurrentSlide();
    });
  }

  @override
  void dispose() {
    _tts.stop();
    _pageController.dispose();
    super.dispose();
  }

  void _narrateCurrentSlide() {
    final code = context.read<LanguageCubit>().currentLanguageCode;
    final slide = _getSlides(context, code)[_currentPage];
    _tts.speak(slide.body, code);
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _narrateCurrentSlide();
    });
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _skipToLast() {
    _pageController.animateToPage(
      3,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finishOnboarding() async {
    await context.read<LanguageCubit>().completeOnboarding();
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRouter.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, langState) {
        final slides = _getSlides(context, langState.languageCode);
        final l10n = AppLocalizations.of(context)!;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _currentPage < 3 ? _skipToLast : null,
                    child: Text(
                      _currentPage < 3 ? l10n.skipOnboarding : '',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),

                // PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: slides.length,
                    itemBuilder: (context, index) => _OnboardingSlide(
                      slide: slides[index],
                      onReplay: _narrateCurrentSlide,
                    ),
                  ),
                ),

                // Dot indicators
                _buildDotIndicator(),

                const SizedBox(height: 24),

                // Navigation buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _currentPage == 3 ? _finishOnboarding : _nextPage,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentPage == 3 ? l10n.getStarted : l10n.next,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.border,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  List<_OnboardingSlideData> _getSlides(BuildContext context, String langCode) {
    final l10n = AppLocalizations.of(context)!;
    final example = SupportedLanguages.onboardingExamples[langCode] ??
        SupportedLanguages.onboardingExamples['en']!;

    return [
      _OnboardingSlideData(
        emoji: '🏛️',
        title: l10n.onboarding1Title,
        body: l10n.onboarding1Body,
        example: null,
        color: AppColors.primary,
      ),
      _OnboardingSlideData(
        emoji: '🎤',
        title: l10n.onboarding2Title,
        body: l10n.onboarding2Body,
        example: example,
        color: const Color(0xFF7C3AED),
      ),
      _OnboardingSlideData(
        emoji: '✅',
        title: l10n.onboarding3Title,
        body: l10n.onboarding3Body,
        example: null,
        color: const Color(0xFF059669),
      ),
      _OnboardingSlideData(
        emoji: '📄',
        title: l10n.onboarding4Title,
        body: l10n.onboarding4Body,
        example: null,
        color: const Color(0xFFD97706),
      ),
    ];
  }
}

class _OnboardingSlideData {
  final String emoji;
  final String title;
  final String body;
  final String? example;
  final Color color;

  const _OnboardingSlideData({
    required this.emoji,
    required this.title,
    required this.body,
    required this.example,
    required this.color,
  });
}

class _OnboardingSlide extends StatelessWidget {
  final _OnboardingSlideData slide;
  final VoidCallback onReplay;

  const _OnboardingSlide({required this.slide, required this.onReplay});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji icon with colored background
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: slide.color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: slide.color.withOpacity(0.3), width: 2),
            ),
            child: Center(
              child: Text(
                slide.emoji,
                style: const TextStyle(fontSize: 56),
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.05, 1.05),
                duration: 2000.ms,
                curve: Curves.easeInOut,
              ),

          const SizedBox(height: 40),

          // Title
          Text(
            slide.title,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: slide.color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 16),

          // Body
          Text(
            slide.body,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

          // Example quote (slide 2 only)
          if (slide.example != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: slide.color.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: slide.color.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.format_quote, color: slide.color, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      slide.example!,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          ],

          const SizedBox(height: 32),

          // Replay TTS button
          TextButton.icon(
            onPressed: onReplay,
            icon: Icon(Icons.volume_up, color: slide.color),
            label: Text(
              'Replay audio',
              style: TextStyle(color: slide.color),
            ),
          ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
        ],
      ),
    );
  }
}
