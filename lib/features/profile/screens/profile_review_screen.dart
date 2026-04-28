import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../app/router.dart';
import '../../../../core/blocs/language/language_cubit.dart';
import '../../../../core/constants/supported_languages.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/user_profile.dart';
import '../../../../data/remote/gemini_service.dart';
import '../../../../generated/l10n/app_localizations.dart';

class ProfileReviewScreen extends StatefulWidget {
  final Map<String, dynamic>? profileData;
  final String? transcript;
  
  const ProfileReviewScreen({
    this.profileData,
    this.transcript,
    super.key,
  });
  
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
  Map<String, dynamic> _profileMap = {};
  bool _initialized = false;

  AppLocalizations get l => AppLocalizations.of(context)!;

  // Controllers for editing
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    print('ProfileReviewScreen.initState()');
    print('widget.profileData: ${widget.profileData}');
  }

  // Use didChangeDependencies for route args (context available here)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _loadProfile();
    }
  }

  void _loadProfile() {
    // Get profile from constructor or route args
    final routeArgs = ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>?;
    final data = Map<String, dynamic>.from(
        widget.profileData ?? routeArgs ?? {});
    data.remove('_raw_transcript');
    data.remove('_is_fallback');

    print('ProfileReviewScreen._loadProfile: $data');

    setState(() {
      _profileMap = data;

      // Create/update controllers with extracted values
      final textFields = [
        'name', 'age', 'state', 'district',
        'annual_income', 'land_holding_acres', 'family_size',
      ];
      for (final field in textFields) {
        final value = data[field];
        final text = value != null ? value.toString() : '';
        if (_controllers.containsKey(field)) {
          _controllers[field]!.text = text;
        } else {
          _controllers[field] = TextEditingController(text: text);
        }
      }

      if (_profileMap.isNotEmpty) {
        _profile = UserProfile.fromJson(_profileMap);
        _transcript = widget.transcript ?? data['_raw_transcript'] as String? ?? '';
      }

      _isLoading = false;
    });
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
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

  void _saveProfile() {
    if (_profile == null) return;
    setState(() {
      _profile = _profile!.copyWith(
        name: _controllers['name']?.text.trim() ?? _profile!.name,
        age: int.tryParse(_controllers['age']?.text ?? '') ?? _profile!.age,
        annualIncome:
            double.tryParse(_controllers['annual_income']?.text ?? '') ?? _profile!.annualIncome,
        occupation: _profile!.occupation,
        state: _controllers['state']?.text.trim() ?? _profile!.state,
        district: _controllers['district']?.text.trim() ?? _profile!.district,
        caste: _profile!.caste,
      );
      _isEditing = false;
    });
  }

  void _handleContinue() {
    if (_profile == null) return;
    
    // Sync controller values to _profileMap first
    final textFields = [
      'name', 'age', 'state', 'district',
      'annual_income', 'land_holding_acres', 'family_size',
    ];
    for (final field in textFields) {
      final controller = _controllers[field];
      if (controller != null) {
        final text = controller.text.trim();
        if (text.isEmpty) {
          _profileMap.remove(field);
        } else {
          _profileMap[field] = (field == 'age' || field == 'family_size' || field == 'annual_income')
              ? (int.tryParse(text) ?? double.tryParse(text) ?? text)
              : text;
        }
      }
    }
    
    Navigator.pushNamed(
      context,
      AppRouter.schemes,
      arguments: _profileMap,
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
    final l = AppLocalizations.of(context)!;
    
    // Show loading only if truly not initialized
    if (_profileMap.isEmpty && !_initialized) {
      return Scaffold(
        appBar: AppBar(title: Text(l.profileReview)),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l.profileReview),
        elevation: 0,
        actions: [
          if (!_isLoading)
            TextButton.icon(
              onPressed: () {
                if (_isEditing) {
                  _saveProfile();
                } else {
                  setState(() => _isEditing = true);
                }
              },
              icon: Icon(_isEditing ? Icons.check : Icons.edit, size: 18),
              label: Text(_isEditing ? l.save : l.editProfile),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // Show fallback warning if no name extracted
              if (_profileMap['name'] == null)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    border: Border.all(color: Colors.amber),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Some details not detected. Please fill manually.',
                    style: TextStyle(color: Colors.amber.shade900, fontSize: 13),
                  ),
                ),
              
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
                title: '👤  ${l.personalInfo}',
                delay: 200,
                children: [
                  _buildEditableRow(l.fieldName, 'name'),
                  _buildEditableRow(l.fieldAge, 'age'),
                  _buildDropdownRow(l.fieldGender, 'gender', ['male', 'female']),
                  _buildEditableRow(l.fieldState, 'state'),
                  _buildEditableRow(l.fieldDistrict, 'district'),
                  _buildDropdownRow(l.fieldCaste, 'caste', 
                      ['general', 'obc', 'sc', 'st', 'minority']),
                ],
              ),

              const SizedBox(height: 12),

              // Economic Info
              _buildSection(
                title: '💰  ${l.economicInfo}',
                delay: 300,
                children: [
                  _buildDropdownRow(l.fieldOccupation, 'occupation',
                      ['farmer', 'student', 'daily_wage', 'business', 
                       'government', 'unemployed']),
                  _buildEditableRow(l.fieldAnnualIncome, 'annual_income'),
                  _buildEditableRow(l.fieldLandHolding, 'land_holding_acres'),
                  _buildEditableRow(l.fieldFamilySize, 'family_size'),
                ],
              ),

              const SizedBox(height: 12),

              // Social Status (toggleable chips)
              _buildSection(
                title: '🏷️  ${l.socialStatus}',
                delay: 400,
                children: [
                  _buildSwitchRow(l.fieldBplCard, 'has_bpl_card'),
                  _buildSwitchRow(l.fieldAadhaar, 'has_aadhar'),
                  _buildSwitchRow(l.fieldBankAccount, 'has_bank_account'),
                  _buildSwitchRow(l.fieldWidow, 'is_widow'),
                  _buildSwitchRow(l.fieldDisabled, 'is_disabled'),
                  _buildSwitchRow(l.fieldPregnant, 'is_pregnant'),
                ],
              ),

              const SizedBox(height: 24),

              // Continue CTA
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.search),
                  label: Text(l.eligibleSchemes, 
                      style: const TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B3A8C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _onFindSchemes,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableRow(String label, String key) {
    // Ensure controller exists
    if (!_controllers.containsKey(key)) {
      final value = _profileMap[key];
      _controllers[key] = TextEditingController(
        text: value != null ? value.toString() : '',
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: _controllers[key],
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                _profileMap[key] = v.isEmpty ? null :
                    (key == 'age' || key == 'family_size' || key == 'annual_income'
                        ? int.tryParse(v) ?? v : v);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownRow(String label, String key, List<String> options) {
    final current = _profileMap[key] as String?;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ),
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<String>(
              value: options.contains(current) ? current : null,
              isExpanded: true,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: null, child: Text('—')),
                ...options.map((o) => DropdownMenuItem(value: o, child: Text(o))),
              ],
              onChanged: (v) => setState(() => _profileMap[key] = v),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String label, String key) {
    return SwitchListTile(
      title: Text(label, style: const TextStyle(fontSize: 14)),
      value: _profileMap[key] == true,
      onChanged: (v) => setState(() => _profileMap[key] = v),
      activeColor: const Color(0xFF1B3A8C),
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  void _onFindSchemes() {
    // Sync controller values to _profileMap before saving
    final textFields = [
      'name', 'age', 'state', 'district',
      'annual_income', 'land_holding_acres', 'family_size',
    ];
    for (final field in textFields) {
      final controller = _controllers[field];
      if (controller != null) {
        final text = controller.text.trim();
        if (text.isEmpty) {
          _profileMap.remove(field);
        } else {
          _profileMap[field] = (field == 'age' || field == 'family_size' || field == 'annual_income')
              ? (int.tryParse(text) ?? double.tryParse(text) ?? text)
              : text;
        }
      }
    }

    // Save to Hive for persistence
    final box = Hive.box('user_profiles');
    box.put('current_profile', _profileMap);
    
    print('Finding schemes for profile: $_profileMap');
    
    // Navigate to scheme list with real profile using named route
    Navigator.pushNamed(
      context,
      AppRouter.schemes,
      arguments: _profileMap,
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
            'AI is analyzing your voice input…',
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
      ),
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
          const Icon(Icons.check_circle, color: AppColors.accentGreen, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'AI successfully extracted your profile. Please verify and correct any errors.',
              style: TextStyle(color: AppColors.accentGreen, fontSize: 13),
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
    final l = AppLocalizations.of(context)!;
    final toggles = [
      {'label': l.fieldBplCard, 'field': 'bpl', 'value': _profile!.hasBPLCard},
      {'label': l.fieldAadhaar, 'field': 'aadhar', 'value': _profile!.hasAadhar},
      {'label': l.fieldBankAccount, 'field': 'bank', 'value': _profile!.hasBankAccount},
      {'label': l.fieldWidow, 'field': 'widow', 'value': _profile!.isWidow},
      {'label': l.fieldDisabled, 'field': 'disabled', 'value': _profile!.isDisabled},
      {'label': l.fieldPregnant, 'field': 'pregnant', 'value': _profile!.isPregnant},
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

  String _localizeGender(String? gender, AppLocalizations l) {
    return switch(gender) {
      'male' => l.genderMale,
      'female' => l.genderFemale,
      _ => l.notDetected,
    };
  }

  String _localizeOccupation(String? occ, AppLocalizations l) {
    return switch(occ) {
      'farmer' => l.occupationFarmer,
      'student' => l.occupationStudent,
      'daily_wage' => l.occupationDailyWage,
      'business' => l.occupationBusiness,
      'government' => l.occupationGovernment,
      'unemployed' => l.occupationUnemployed,
      _ => l.notDetected,
    };
  }
}
