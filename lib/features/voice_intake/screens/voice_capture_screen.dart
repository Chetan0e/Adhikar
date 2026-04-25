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

class VoiceCaptureScreen extends StatefulWidget {
  const VoiceCaptureScreen({super.key});

  @override
  State<VoiceCaptureScreen> createState() => _VoiceCaptureScreenState();
}

class _VoiceCaptureScreenState extends State<VoiceCaptureScreen> {
  final VoiceService _voiceService = VoiceService();
  final TtsService _ttsService = TtsService();

  String _transcript = '';
  bool _isListening = false;
  bool _isInitialized = false;
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
      await _ttsService.speak(
        'Please describe your situation in your own words',
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

  void _handleContinue() {
    if (_transcript.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please speak or type your information')),
      );
      return;
    }
    Navigator.pushNamed(
      context,
      AppRouter.profile,
      arguments: {'transcript': _transcript},
    );
  }

  @override
  void dispose() {
    _voiceService.stopListening();
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          title: const Text('Voice Input'),
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
                  'Describe your situation',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 400.ms),

                const SizedBox(height: 8),

                Text(
                  'Speak about yourself, your family, income, occupation, etc.',
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
                    'Listening...',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ).animate().fadeIn(duration: 300.ms),

                if (!_isListening && _transcript.isNotEmpty)
                  Text(
                    'Tap to speak again',
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
                        'Transcript',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _transcript.isEmpty
                            ? 'Your speech will appear here...'
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
                  label: const Text('Type instead of speaking'),
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                const SizedBox(height: 16),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _transcript.isNotEmpty ? _handleContinue : null,
                    child: const Text('Continue'),
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
    final langName = SupportedLanguages.languages[_languageCode] ?? 'English';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hearing, color: AppColors.primary, size: 16),
          const SizedBox(width: 6),
          Text(
            'Listening in: $langName',
            style: TextStyle(
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
    final controller = TextEditingController(text: _transcript);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Enter your information'),
        content: SingleChildScrollView(
          child: TextField(
            controller: controller,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText: 'Describe your situation...',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _transcript = controller.text);
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
