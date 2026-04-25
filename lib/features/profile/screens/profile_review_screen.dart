import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/user_profile.dart';
import '../../../../data/remote/gemini_service.dart';
import '../../../../data/local/schemes_database.dart';
import '../../../../core/utils/eligibility_engine.dart';

class ProfileReviewScreen extends StatefulWidget {
  const ProfileReviewScreen({super.key});

  @override
  State<ProfileReviewScreen> createState() => _ProfileReviewScreenState();
}

class _ProfileReviewScreenState extends State<ProfileReviewScreen> {
  final GeminiService _geminiService = GeminiService();
  final EligibilityEngine _eligibilityEngine = EligibilityEngine();
  
  UserProfile? _profile;
  bool _isLoading = true;
  bool _isEditing = false;
  String _transcript = '';

  // Controllers for editing
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _incomeController;
  late TextEditingController _occupationController;
  late TextEditingController _stateController;
  late TextEditingController _districtController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadProfile();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _incomeController = TextEditingController();
    _occupationController = TextEditingController();
    _stateController = TextEditingController();
    _districtController = TextEditingController();
  }

  Future<void> _loadProfile() async {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    if (args != null) {
      _transcript = args['transcript'] ?? '';
      
      // Try to extract profile using Gemini
      if (_transcript.isNotEmpty) {
        // API key is now handled internally by GeminiService or via dart-define
        // _geminiService.setApiKey(const String.fromEnvironment('GEMINI_API_KEY', defaultValue: 'YOUR_API_KEY'));
        
        try {
          final extractedData = await _geminiService.extractProfile(_transcript);
          _profile = UserProfile.fromJson(extractedData);
        } catch (e) {
          // Fallback to offline extraction if Gemini fails
          final extractedData = await _extractProfileOffline(_transcript);
          _profile = UserProfile.fromJson(extractedData);
        }
      } else {
        // Create empty profile
        _profile = UserProfile(
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
          familySize: 0,
          childrenAges: [],
          isPregnant: false,
          educationLevel: '',
          createdAt: DateTime.now(),
        );
      }
      
      _populateControllers();
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<Map<String, dynamic>> _extractProfileOffline(String text) async {
    // Simple keyword-based extraction as fallback
    final result = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': '',
      'age': 0,
      'gender': '',
      'state': '',
      'district': '',
      'caste': '',
      'occupation': '',
      'annual_income': 0,
      'land_holding': 0,
      'is_disabled': false,
      'is_widow': false,
      'has_bpl_card': false,
      'has_aadhar': false,
      'has_bank_account': false,
      'family_size': 0,
      'children_ages': <int>[],
      'is_pregnant': false,
      'education_level': '',
      'created_at': DateTime.now().toIso8601String(),
      'confidence': 0.5,
      'missing_info': ['Could not extract automatically'],
    };

    // Simple extraction logic
    final lowerText = text.toLowerCase();
    
    if (lowerText.contains('farmer') || lowerText.contains('kisan')) {
      result['occupation'] = 'farmer';
      result['annual_income'] = 60000;
    }
    
    if (lowerText.contains('widow') || lowerText.contains('vidhwa')) {
      result['is_widow'] = true;
      result['gender'] = 'female';
    }
    
    if (lowerText.contains('bpl')) {
      result['has_bpl_card'] = true;
    }
    
    if (lowerText.contains('aadhar')) {
      result['has_aadhar'] = true;
    }

    return result;
  }

  void _populateControllers() {
    if (_profile == null) return;
    
    _nameController.text = _profile!.name;
    _ageController.text = _profile!.age.toString();
    _incomeController.text = _profile!.annualIncome.toString();
    _occupationController.text = _profile!.occupation;
    _stateController.text = _profile!.state;
    _districtController.text = _profile!.district;
  }

  void _saveProfile() {
    if (_profile == null) return;

    final updatedProfile = _profile!.copyWith(
      name: _nameController.text,
      age: int.tryParse(_ageController.text) ?? 0,
      annualIncome: double.tryParse(_incomeController.text) ?? 0,
      occupation: _occupationController.text,
      state: _stateController.text,
      district: _districtController.text,
    );

    setState(() {
      _profile = updatedProfile;
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

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _incomeController.dispose();
    _occupationController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    super.dispose();
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
            IconButton(
              icon: Icon(_isEditing ? Icons.check : Icons.edit),
              onPressed: () {
                if (_isEditing) {
                  _saveProfile();
                } else {
                  setState(() {
                    _isEditing = true;
                  });
                }
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _profile == null
              ? const Center(child: Text('No profile data'))
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Text(
                          'Review Your Profile',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ).animate().fadeIn(duration: 400.ms),

                        const SizedBox(height: 8),

                        Text(
                          'Please verify and edit the information below',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

                        const SizedBox(height: 24),

                        // Profile Cards
                        _buildProfileCard('Personal Information', [
                          _buildField('Name', _nameController, 'name'),
                          _buildField('Age', _ageController, 'age', keyboardType: TextInputType.number),
                          _buildField('Gender', _profile!.gender, 'gender', isEditable: false),
                          _buildField('State', _stateController, 'state'),
                          _buildField('District', _districtController, 'district'),
                        ], delay: 200),

                        const SizedBox(height: 16),

                        _buildProfileCard('Economic Information', [
                          _buildField('Occupation', _occupationController, 'occupation'),
                          _buildField('Annual Income (₹)', _incomeController, 'income', keyboardType: TextInputType.number),
                          _buildField('Land Holding (acres)', _profile!.landHolding.toString(), 'land', isEditable: false),
                        ], delay: 300),

                        const SizedBox(height: 16),

                        _buildProfileCard('Social Information', [
                          _buildBooleanField('Has BPL Card', _profile!.hasBPLCard),
                          _buildBooleanField('Has Aadhar Card', _profile!.hasAadhar),
                          _buildBooleanField('Has Bank Account', _profile!.hasBankAccount),
                          _buildBooleanField('Is Widow', _profile!.isWidow),
                          _buildBooleanField('Is Disabled', _profile!.isDisabled),
                        ], delay: 400),

                        const SizedBox(height: 32),

                        // Continue Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _handleContinue,
                            child: const Text('Find Eligible Schemes'),
                          ),
                        ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildProfileCard(String title, List<Widget> children, {int delay = 0}) {
    return Container(
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
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay), duration: 400.ms);
  }

  Widget _buildField(String label, dynamic value, String key, {bool isEditable = true, TextInputType? keyboardType}) {
    if (value is TextEditingController) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextField(
          controller: value,
          enabled: _isEditing && isEditable,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            border: _isEditing ? null : InputBorder.none,
            enabledBorder: _isEditing ? null : InputBorder.none,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              value.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildBooleanField(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: value ? AppColors.accentGreen.withOpacity(0.1) : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: value ? AppColors.accentGreen : AppColors.border,
              ),
            ),
            child: Text(
              value ? 'Yes' : 'No',
              style: TextStyle(
                color: value ? AppColors.accentGreen : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
