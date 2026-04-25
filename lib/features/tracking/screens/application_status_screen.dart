import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/application.dart';

class ApplicationStatusScreen extends StatefulWidget {
  const ApplicationStatusScreen({super.key});

  @override
  State<ApplicationStatusScreen> createState() => _ApplicationStatusScreenState();
}

class _ApplicationStatusScreenState extends State<ApplicationStatusScreen> {
  // Mock data - in real app, this would come from Firebase
  final List<Application> _applications = [
    Application(
      id: 'APP001',
      schemeId: 'AG001',
      userId: 'USER001',
      status: ApplicationStatus.submitted,
      filledFormData: {
        'applicant_name': 'Sunita Devi',
        'mobile': '9876543210',
      },
      uploadedDocumentUrls: ['doc1.pdf', 'doc2.pdf'],
      appliedAt: DateTime.now().subtract(const Duration(days: 5)),
      referenceNumber: 'REF20260012345',
    ),
    Application(
      id: 'APP002',
      schemeId: 'WC003',
      userId: 'USER001',
      status: ApplicationStatus.under_review,
      filledFormData: {
        'applicant_name': 'Sunita Devi',
        'mobile': '9876543210',
      },
      uploadedDocumentUrls: ['doc3.pdf'],
      appliedAt: DateTime.now().subtract(const Duration(days: 15)),
      referenceNumber: 'REF20260012346',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Applications'),
        elevation: 0,
      ),
      body: _applications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _applications.length,
              itemBuilder: (context, index) {
                return _ApplicationCard(
                  application: _applications[index],
                  delay: index * 100,
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
            Icons.folder_open,
            size: 80,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No Applications Yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Apply for schemes to track them here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final Application application;
  final int delay;

  const _ApplicationCard({
    required this.application,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(application.status);
    final statusIcon = _getStatusIcon(application.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Application #${application.id}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Scheme ID: ${application.schemeId}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        application.status.displayName,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Reference Number
            if (application.referenceNumber != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.receipt_long, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Ref: ${application.referenceNumber}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Applied Date
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  'Applied on: ${_formatDate(application.appliedAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Documents
            Row(
              children: [
                const Icon(Icons.attach_file, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  '${application.uploadedDocumentUrls.length} documents uploaded',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text('Download'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay), duration: 400.ms);
  }

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.draft:
        return AppColors.textTertiary;
      case ApplicationStatus.submitted:
        return AppColors.info;
      case ApplicationStatus.under_review:
        return AppColors.warning;
      case ApplicationStatus.approved:
        return AppColors.accentGreen;
      case ApplicationStatus.rejected:
        return AppColors.error;
      case ApplicationStatus.pending_documents:
        return AppColors.warning;
    }
  }

  IconData _getStatusIcon(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.draft:
        return Icons.edit;
      case ApplicationStatus.submitted:
        return Icons.send;
      case ApplicationStatus.under_review:
        return Icons.pending;
      case ApplicationStatus.approved:
        return Icons.check_circle;
      case ApplicationStatus.rejected:
        return Icons.cancel;
      case ApplicationStatus.pending_documents:
        return Icons.warning;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
