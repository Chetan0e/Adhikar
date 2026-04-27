import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/router.dart';
import '../../../../core/blocs/language/language_cubit.dart';
import '../../../../core/blocs/language/language_state.dart';
import '../../../../core/constants/supported_languages.dart';
import '../../../../core/services/voice_service.dart';
import '../../../../core/services/tts_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/remote/gemini_service.dart';
import '../../../../generated/l10n/app_localizations.dart';

class VoiceCaptureScreen extends StatefulWidget {
  const VoiceCaptureScreen({super.key});

  @override
  State<VoiceCaptureScreen> createState() => _VoiceCaptureScreenState();
}

class _VoiceCaptureScreenState extends State<VoiceCaptureScreen> {
  final VoiceService _voiceService = VoiceService();
  final TtsService _ttsService = TtsService();
  final GeminiService _geminiService = GeminiService();

  String _transcript = '';
  bool _isListening = false;
  bool _isInitialized = false;
  bool _isExtracting = false;
  String _languageCode = 'en';

  @override
  void initState() {
    super.initState();
    _languageCode = context.read<LanguageCubit>().currentLanguageCode;
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    final sttLocale = SupportedLanguages.sttLocales[_languageCode] ?? 'en_IN';
    _voiceService.setLanguage(sttLocale);

    final voiceInit = await _voiceService.init();
    await _ttsService.init();

    if (mounted) {
      setState(() => _isInitialized = voiceInit);

      // Speak welcome message in selected language
      final l10n = AppLocalizations.of(context);
      await _ttsService.speak(
        l10n.speakPrompt,
        _languageCode,
      );
    }
  }

  void _toggleListening() {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  void _startListening() {
    setState(() {
      _isListening = true;
      _transcript = '';
    });

    final sttLocale = SupportedLanguages.sttLocales[_languageCode] ?? 'en_IN';
    _voiceService.setLanguage(sttLocale);

    _voiceService.startListening(
      onResult: (result) => setState(() => _transcript = result),
      onPartialResult: (partial) => setState(() => _transcript = partial),
      onListeningStarted: () => setState(() => _isListening = true),
      onListeningComplete: () => setState(() => _isListening = false),
    );
  }

  void _stopListening() {
    _voiceService.stopListening();
    setState(() => _isListening = false);
  }

  void _handleContinue() async {
    if (_transcript.isEmpty) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSpeak)),
      );
      return;
    }

    setState(() => _isExtracting = true);

    try {
      print('=== CONTINUE TAPPED ===');
      print('Transcript: $_transcript');

      // Extract profile using Gemini before navigation
      final langCode = context.read<LanguageCubit>().currentLanguageCode;
      final langInstruction = SupportedLanguages.geminiLanguageInstruction(langCode);

      print('Calling Gemini extractProfile...');
      final profileData = await _geminiService.extractProfile(_transcript);
      print('Gemini returned: $profileData');

      // CRITICAL: Never navigate with null — always use fallback
      final safeProfile = (profileData == null || profileData.isEmpty)
          ? _buildFallbackProfile(_transcript)
          : profileData;

      print('Navigating with profile: $safeProfile');

      if (mounted) {
        setState(() => _isExtracting = false);

        // Navigate with extracted profile data
        Navigator.pushNamed(
          context,
          AppRouter.profile,
          arguments: safeProfile,
        );
      }
    } catch (e, stack) {
      print('extractProfile ERROR: $e');
      print(stack);

      // Still navigate with fallback — never leave user stuck
      final fallback = _buildFallbackProfile(_transcript);
      print('Navigating with fallback profile: $fallback');

      if (mounted) {
        setState(() => _isExtracting = false);
        Navigator.pushNamed(
          context,
          AppRouter.profile,
          arguments: fallback,
        );
      }
    }
  }

  Map<String, dynamic> _buildFallbackProfile(String transcript) {
    // Use GeminiService's smart local extraction which supports all Indian languages
    final fallback = _geminiService.smartLocalExtract(transcript);
    fallback['_raw_transcript'] = transcript;
    fallback['_is_fallback'] = true;
    return fallback;
  }

  @override
  void dispose() {
    _voiceService.stopListening();
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return BlocListener<LanguageCubit, LanguageState>(
      listenWhen: (prev, curr) => prev.languageCode != curr.languageCode,
      listener: (context, state) {
        setState(() => _languageCode = state.languageCode);
        final sttLocale = SupportedLanguages.sttLocales[_languageCode] ?? 'en_IN';
        _voiceService.setLanguage(sttLocale);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(l10n.voiceInputTitle),
          elevation: 0,
          actions: [
            // Settings icon
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Navigator.pushNamed(context, AppRouter.settings),
            ),
          ],
        ),
        // Help FAB
        floatingActionButton: FloatingActionButton.small(
          heroTag: 'help_fab',
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.help_outline, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, AppRouter.onboarding),
          tooltip: 'How to use',
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Header
                Text(
                  l10n.voiceInputTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 400.ms),

                const SizedBox(height: 8),

                Text(
                  l10n.voiceInputSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

                const SizedBox(height: 12),

                // Listening language chip
                _buildListeningChip(),

                const SizedBox(height: 32),

                // Mic Button
                GestureDetector(
                  onTap: _isInitialized ? _toggleListening : null,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: _isListening ? AppColors.secondary : AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_isListening
                                  ? AppColors.secondary
                                  : AppColors.primary)
                              .withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isListening ? Icons.stop : Icons.mic,
                      size: 60,
                      color: AppColors.accentWhite,
                    ),
                  ),
                )
                    .animate()
                    .scale(duration: 400.ms, curve: Curves.easeOutBack)
                    .then()
                    .animate(
                      target: _isListening ? 1 : 0,
                      onPlay: (controller) =>
                          controller.repeat(reverse: true),
                    )
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.1, 1.1),
                      duration: 800.ms,
                      curve: Curves.easeInOut,
                    ),

                const SizedBox(height: 24),

                // Listening status
                if (_isListening)
                  Text(
                    l10n.listening,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ).animate().fadeIn(duration: 300.ms),

                if (!_isListening && _transcript.isNotEmpty)
                  Text(
                    l10n.tapToSpeakAgain,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ).animate().fadeIn(duration: 300.ms),

                const SizedBox(height: 24),

                // Transcript Box
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 100),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.transcriptLabel,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _transcript.isEmpty
                            ? l10n.transcriptHint
                            : _transcript,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                const SizedBox(height: 20),

                // Manual input option
                TextButton.icon(
                  onPressed: _showManualInputDialog,
                  icon: const Icon(Icons.edit),
                  label: Text(l10n.typeInstead),
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                const SizedBox(height: 16),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isExtracting ? null : (_transcript.isNotEmpty ? _handleContinue : null),
                    child: _isExtracting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(l10n.continueButton),
                  ),
                ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListeningChip() {
    final langName = SupportedLanguages.nativeNames[_languageCode] ?? 
                     SupportedLanguages.languages[_languageCode] ?? 'English';
    final l10n = AppLocalizations.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.hearing, color: AppColors.primary, size: 16),
          const SizedBox(width: 6),
          Text(
            l10n.listeningIn(langName),
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showManualInputDialog() {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: _transcript);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.enterYourInfo),
        content: SingleChildScrollView(
          child: TextField(
            controller: controller,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: l10n.describeHint,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _transcript = controller.text);
              Navigator.pop(dialogContext);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
