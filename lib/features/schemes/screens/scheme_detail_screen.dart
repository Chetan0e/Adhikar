import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/scheme_categories.dart';
import '../../../../core/blocs/language/language_cubit.dart';
import '../../../../data/models/scheme.dart';

class SchemeDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? schemeData;

  const SchemeDetailScreen({super.key, this.schemeData});

  @override
  Widget build(BuildContext context) {
    final langCode = context.read<LanguageCubit>().currentLanguageCode;
    
    if (schemeData == null) {
      return const Scaffold(
        body: Center(child: Text('No scheme data')),
      );
    }

    final schemeJson = schemeData!['scheme'] as Map<String, dynamic>;
    final matchData = schemeData!['match'] as Map<String, dynamic>;
    
    final scheme = Scheme.fromJson(schemeJson);
    final confidence = (matchData['confidence'] as num).toDouble();
    final reasons = List<String>.from(matchData['reasons'] as List);
    final missingDocuments = List<String>.from(matchData['missingDocuments'] as List);
    final displayName = scheme.nameForLocale(langCode);
    final displayDescription = scheme.descriptionForLocale(langCode);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Scheme Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            _buildHeaderCard(scheme, displayName).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // Confidence Card
            _buildConfidenceCard(context, confidence, reasons).animate().fadeIn(delay: 200.ms, duration: 400.ms),

            const SizedBox(height: 16),

            // Description Card
            _buildInfoCard(context, 'Description', displayDescription).animate().fadeIn(delay: 300.ms, duration: 400.ms),

            const SizedBox(height: 16),

            // Documents Required Card
            _buildDocumentsCard(context, missingDocuments).animate().fadeIn(delay: 400.ms, duration: 400.ms),

            const SizedBox(height: 16),

            // Application Info Card
            _buildApplicationCard(context, scheme).animate().fadeIn(delay: 500.ms, duration: 400.ms),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, scheme, displayName).animate().slide(begin: const Offset(0, 1), duration: 400.ms),
    );
  }

  Widget _buildHeaderCard(Scheme scheme, String displayName) {
    final categoryColor = _getCategoryColor(scheme.category);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [categoryColor, categoryColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentWhite.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              SchemeCategories.categoryNames[scheme.category] ?? scheme.category,
              style: const TextStyle(
                color: AppColors.accentWhite,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Scheme Name
          Text(
            displayName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.accentWhite,
            ),
          ),
          const SizedBox(height: 16),
          // Benefit Amount
          Row(
            children: [
              const Icon(Icons.card_giftcard, color: AppColors.accentWhite),
              const SizedBox(width: 8),
              Text(
                scheme.benefitAmount,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentWhite,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceCard(BuildContext context, double confidence, List<String> reasons) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Eligibility Score',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: confidence >= 0.8
                      ? AppColors.accentGreen.withOpacity(0.1)
                      : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: confidence >= 0.8 ? AppColors.accentGreen : AppColors.warning,
                  ),
                ),
                child: Text(
                  '${(confidence * 100).toInt()}%',
                  style: TextStyle(
                    color: confidence >= 0.8 ? AppColors.accentGreen : AppColors.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Bar
          LinearProgressIndicator(
            value: confidence,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(
              confidence >= 0.8 ? AppColors.accentGreen : AppColors.warning,
            ),
          ),
          const SizedBox(height: 16),
          // Reasons
          Text(
            'Why Eligible:',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ...reasons.map((reason) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: AppColors.primary)),
                    Expanded(
                      child: Text(
                        reason,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String content) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          const SizedBox(height: 12),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsCard(BuildContext context, List<String> documents) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            'Required Documents',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          ...documents.map((doc) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.description,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        doc,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(BuildContext context, Scheme scheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            'Application Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(context, 'Ministry', scheme.ministry),
          const SizedBox(height: 8),
          _buildInfoRow(context, 'Apply At', scheme.applicationOffice),
          const SizedBox(height: 16),
          if (scheme.applicationUrl.isNotEmpty)
            OutlinedButton.icon(
              onPressed: () => _launchUrl(scheme.applicationUrl),
              icon: const Icon(Icons.open_in_new, size: 18),
              label: const Text('Visit Official Website'),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, Scheme scheme, String displayName) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top row: Share + Documents
            Row(
              children: [
                // Share button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _shareScheme(scheme, displayName),
                    icon: const Icon(Icons.share, size: 16),
                    label: const Text('Share'),
                  ),
                ),
                const SizedBox(width: 12),
                // Documents checklist
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.documentChecklist,
                        arguments: schemeData,
                      );
                    },
                    icon: const Icon(Icons.checklist, size: 16),
                    label: const Text('Documents'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Apply button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.formFill,
                    arguments: schemeData,
                  );
                },
                child: const Text('Apply Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareScheme(Scheme scheme, String displayName) {
    final text = '$displayName\n'
        'Benefit: ${scheme.benefitAmount}\n'
        'Eligibility: ${scheme.eligibility}\n'
        'Apply at: ${scheme.applicationUrl.isNotEmpty ? scheme.applicationUrl : scheme.applicationOffice}\n\n'
        'Found using Adhikar app';
    Share.share(text, subject: displayName);
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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
