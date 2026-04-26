import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../../app/router.dart';
import '../../../../core/blocs/language/language_cubit.dart';
import '../../../../core/blocs/language/language_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/scheme_categories.dart';
import '../../../../core/services/tts_service.dart';
import '../../../../data/models/scheme.dart';
import '../../../../data/models/user_profile.dart';
import '../../../../data/local/schemes_database.dart';
import '../../../../core/utils/eligibility_engine.dart';

class SchemeListScreen extends StatefulWidget {
  const SchemeListScreen({super.key});

  @override
  State<SchemeListScreen> createState() => _SchemeListScreenState();
}

class _SchemeListScreenState extends State<SchemeListScreen> {
  final EligibilityEngine _eligibilityEngine = EligibilityEngine();
  final TtsService _ttsService = TtsService();

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  UserProfile? _profile;
  List<SchemeMatch> _matchedSchemes = [];
  List<SchemeMatch> _filteredSchemes = [];
  String _selectedCategory = 'All';
  bool _isLoading = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = ['All', ...SchemeCategories.categoryNames.keys];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _ttsService.stop();
    super.dispose();
  }

  Future<void> _loadData() async {
    print('[SchemeList] _loadData called');
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null) {
      // Called from HomeScreen tab — load all schemes from local database
      print('[SchemeList] Loading from local database (no profile)');
      setState(() => _isLoading = true);
      try {
        await _loadSchemes();
      } catch (e) {
        print('[SchemeList] Error in _loadSchemes: $e');
      }
      setState(() => _isLoading = false);
      print('[SchemeList] Loading complete, _isLoading = false');
      return;
    }

    setState(() => _isLoading = true);

    final argMap = args as Map;
    _profile = UserProfile.fromJson(Map<String, dynamic>.from(argMap));

    // Load from Firestore
    try {
      final schemesSnapshot = await _firestore
          .collection('schemes')
          .where('is_active', isEqualTo: true)
          .get();
      
      final schemes = schemesSnapshot.docs.map((doc) {
        final data = doc.data();
        // Convert Firestore format to Scheme model format
        return Scheme.fromJson(data);
      }).toList();

      _matchedSchemes = _eligibilityEngine.matchSchemes(_profile!, schemes);
      _filteredSchemes = List.from(_matchedSchemes);

      // Speak results in selected language
      if (mounted) {
        final langCode = context.read<LanguageCubit>().currentLanguageCode;
        final count = _filteredSchemes.length;
        final totalBenefit = _filteredSchemes.fold<double>(
          0,
          (sum, match) => sum + _eligibilityEngine.extractBenefitAmount(match.estimatedBenefit),
        );
        final msg = _buildResultMessage(langCode, count, totalBenefit);
        await _ttsService.init();
        await _ttsService.speak(msg, langCode);
      }
    } catch (e) {
      print('Error loading schemes from Firestore: $e');
      _matchedSchemes = [];
      _filteredSchemes = [];
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _loadSchemes() async {
    print('[SchemeList] _loadSchemes started');
    try {
      // Load all schemes from local database
      print('[SchemeList] Getting schemes from SchemesDatabase');
      final schemesData = SchemesDatabase.getAllSchemes();
      print('[SchemeList] Found ${schemesData.length} schemes in database');
      final schemes = schemesData.map((data) => Scheme.fromJson(data)).toList();
      
      // Create SchemeMatch objects with default confidence
      _matchedSchemes = schemes.map((scheme) => SchemeMatch(
        scheme: scheme,
        confidence: 1.0,
        reasons: ['Browse all schemes'],
        missingDocuments: [],
        estimatedBenefit: scheme.benefitAmount,
      )).toList();
      
      _filteredSchemes = List.from(_matchedSchemes);
      print('[SchemeList] Loaded ${_matchedSchemes.length} schemes');
    } catch (e) {
      print('[SchemeList] Error loading schemes from local database: $e');
      _matchedSchemes = [];
      _filteredSchemes = [];
    }
    print('[SchemeList] _loadSchemes completed');
  }

  String _buildResultMessage(String langCode, int count, double totalBenefit) {
    switch (langCode) {
      case 'hi':
        return 'आप $count सरकारी योजनाओं के लिए पात्र हैं। कुल लाभ ₹${totalBenefit.toInt()}';
      case 'mr':
        return 'तुम्ही $count सरकारी योजनांसाठी पात्र आहात. एकूण लाभ ₹${totalBenefit.toInt()}';
      case 'ta':
        return 'நீங்கள் $count அரசு திட்டங்களுக்கு தகுதியானவர்கள். மொத்த பயன் ₹${totalBenefit.toInt()}';
      case 'te':
        return 'మీరు $count ప్రభుత్వ పథకాలకు అర్హులు. మొత్తం లాభం ₹${totalBenefit.toInt()}';
      case 'kn':
        return 'ನೀವು $count ಸರ್ಕಾರಿ ಯೋಜನೆಗಳಿಗೆ ಅರ್ಹರಾಗಿದ್ದೀರಿ. ಒಟ್ಟು ಪ್ರಯೋಜನ ₹${totalBenefit.toInt()}';
      case 'bn':
        return 'আপনি $count সরকারি প্রকল্পের জন্য যোগ্য। মোট সুবিধা ₹${totalBenefit.toInt()}';
      case 'gu':
        return 'તમે $count સરકારી યોજનાઓ માટે પાત્ર છો. કુલ લાભ ₹${totalBenefit.toInt()}';
      case 'ml':
        return 'നിങ്ങൾ $count സർക്കാർ പദ്ധതികൾക്ക് അർഹരാണ്. ആകെ ആനുകൂല്യം ₹${totalBenefit.toInt()}';
      case 'or':
        return 'ଆପଣ $count ସରକାରୀ ଯୋଜନା ପାଇଁ ଯୋଗ୍ୟ. ମୋଟ ଲାଭ ₹${totalBenefit.toInt()}';
      case 'pa':
        return 'ਤੁਸੀਂ $count ਸਰਕਾਰੀ ਯੋਜਨਾਵਾਂ ਲਈ ਯੋਗ ਹੋ। ਕੁੱਲ ਲਾਭ ₹${totalBenefit.toInt()}';
      default:
        return 'You are eligible for $count government schemes worth ₹${totalBenefit.toInt()} in total benefits.';
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _applyFilters();
    });
  }

  void _applyFilters() {
    final langCode = context.read<LanguageCubit>().currentLanguageCode;
    _filteredSchemes = _matchedSchemes.where((match) {
      final categoryMatch =
          _selectedCategory == 'All' || match.scheme.category == _selectedCategory;
      final name = match.scheme.nameForLocale(langCode);
      final description = match.scheme.descriptionForLocale(langCode);
      final searchMatch = _searchQuery.isEmpty ||
          name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          description.toLowerCase().contains(_searchQuery.toLowerCase());
      return categoryMatch && searchMatch;
    }).toList();
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
    return BlocListener<LanguageCubit, LanguageState>(
      listenWhen: (p, c) => p.languageCode != c.languageCode,
      listener: (_, __) {
        setState(() {}); // rebuild for localized labels
        _applyFilters(); // reapply filters with new language
      },
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, langState) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildSearchBar(),
                  _buildCategoryFilter(),
                  _buildResultsSummary(),
                  Expanded(
            child: _buildSchemeList(),
          ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    final hasProfile = _profile != null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasProfile ? 'Your Eligible Schemes' : 'All Schemes',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (hasProfile && _profile!.name.isNotEmpty)
                  Text(
                    'For ${_profile!.name}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          // TTS replay button
          IconButton(
            icon: const Icon(Icons.volume_up, color: AppColors.primary),
            tooltip: 'Hear results',
            onPressed: () async {
              if (_profile != null) {
                final langCode = context.read<LanguageCubit>().currentLanguageCode;
                final total = _filteredSchemes.fold<double>(
                  0,
                  (s, m) => s + _eligibilityEngine.extractBenefitAmount(m.estimatedBenefit),
                );
                await _ttsService.speak(
                  _buildResultMessage(langCode, _filteredSchemes.length, total),
                  langCode,
                );
              }
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search schemes…',
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                      _applyFilters();
                    });
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          filled: true,
          fillColor: AppColors.card,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _applyFilters();
          });
        },
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat;
          final label = cat == 'All'
              ? 'All'
              : SchemeCategories.categoryNames[cat] ?? cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) => _filterByCategory(cat),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
              backgroundColor: AppColors.card,
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 150.ms, duration: 400.ms);
  }

  Widget _buildResultsSummary() {
    if (_isLoading || _matchedSchemes.isEmpty) return const SizedBox.shrink();

    final total = _filteredSchemes.fold<double>(
      0,
      (s, m) => s + _eligibilityEngine.extractBenefitAmount(m.estimatedBenefit),
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _SummaryPill(
            icon: Icons.check_circle,
            label: '${_filteredSchemes.length} Eligible',
          ),
          const SizedBox(width: 16),
          const Spacer(),
          _SummaryPill(
            icon: Icons.currency_rupee,
            label: '₹${(total / 1000).toStringAsFixed(0)}K Benefits',
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildSchemeList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredSchemes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🔍', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No schemes match "$_searchQuery"'
                  : 'No schemes in this category',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ).animate().fadeIn(duration: 400.ms),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: _filteredSchemes.length,
      itemBuilder: (context, index) {
        final match = _filteredSchemes[index];
        return _SchemeCard(
          match: match,
          delay: index * 60,
          onTap: () => _viewSchemeDetail(match),
        );
      },
    );
  }
}

class _SummaryPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SummaryPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
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
    final langCode = context.read<LanguageCubit>().currentLanguageCode;
    final scheme = match.scheme;
    final confidence = match.confidence;
    final catColor = AppColors.forCategory(scheme.category);
    final pct = (confidence * 100).round();
    final displayName = scheme.nameForLocale(langCode);
    final displayDescription = scheme.descriptionForLocale(langCode);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Category color stripe + scheme name
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              decoration: BoxDecoration(
                color: catColor.withValues(alpha: 0.05),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category icon
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _categoryIcon(scheme.category),
                      color: catColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (displayDescription.isNotEmpty)
                          Text(
                            displayDescription,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Eligibility badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _confidenceColor(confidence).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _confidenceColor(confidence).withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      '$pct%',
                      style: TextStyle(
                        color: _confidenceColor(confidence),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Benefit + Category + Arrow row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              child: Row(
                children: [
                  const Icon(Icons.currency_rupee, size: 16, color: AppColors.accentGreen),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      scheme.benefitAmount,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.accentGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      SchemeCategories.categoryNames[scheme.category] ?? scheme.category,
                      style: TextStyle(
                        fontSize: 11,
                        color: catColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary),
                ],
              ),
            ),
            // Confidence bar
            if (confidence < 1.0)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: LinearProgressIndicator(
                  value: confidence,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(_confidenceColor(confidence)),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(
          delay: Duration(milliseconds: delay),
          duration: 350.ms,
        );
  }

  Color _confidenceColor(double confidence) {
    if (confidence >= 0.8) return AppColors.accentGreen;
    if (confidence >= 0.6) return AppColors.warning;
    return AppColors.error;
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'agriculture': return Icons.grass;
      case 'health': return Icons.health_and_safety;
      case 'education': return Icons.school;
      case 'housing': return Icons.home;
      case 'women': return Icons.woman;
      case 'employment': return Icons.work;
      case 'disability': return Icons.accessible;
      case 'senior': return Icons.elderly;
      default: return Icons.public;
    }
  }
}

class _FirestoreSchemeCard extends StatelessWidget {
  final Scheme scheme;
  final String langCode;
  final VoidCallback onTap;
  final int delay;

  const _FirestoreSchemeCard({
    required this.scheme,
    required this.langCode,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final catColor = AppColors.forCategory(scheme.category);
    final displayName = scheme.nameForLocale(langCode);
    final displayDescription = scheme.descriptionForLocale(langCode);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Category color stripe + scheme name
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              decoration: BoxDecoration(
                color: catColor.withValues(alpha: 0.05),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category icon
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _categoryIcon(scheme.category),
                      color: catColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Scheme name and description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          displayDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Benefit + Category + Arrow row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              child: Row(
                children: [
                  const Icon(Icons.currency_rupee, size: 16, color: AppColors.accentGreen),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      scheme.benefitAmount,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.accentGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      SchemeCategories.categoryNames[scheme.category] ?? scheme.category,
                      style: TextStyle(
                        fontSize: 11,
                        color: catColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
          delay: Duration(milliseconds: delay),
          duration: 350.ms,
        );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'agriculture': return Icons.grass;
      case 'health': return Icons.health_and_safety;
      case 'education': return Icons.school;
      case 'housing': return Icons.home;
      case 'women': return Icons.woman;
      case 'employment': return Icons.work;
      case 'disability': return Icons.accessible;
      case 'senior': return Icons.elderly;
      default: return Icons.public;
    }
  }
}
