import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/router.dart';
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
  final TTSService _ttsService = TTSService();

  String _transcript = '';
  bool _isListening = false;
  bool _isInitialized = false;
  String _language = 'en-IN';

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    // Get saved language
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('speech_code');
    if (savedLang != null) {
      _language = savedLang;
      _voiceService.setLanguage(_language);
    }

    // Initialize services
    final voiceInit = await _voiceService.init();
    final ttsInit = await _ttsService.init();
    
    if (mounted) {
      setState(() {
        _isInitialized = voiceInit && ttsInit;
      });

      // Speak welcome message
      if (ttsInit) {
        _ttsService.setLanguage(_language);
        _ttsService.speak('Please describe your situation in your own words');
      }
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

    _voiceService.startListening(
      onResult: (result) {
        setState(() {
          _transcript = result;
        });
      },
      onPartialResult: (partial) {
        setState(() {
          _transcript = partial;
        });
      },
      onListeningStarted: () {
        setState(() {
          _isListening = true;
        });
      },
      onListeningComplete: () {
        setState(() {
          _isListening = false;
        });
      },
    );
  }

  void _stopListening() {
    _voiceService.stopListening();
    setState(() {
      _isListening = false;
    });
  }

  void _handleContinue() {
    if (_transcript.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please speak or type your information')),
      );
      return;
    }

    // Navigate to profile with transcript
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Voice Input'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
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

              const SizedBox(height: 48),

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
                        color: (_isListening ? AppColors.secondary : AppColors.primary)
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
              ).animate()
                .scale(duration: 400.ms, curve: Curves.easeOutBack)
                .then()
                .animate(
                  target: _isListening ? 1 : 0,
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 800.ms,
                  curve: Curves.easeInOut,
                ),

              const SizedBox(height: 32),

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

              const SizedBox(height: 32),

              // Transcript Box
              Container(
                width: double.infinity,
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
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

              const Spacer(),

              // Manual input option
              TextButton.icon(
                onPressed: () {
                  _showManualInputDialog();
                },
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
            ],
          ),
        ),
      ),
    );
  }

  void _showManualInputDialog() {
    final controller = TextEditingController(text: _transcript);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter your information'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Describe your situation...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _transcript = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
