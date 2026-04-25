import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/router.dart';
import '../../../../core/blocs/language/language_cubit.dart';
import '../../../../core/constants/supported_languages.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/user_profile.dart';
import '../../../../data/remote/gemini_service.dart';

class ProfileReviewScreen extends StatefulWidget {
  const ProfileReviewScreen({super.key});

  @override
  State<ProfileReviewScreen> createState() => _ProfileReviewScreenState();
}

class _ProfileReviewScreenState extends State<ProfileReviewScreen> {
  final GeminiService _geminiService = GeminiService();

  UserProfile? _profile;
  bool _isLoading = true;
  bool _isEditing = false;
  String _transcript = '';
  String? _aiError;

  // Controllers for editing
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _incomeController;
  late TextEditingController _occupationController;
  late TextEditingController _stateController;
  late TextEditingController _districtController;
  late TextEditingController _castController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfile());
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _incomeController = TextEditingController();
    _occupationController = TextEditingController();
    _stateController = TextEditingController();
    _districtController = TextEditingController();
    _castController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _incomeController.dispose();
    _occupationController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    _castController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    _transcript = args['transcript'] as String? ?? '';

    if (_transcript.isNotEmpty) {
      // Build language-aware Gemini prompt
      final langCode = context.read<LanguageCubit>().currentLanguageCode;
      final langInstruction = SupportedLanguages.geminiLanguageInstruction(langCode);

      try {
        final extractedData =
            await _geminiService.extractProfile(_transcript, languageHint: langInstruction);
        if (mounted) {
          _profile = UserProfile.fromJson(extractedData);
        }
      } catch (e) {
        if (mounted) {
          _aiError = 'Could not auto-extract. Please fill manually.';
          _profile = _buildEmptyProfile();
        }
      }
    } else {
      _profile = _buildEmptyProfile();
    }

    _populateControllers();

    if (mounted) setState(() => _isLoading = false);
  }

  UserProfile _buildEmptyProfile() {
    return UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '',
      age: 0,
      gender: '',
      state: '',
      district: '',
      caste: '',
      occupation: '',
      annualIncome: 0,
      landHolding: 0,
      isDisabled: false,
      isWidow: false,
      hasBPLCard: false,
      hasAadhar: false,
      hasBankAccount: false,
      familySize: 1,
      childrenAges: [],
      isPregnant: false,
      educationLevel: '',
      createdAt: DateTime.now(),
    );
  }

  void _populateControllers() {
    if (_profile == null) return;
    _nameController.text = _profile!.name;
    _ageController.text = _profile!.age > 0 ? _profile!.age.toString() : '';
    _incomeController.text =
        _profile!.annualIncome > 0 ? _profile!.annualIncome.toString() : '';
    _occupationController.text = _profile!.occupation;
    _stateController.text = _profile!.state;
    _districtController.text = _profile!.district;
    _castController.text = _profile!.caste;
  }

  void _saveProfile() {
    if (_profile == null) return;
    setState(() {
      _profile = _profile!.copyWith(
        name: _nameController.text.trim(),
        age: int.tryParse(_ageController.text) ?? _profile!.age,
        annualIncome:
            double.tryParse(_incomeController.text) ?? _profile!.annualIncome,
        occupation: _occupationController.text.trim(),
        state: _stateController.text.trim(),
        district: _districtController.text.trim(),
        caste: _castController.text.trim(),
      );
      _isEditing = false;
    });
  }

  void _handleContinue() {
    if (_profile == null) return;
    Navigator.pushNamed(
      context,
      AppRouter.schemes,
      arguments: _profile!.toJson(),
    );
  }

  void _toggleBool(String field) {
    if (_profile == null) return;
    setState(() {
      switch (field) {
        case 'bpl':
          _profile = _profile!.copyWith(hasBPLCard: !_profile!.hasBPLCard);
          break;
        case 'aadhar':
          _profile = _profile!.copyWith(hasAadhar: !_profile!.hasAadhar);
          break;
        case 'bank':
          _profile = _profile!.copyWith(hasBankAccount: !_profile!.hasBankAccount);
          break;
        case 'widow':
          _profile = _profile!.copyWith(isWidow: !_profile!.isWidow);
          break;
        case 'disabled':
          _profile = _profile!.copyWith(isDisabled: !_profile!.isDisabled);
          break;
        case 'pregnant':
          _profile = _profile!.copyWith(isPregnant: !_profile!.isPregnant);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile Review'),
        elevation: 0,
        actions: [
          if (!_isLoading && _profile != null)
            TextButton.icon(
              onPressed: () {
                if (_isEditing) {
                  _saveProfile();
                } else {
                  setState(() => _isEditing = true);
                }
              },
              icon: Icon(_isEditing ? Icons.check : Icons.edit, size: 18),
              label: Text(_isEditing ? 'Save' : 'Edit'),
            ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _profile == null
              ? const Center(child: Text('No profile data. Go back and try again.'))
              : SafeArea(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // AI extraction notice / error
                        if (_aiError != null)
                          _buildWarningBanner(_aiError!)
                        else if (_transcript.isNotEmpty)
                          _buildAISuccessBanner(),

                        const SizedBox(height: 16),

                        // Transcript preview (collapsible)
                        if (_transcript.isNotEmpty) _buildTranscriptCard(),

                        const SizedBox(height: 16),

                        // Personal Info
                        _buildSection(
                          title: '👤  Personal Information',
                          delay: 200,
                          children: [
                            _buildEditableField('Name', _nameController, 'full name'),
                            _buildEditableField('Age', _ageController, 'years',
                                keyboardType: TextInputType.number),
                            _buildReadOnlyRow('Gender',
                                _profile!.gender.isEmpty ? 'Not detected' : _profile!.gender),
                            _buildEditableField('State', _stateController, 'e.g. Maharashtra'),
                            _buildEditableField('District', _districtController, 'e.g. Pune'),
                            _buildEditableField('Caste', _castController, 'e.g. OBC / SC / ST'),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Economic Info
                        _buildSection(
                          title: '💰  Economic Information',
                          delay: 300,
                          children: [
                            _buildEditableField('Occupation', _occupationController,
                                'e.g. farmer, labourer'),
                            _buildEditableField('Annual Income (₹)', _incomeController,
                                '0', keyboardType: TextInputType.number),
                            _buildReadOnlyRow('Land Holding',
                                '${_profile!.landHolding} acres'),
                            _buildReadOnlyRow('Family Size',
                                '${_profile!.familySize} members'),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Social Status (toggleable chips)
                        _buildSection(
                          title: '🏷️  Social Status',
                          delay: 400,
                          children: [
                            _buildToggleGrid(),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Continue CTA
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _handleContinue,
                            icon: const Icon(Icons.search),
                            label: const Text('Find Eligible Schemes'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ).animate().fadeIn(delay: 500.ms, duration: 400.ms),

                        const SizedBox(height: 12),

                        Center(
                          child: TextButton(
                            onPressed: () {
                              setState(() => _isEditing = true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Edit your profile and tap Save'),
                                ),
                              );
                            },
                            child: const Text('Something wrong? Edit profile'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(
            'AI is analyzing your response…',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This takes a few seconds',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  Widget _buildAISuccessBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accentGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.accentGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: AppColors.accentGreen, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'AI successfully extracted your profile. Please verify and correct any errors.',
              style: TextStyle(
                color: AppColors.accentGreen,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildWarningBanner(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber, color: AppColors.warning, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: AppColors.warning, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptCard() {
    bool expanded = false;
    return StatefulBuilder(
      builder: (context, setLocal) => GestureDetector(
        onTap: () => setLocal(() => expanded = !expanded),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.mic, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  const Text(
                    'Your voice input',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              if (expanded) ...[
                const SizedBox(height: 8),
                Text(
                  _transcript,
                  style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
    int delay = 0,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.textSecondary,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay), duration: 400.ms);
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    String hint, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _isEditing
          ? TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            )
          : _buildReadOnlyRow(
              label,
              controller.text.isEmpty ? '—' : controller.text,
            ),
    );
  }

  Widget _buildReadOnlyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleGrid() {
    final toggles = [
      {'label': 'BPL Card', 'field': 'bpl', 'value': _profile!.hasBPLCard},
      {'label': 'Aadhaar', 'field': 'aadhar', 'value': _profile!.hasAadhar},
      {'label': 'Bank Account', 'field': 'bank', 'value': _profile!.hasBankAccount},
      {'label': 'Widow', 'field': 'widow', 'value': _profile!.isWidow},
      {'label': 'Disabled', 'field': 'disabled', 'value': _profile!.isDisabled},
      {'label': 'Pregnant', 'field': 'pregnant', 'value': _profile!.isPregnant},
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: toggles.map((t) {
        final isYes = t['value'] as bool;
        return GestureDetector(
          onTap: () => _toggleBool(t['field'] as String),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isYes
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isYes ? AppColors.primary : AppColors.border,
                width: isYes ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isYes ? Icons.check_circle : Icons.circle_outlined,
                  size: 14,
                  color: isYes ? AppColors.primary : AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  t['label'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isYes ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
