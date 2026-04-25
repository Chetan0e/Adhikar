class Application {
  final String id;
  final String schemeId;
  final String userId;
  final ApplicationStatus status;
  final Map<String, String> filledFormData;
  final List<String> uploadedDocumentUrls;
  final DateTime appliedAt;
  final DateTime? lastUpdated;
  final String? referenceNumber;
  final String? notes;

  Application({
    required this.id,
    required this.schemeId,
    required this.userId,
    required this.status,
    required this.filledFormData,
    required this.uploadedDocumentUrls,
    required this.appliedAt,
    this.lastUpdated,
    this.referenceNumber,
    this.notes,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'],
      schemeId: json['scheme_id'],
      userId: json['user_id'],
      status: ApplicationStatus.values.firstWhere(
        (e) => e.toString() == 'ApplicationStatus.${json['status']}',
        orElse: () => ApplicationStatus.draft,
      ),
      filledFormData: Map<String, String>.from(json['filled_form_data'] ?? {}),
      uploadedDocumentUrls: List<String>.from(json['uploaded_document_urls'] ?? []),
      appliedAt: DateTime.parse(json['applied_at']),
      lastUpdated: json['last_updated'] != null ? DateTime.parse(json['last_updated']) : null,
      referenceNumber: json['reference_number'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scheme_id': schemeId,
      'user_id': userId,
      'status': status.toString().split('.').last,
      'filled_form_data': filledFormData,
      'uploaded_document_urls': uploadedDocumentUrls,
      'applied_at': appliedAt.toIso8601String(),
      'last_updated': lastUpdated?.toIso8601String(),
      'reference_number': referenceNumber,
      'notes': notes,
    };
  }
}

enum ApplicationStatus {
  draft,
  submitted,
  under_review,
  approved,
  rejected,
  pending_documents,
}

extension ApplicationStatusExtension on ApplicationStatus {
  String get displayName {
    switch (this) {
      case ApplicationStatus.draft:
        return 'Draft';
      case ApplicationStatus.submitted:
        return 'Submitted';
      case ApplicationStatus.under_review:
        return 'Under Review';
      case ApplicationStatus.approved:
        return 'Approved';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.pending_documents:
        return 'Pending Documents';
    }
  }

  String get displayNameHindi {
    switch (this) {
      case ApplicationStatus.draft:
        return 'मसौदा';
      case ApplicationStatus.submitted:
        return 'जमा किया गया';
      case ApplicationStatus.under_review:
        return 'समीक्षा में';
      case ApplicationStatus.approved:
        return 'स्वीकृत';
      case ApplicationStatus.rejected:
        return 'अस्वीकृत';
      case ApplicationStatus.pending_documents:
        return 'दस्तावेज लंबित';
    }
  }
}
