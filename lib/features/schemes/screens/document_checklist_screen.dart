import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../generated/l10n/app_localizations.dart';

/// Shows a checklist of documents needed for a scheme.
/// User taps to check off documents they have.
/// "How to get" expandable tip for missing ones.
class DocumentChecklistScreen extends StatefulWidget {
  final Map<String, dynamic>? schemeData;

  const DocumentChecklistScreen({super.key, this.schemeData});

  @override
  State<DocumentChecklistScreen> createState() =>
      _DocumentChecklistScreenState();
}

class _DocumentChecklistScreenState extends State<DocumentChecklistScreen> {
  late List<String> _documents;
  late List<bool> _checked;

  @override
  void initState() {
    super.initState();
    final schemeJson =
        widget.schemeData?['scheme'] as Map<String, dynamic>? ?? {};
    final rawDocs = schemeJson['requiredDocuments'] as List? ?? [];
    _documents = rawDocs.cast<String>();

    // Default documents if none specified
    if (_documents.isEmpty) {
      _documents = [
        'Aadhaar Card',
        'Ration Card',
        'Bank Passbook (first page)',
        'Income Certificate',
        'Caste Certificate',
        'Land Records / Khatian',
        'Passport Size Photo',
      ];
    }
    _checked = List.filled(_documents.length, false);
  }

  bool get _allChecked => _checked.every((c) => c);
  int get _missingCount => _checked.where((c) => !c).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.documentsYouNeed),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress indicator
          _buildProgress().animate().fadeIn(duration: 400.ms),

          // Document list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _documents.length,
              itemBuilder: (context, index) => _DocumentItem(
                document: _documents[index],
                isChecked: _checked[index],
                delay: index * 80,
                onToggle: () {
                  setState(() => _checked[index] = !_checked[index]);
                },
              ),
            ),
          ),

          // Bottom action buttons
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    final done = _checked.where((c) => c).length;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.documentsReadyTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '$done ${AppLocalizations.of(context)!.ofWord} ${_documents.length}',
                style: TextStyle(
                  color: _allChecked ? AppColors.accentGreen : AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _documents.isEmpty ? 0 : done / _documents.length,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(
              _allChecked ? AppColors.accentGreen : AppColors.primary,
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
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
            if (!_allChecked && _missingCount > 0)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: AppColors.warning, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$_missingCount ${AppLocalizations.of(context)!.documentsMissing}',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                if (!_allChecked)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(AppLocalizations.of(context)!.documentsSaved)),
                        );
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.saveForLater),
                    ),
                  ),
                if (!_allChecked) const SizedBox(width: 12),
                Expanded(
                  flex: _allChecked ? 1 : 1,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.formFill,
                        arguments: widget.schemeData,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _allChecked
                          ? AppColors.accentGreen
                          : AppColors.primary,
                    ),
                    child: Text(
                      _allChecked ? AppLocalizations.of(context)!.applyNowButton : AppLocalizations.of(context)!.applyAnyway,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentItem extends StatefulWidget {
  final String document;
  final bool isChecked;
  final VoidCallback onToggle;
  final int delay;

  const _DocumentItem({
    required this.document,
    required this.isChecked,
    required this.onToggle,
    required this.delay,
  });

  @override
  State<_DocumentItem> createState() => _DocumentItemState();
}

class _DocumentItemState extends State<_DocumentItem> {
  bool _expanded = false;

  static const Map<String, String> _howToGet = {
    'Aadhaar Card': 'Visit your nearest Aadhaar Seva Kendra or apply online at uidai.gov.in with any valid ID proof.',
    'Ration Card': 'Apply at the district Food & Supply office or through the state civil supplies portal.',
    'Income Certificate': 'Apply at the Tehsil/Taluka office or through the state\'s online portal. Bring salary slips or self-declaration.',
    'Caste Certificate': 'Apply at the Tehsil/Block office with proof of caste (family records, school certificates).',
    'Land Records / Khatian': 'Visit the Revenue/Patwari office or access online via your state\'s land records portal.',
    'Bank Passbook (first page)': 'Collect from your bank branch. Bring Aadhaar for opening an account if needed.',
    'Passport Size Photo': 'Available at any photo studio for ₹30–₹50. Digital copy may also be accepted.',
  };

  @override
  Widget build(BuildContext context) {
    final howTo = _howToGet[widget.document] ?? AppLocalizations.of(context)!.visitGovtOffice;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          InkWell(
            onTap: widget.onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Checkbox
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: widget.isChecked
                          ? AppColors.accentGreen
                          : Colors.transparent,
                      border: Border.all(
                        color: widget.isChecked
                            ? AppColors.accentGreen
                            : AppColors.border,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: widget.isChecked
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                  const SizedBox(width: 12),

                  // Document name
                  Expanded(
                    child: Text(
                      widget.document,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: widget.isChecked
                            ? AppColors.textTertiary
                            : AppColors.textPrimary,
                        decoration: widget.isChecked
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),

                  // "How to get" toggle (only for unchecked)
                  if (!widget.isChecked)
                    TextButton(
                      onPressed: () =>
                          setState(() => _expanded = !_expanded),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        foregroundColor: AppColors.warning,
                      ),
                      child: Text(
                        _expanded ? AppLocalizations.of(context)!.close : AppLocalizations.of(context)!.howToGet,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Expandable tip
          if (_expanded && !widget.isChecked)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.warning.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb, color: AppColors.warning, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      howTo,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 200.ms),
        ],
      ),
    ).animate().fadeIn(
          delay: Duration(milliseconds: widget.delay),
          duration: 400.ms,
        );
  }
}
