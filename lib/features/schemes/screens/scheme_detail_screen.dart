import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/scheme_categories.dart';
import '../../../../data/models/scheme.dart';

class SchemeDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? schemeData;

  const SchemeDetailScreen({super.key, this.schemeData});

  @override
  Widget build(BuildContext context) {
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
            _buildHeaderCard(scheme).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // Confidence Card
            _buildConfidenceCard(confidence, reasons).animate().fadeIn(delay: 200.ms, duration: 400.ms),

            const SizedBox(height: 16),

            // Description Card
            _buildInfoCard('Description', scheme.description).animate().fadeIn(delay: 300.ms, duration: 400.ms),

            const SizedBox(height: 16),

            // Documents Required Card
            _buildDocumentsCard(missingDocuments).animate().fadeIn(delay: 400.ms, duration: 400.ms),

            const SizedBox(height: 16),

            // Application Info Card
            _buildApplicationCard(scheme).animate().fadeIn(delay: 500.ms, duration: 400.ms),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, scheme).animate().slideUp(begin: const Offset(0, 1), duration: 400.ms),
    );
  }

  Widget _buildHeaderCard(Scheme scheme) {
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
            scheme.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.accentWhite,
            ),
          ),
          const SizedBox(height: 8),
          // Hindi Name
          if (scheme.nameHindi.isNotEmpty)
            Text(
              scheme.nameHindi,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.accentWhite.withOpacity(0.9),
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

  Widget _buildConfidenceCard(double confidence, List<String> reasons) {
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

  Widget _buildInfoCard(String title, String content) {
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

  Widget _buildDocumentsCard(List<String> documents) {
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

  Widget _buildApplicationCard(Scheme scheme) {
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
          _buildInfoRow('Ministry', scheme.ministry),
          const SizedBox(height: 8),
          _buildInfoRow('Apply At', scheme.applicationOffice),
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

  Widget _buildInfoRow(String label, String value) {
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

  Widget _buildBottomBar(BuildContext context, Scheme scheme) {
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
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
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
