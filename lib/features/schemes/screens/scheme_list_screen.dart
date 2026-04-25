import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/scheme_categories.dart';
import '../../../../data/models/scheme.dart';
import '../../../../data/models/user_profile.dart';
import '../../../../data/local/schemes_database.dart';
import '../../../../core/utils/eligibility_engine.dart';
import '../../../../core/services/tts_service.dart';

class SchemeListScreen extends StatefulWidget {
  const SchemeListScreen({super.key});

  @override
  State<SchemeListScreen> createState() => _SchemeListScreenState();
}

class _SchemeListScreenState extends State<SchemeListScreen> {
  final EligibilityEngine _eligibilityEngine = EligibilityEngine();
  final TTSService _ttsService = TTSService();
  
  UserProfile? _profile;
  List<SchemeMatch> _matchedSchemes = [];
  List<SchemeMatch> _filteredSchemes = [];
  String _selectedCategory = 'All';
  bool _isLoading = true;
  bool _isOnline = true;

  final List<String> _categories = ['All', ...SchemeCategories.categoryNames.keys];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    if (args != null) {
      _profile = UserProfile.fromJson(args);
      
      // Load schemes from database
      final schemesData = SchemesDatabase.getAllSchemes();
      final schemes = schemesData.map((e) => Scheme.fromJson(e)).toList();
      
      // Match schemes
      _matchedSchemes = _eligibilityEngine.matchSchemes(_profile!, schemes);
      _filteredSchemes = _matchedSchemes;
      
      // Calculate total benefit
      final totalBenefit = _filteredSchemes.fold<double>(0, (sum, match) {
        return sum + _eligibilityEngine.extractBenefitAmount(match.estimatedBenefit);
      });

      // Speak results
      await _ttsService.speak(
        'You are eligible for ${_filteredSchemes.length} schemes worth total benefits of ₹${totalBenefit.toInt()}',
      );
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'All') {
        _filteredSchemes = _matchedSchemes;
      } else {
        _filteredSchemes = _matchedSchemes
            .where((match) => match.scheme.category == category)
            .toList();
      }
    });
  }

  void _viewSchemeDetail(SchemeMatch match) {
    Navigator.pushNamed(
      context,
      AppRouter.schemeDetail,
      arguments: {
        'scheme': match.scheme.toJson(),
        'match': {
          'confidence': match.confidence,
          'reasons': match.reasons,
          'missingDocuments': match.missingDocuments,
        },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Eligible Schemes'),
        elevation: 0,
        actions: [
          if (!_isOnline)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warning,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.offline_bolt, size: 16, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    'Offline',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredSchemes.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    // Summary Card
                    _buildSummaryCard().animate().fadeIn(duration: 400.ms),

                    const SizedBox(height: 16),

                    // Category Filter
                    _buildCategoryFilter().animate().fadeIn(delay: 200.ms, duration: 400.ms),

                    const SizedBox(height: 16),

                    // Scheme List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredSchemes.length,
                        itemBuilder: (context, index) {
                          return _SchemeCard(
                            match: _filteredSchemes[index],
                            onTap: () => _viewSchemeDetail(_filteredSchemes[index]),
                            delay: index * 100,
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildSummaryCard() {
    final totalBenefit = _filteredSchemes.fold<double>(0, (sum, match) {
      return sum + _eligibilityEngine.extractBenefitAmount(match.estimatedBenefit);
    });

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '${_filteredSchemes.length} Schemes Eligible',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.accentWhite,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${totalBenefit.toInt()} / year',
            style: const TextStyle(
              fontSize: 32,
              color: AppColors.accentWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Total Estimated Benefits',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.accentWhite.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          final displayName = SchemeCategories.categoryNames[category] ?? category;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(displayName),
              selected: isSelected,
              onSelected: (_) => _filterByCategory(category),
              selectedColor: AppColors.primary.withOpacity(0.1),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No schemes found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Try updating your profile information',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SchemeCard extends StatelessWidget {
  final SchemeMatch match;
  final VoidCallback onTap;
  final int delay;

  const _SchemeCard({
    required this.match,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = match.scheme;
    final categoryColor = _getCategoryColor(scheme.category);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Category Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(scheme.category),
                  color: categoryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Scheme Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scheme.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      match.estimatedBenefit,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            SchemeCategories.categoryNames[scheme.category] ?? scheme.category,
                            style: TextStyle(
                              fontSize: 11,
                              color: categoryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(match.confidence * 100).toInt()}% match',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay), duration: 400.ms);
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'agriculture':
        return AppColors.agriculture;
      case 'health':
        return AppColors.health;
      case 'education':
        return AppColors.education;
      case 'housing':
        return AppColors.housing;
      case 'women':
        return AppColors.women;
      case 'employment':
        return AppColors.employment;
      case 'disability':
        return AppColors.disability;
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'agriculture':
        return Icons.agriculture;
      case 'health':
        return Icons.health_and_safety;
      case 'education':
        return Icons.school;
      case 'housing':
        return Icons.home;
      case 'women':
        return Icons.pregnant_woman;
      case 'employment':
        return Icons.work;
      case 'disability':
        return Icons.accessible;
      default:
        return Icons.account_balance;
    }
  }
}
