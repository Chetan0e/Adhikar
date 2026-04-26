import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../generated/l10n/app_localizations.dart';

/// Application History screen — shows all past applications from Hive/Firestore
class ApplicationHistoryScreen extends StatefulWidget {
  const ApplicationHistoryScreen({super.key});

  @override
  State<ApplicationHistoryScreen> createState() =>
      _ApplicationHistoryScreenState();
}

class _ApplicationHistoryScreenState extends State<ApplicationHistoryScreen> {
  bool _isLoading = false;
  List<_AppRecord> _applications = [];

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() => _isLoading = true);
    
    // TODO: Implement actual Firestore + Hive data loading
    // For now, return empty list - will be implemented with SchemeRepository
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _applications = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.applicationHistory),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _applications.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadApplications,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _applications.length,
                    itemBuilder: (context, index) => _ApplicationCard(
                      record: _applications[index],
                      delay: index * 100,
                    ),
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📋', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            l10n.noApplications,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.tryUpdatingProfile,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.eligibleSchemes),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }
}

enum AppStatus { submitted, underReview, approved, rejected }

class _AppRecord {
  final String id;
  final String schemeName;
  final AppStatus status;
  final String submittedDate;
  final String benefit;

  const _AppRecord({
    required this.id,
    required this.schemeName,
    required this.status,
    required this.submittedDate,
    required this.benefit,
  });
}

class _ApplicationCard extends StatefulWidget {
  final _AppRecord record;
  final int delay;

  const _ApplicationCard({required this.record, required this.delay});

  @override
  State<_ApplicationCard> createState() => _ApplicationCardState();
}

class _ApplicationCardState extends State<_ApplicationCard> {
  bool _expanded = false;

  Color get _statusColor {
    switch (widget.record.status) {
      case AppStatus.submitted:
        return Colors.blue;
      case AppStatus.underReview:
        return AppColors.warning;
      case AppStatus.approved:
        return AppColors.accentGreen;
      case AppStatus.rejected:
        return AppColors.error;
    }
  }

  String get _statusLabel {
    final l10n = AppLocalizations.of(context);
    switch (widget.record.status) {
      case AppStatus.submitted:
        return l10n.statusSubmitted;
      case AppStatus.underReview:
        return l10n.statusUnderReview;
      case AppStatus.approved:
        return l10n.statusApproved;
      case AppStatus.rejected:
        return l10n.statusRejected;
    }
  }

  IconData get _statusIcon {
    switch (widget.record.status) {
      case AppStatus.submitted:
        return Icons.send;
      case AppStatus.underReview:
        return Icons.hourglass_empty;
      case AppStatus.approved:
        return Icons.check_circle;
      case AppStatus.rejected:
        return Icons.cancel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.record.schemeName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Status chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _statusColor.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_statusIcon, color: _statusColor, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          _statusLabel,
                          style: TextStyle(
                            color: _statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (_expanded) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                _InfoRow(label: 'Submitted', value: widget.record.submittedDate),
                const SizedBox(height: 6),
                _InfoRow(label: 'Reference', value: widget.record.id),
                const SizedBox(height: 6),
                _InfoRow(label: 'Benefit', value: widget.record.benefit),
              ] else ...[
                const SizedBox(height: 6),
                Text(
                  'Submitted: ${widget.record.submittedDate}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn(
          delay: Duration(milliseconds: widget.delay),
          duration: 400.ms,
        );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
