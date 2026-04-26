class Scheme {
  final String id;
  final Map<String, String> names; // {en, hi, mr, ta, te, kn, bn, gu, ml, or, pa}
  final Map<String, String> descriptions; // {en, hi, mr, ta, te, kn, bn, gu, ml, or, pa}
  final String category; // health, agriculture, education, housing, etc.
  final String ministry;
  final String benefitAmount; // "₹6000/year" or "Free LPG connection"
  final EligibilityCriteria eligibility;
  final List<String> requiredDocuments;
  final String applicationUrl;
  final String applicationOffice;
  final bool isActive;
  final DateTime lastUpdated;

  Scheme({
    required this.id,
    required this.names,
    required this.descriptions,
    required this.category,
    required this.ministry,
    required this.benefitAmount,
    required this.eligibility,
    required this.requiredDocuments,
    required this.applicationUrl,
    required this.applicationOffice,
    this.isActive = true,
    required this.lastUpdated,
  });

  /// Get scheme name for a specific language code
  String nameForLocale(String langCode) =>
      names[langCode] ?? names['en'] ?? '';

  /// Get scheme description for a specific language code
  String descriptionForLocale(String langCode) =>
      descriptions[langCode] ?? descriptions['en'] ?? '';

  /// Backward compatibility: get English name
  String get name => names['en'] ?? '';

  /// Backward compatibility: get Hindi name
  String get nameHindi => names['hi'] ?? '';

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      id: json['id'],
      names: {
        'en': json['name'] ?? json['name_en'] ?? '',
        'hi': json['name_hindi'] ?? json['name_hi'] ?? '',
        'mr': json['name_mr'] ?? '',
        'ta': json['name_ta'] ?? '',
        'te': json['name_te'] ?? '',
        'kn': json['name_kn'] ?? '',
        'bn': json['name_bn'] ?? '',
        'gu': json['name_gu'] ?? '',
        'ml': json['name_ml'] ?? '',
        'or': json['name_or'] ?? '',
        'pa': json['name_pa'] ?? '',
      },
      descriptions: {
        'en': json['description'] ?? json['description_en'] ?? '',
        'hi': json['description_hi'] ?? '',
        'mr': json['description_mr'] ?? '',
        'ta': json['description_ta'] ?? '',
        'te': json['description_te'] ?? '',
        'kn': json['description_kn'] ?? '',
        'bn': json['description_bn'] ?? '',
        'gu': json['description_gu'] ?? '',
        'ml': json['description_ml'] ?? '',
        'or': json['description_or'] ?? '',
        'pa': json['description_pa'] ?? '',
      },
      category: json['category'] ?? '',
      ministry: json['ministry'] ?? '',
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
      'name_en': names['en'] ?? '',
      'name_hi': names['hi'] ?? '',
      'name_mr': names['mr'] ?? '',
      'name_ta': names['ta'] ?? '',
      'name_te': names['te'] ?? '',
      'name_kn': names['kn'] ?? '',
      'name_bn': names['bn'] ?? '',
      'name_gu': names['gu'] ?? '',
      'name_ml': names['ml'] ?? '',
      'name_or': names['or'] ?? '',
      'name_pa': names['pa'] ?? '',
      'description_en': descriptions['en'] ?? '',
      'description_hi': descriptions['hi'] ?? '',
      'description_mr': descriptions['mr'] ?? '',
      'description_ta': descriptions['ta'] ?? '',
      'description_te': descriptions['te'] ?? '',
      'description_kn': descriptions['kn'] ?? '',
      'description_bn': descriptions['bn'] ?? '',
      'description_gu': descriptions['gu'] ?? '',
      'description_ml': descriptions['ml'] ?? '',
      'description_or': descriptions['or'] ?? '',
      'description_pa': descriptions['pa'] ?? '',
      'category': category,
      'ministry': ministry,
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
