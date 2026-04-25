class Scheme {
  final String id;
  final String name;
  final String nameHindi;
  final String nameLocal; // in detected language
  final String category; // health, agriculture, education, housing, etc.
  final String ministry;
  final String description;
  final String benefitAmount; // "₹6000/year" or "Free LPG connection"
  final EligibilityCriteria eligibility;
  final List<String> requiredDocuments;
  final String applicationUrl;
  final String applicationOffice;
  final bool isActive;
  final DateTime lastUpdated;

  Scheme({
    required this.id,
    required this.name,
    required this.nameHindi,
    this.nameLocal = '',
    required this.category,
    required this.ministry,
    required this.description,
    required this.benefitAmount,
    required this.eligibility,
    required this.requiredDocuments,
    required this.applicationUrl,
    required this.applicationOffice,
    this.isActive = true,
    required this.lastUpdated,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      id: json['id'],
      name: json['name'],
      nameHindi: json['name_hindi'] ?? json['name'],
      nameLocal: json['name_local'] ?? '',
      category: json['category'],
      ministry: json['ministry'] ?? '',
      description: json['description'] ?? '',
      benefitAmount: json['benefit_amount'] ?? '',
      eligibility: EligibilityCriteria.fromJson(json['eligibility'] ?? {}),
      requiredDocuments: List<String>.from(json['required_documents'] ?? []),
      applicationUrl: json['application_url'] ?? '',
      applicationOffice: json['application_office'] ?? '',
      isActive: json['is_active'] ?? true,
      lastUpdated: json['last_updated'] != null 
          ? DateTime.parse(json['last_updated']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_hindi': nameHindi,
      'name_local': nameLocal,
      'category': category,
      'ministry': ministry,
      'description': description,
      'benefit_amount': benefitAmount,
      'eligibility': eligibility.toJson(),
      'required_documents': requiredDocuments,
      'application_url': applicationUrl,
      'application_office': applicationOffice,
      'is_active': isActive,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}

class EligibilityCriteria {
  final int? minAge;
  final int? maxAge;
  final List<String>? genders;
  final List<String>? castes;
  final double? maxIncome;
  final List<String>? occupations;
  final bool? requiresBPL;
  final bool? requiresAadhar;
  final bool? requiresBankAccount;
  final double? maxLandHolding;
  final String? specificCondition; // "must be widow" etc.
  final List<String>? statesApplicable;

  EligibilityCriteria({
    this.minAge,
    this.maxAge,
    this.genders,
    this.castes,
    this.maxIncome,
    this.occupations,
    this.requiresBPL,
    this.requiresAadhar,
    this.requiresBankAccount,
    this.maxLandHolding,
    this.specificCondition,
    this.statesApplicable,
  });

  factory EligibilityCriteria.fromJson(Map<String, dynamic> json) {
    return EligibilityCriteria(
      minAge: json['min_age'],
      maxAge: json['max_age'],
      genders: json['genders'] != null ? List<String>.from(json['genders']) : null,
      castes: json['castes'] != null ? List<String>.from(json['castes']) : null,
      maxIncome: json['max_income']?.toDouble(),
      occupations: json['occupations'] != null ? List<String>.from(json['occupations']) : null,
      requiresBPL: json['requires_bpl'],
      requiresAadhar: json['requires_aadhar'],
      requiresBankAccount: json['requires_bank_account'],
      maxLandHolding: json['max_land_holding']?.toDouble(),
      specificCondition: json['specific_condition'],
      statesApplicable: json['states_applicable'] != null ? List<String>.from(json['states_applicable']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min_age': minAge,
      'max_age': maxAge,
      'genders': genders,
      'castes': castes,
      'max_income': maxIncome,
      'occupations': occupations,
      'requires_bpl': requiresBPL,
      'requires_aadhar': requiresAadhar,
      'requires_bank_account': requiresBankAccount,
      'max_land_holding': maxLandHolding,
      'specific_condition': specificCondition,
      'states_applicable': statesApplicable,
    };
  }
}

class SchemeMatch {
  final Scheme scheme;
  final double confidence;
  final List<String> reasons;
  final List<String> missingDocuments;
  final String estimatedBenefit;

  SchemeMatch({
    required this.scheme,
    required this.confidence,
    required this.reasons,
    required this.missingDocuments,
    required this.estimatedBenefit,
  });
}
