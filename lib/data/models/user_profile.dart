class UserProfile {
  final String id;
  final String name;
  final int age;
  final String gender; // male, female, other
  final String state;
  final String district;
  final String caste; // general, obc, sc, st
  final String occupation; // farmer, daily_wage, unemployed, etc.
  final double annualIncome; // in rupees
  final double landHolding; // in acres (0 if landless)
  final bool isDisabled;
  final bool isWidow;
  final bool hasBPLCard;
  final bool hasAadhar;
  final bool hasBankAccount;
  final int familySize;
  final List<String> childrenAges;
  final bool isPregnant;
  final String educationLevel; // illiterate, primary, secondary, graduate
  final DateTime createdAt;
  final bool isSyncedToCloud;
  final double confidence; // AI confidence score
  final List<String> missingInfo; // Info AI couldn't extract

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.state,
    required this.district,
    required this.caste,
    required this.occupation,
    required this.annualIncome,
    required this.landHolding,
    required this.isDisabled,
    required this.isWidow,
    required this.hasBPLCard,
    required this.hasAadhar,
    required this.hasBankAccount,
    required this.familySize,
    required this.childrenAges,
    required this.isPregnant,
    required this.educationLevel,
    required this.createdAt,
    this.isSyncedToCloud = false,
    this.confidence = 0.0,
    this.missingInfo = const [],
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      caste: json['caste'] ?? '',
      occupation: json['occupation'] ?? '',
      annualIncome: (json['annual_income'] ?? 0).toDouble(),
      landHolding: (json['land_holding'] ?? 0).toDouble(),
      isDisabled: json['is_disabled'] ?? false,
      isWidow: json['is_widow'] ?? false,
      hasBPLCard: json['has_bpl_card'] ?? false,
      hasAadhar: json['has_aadhar'] ?? false,
      hasBankAccount: json['has_bank_account'] ?? false,
      familySize: json['family_size'] ?? 0,
      childrenAges: List<String>.from(json['children_ages'] ?? []),
      isPregnant: json['is_pregnant'] ?? false,
      educationLevel: json['education_level'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      isSyncedToCloud: json['is_synced_to_cloud'] ?? false,
      confidence: (json['confidence'] ?? 0).toDouble(),
      missingInfo: List<String>.from(json['missing_info'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'state': state,
      'district': district,
      'caste': caste,
      'occupation': occupation,
      'annual_income': annualIncome,
      'land_holding': landHolding,
      'is_disabled': isDisabled,
      'is_widow': isWidow,
      'has_bpl_card': hasBPLCard,
      'has_aadhar': hasAadhar,
      'has_bank_account': hasBankAccount,
      'family_size': familySize,
      'children_ages': childrenAges,
      'is_pregnant': isPregnant,
      'education_level': educationLevel,
      'created_at': createdAt.toIso8601String(),
      'is_synced_to_cloud': isSyncedToCloud,
      'confidence': confidence,
      'missing_info': missingInfo,
    };
  }

  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? state,
    String? district,
    String? caste,
    String? occupation,
    double? annualIncome,
    double? landHolding,
    bool? isDisabled,
    bool? isWidow,
    bool? hasBPLCard,
    bool? hasAadhar,
    bool? hasBankAccount,
    int? familySize,
    List<String>? childrenAges,
    bool? isPregnant,
    String? educationLevel,
    DateTime? createdAt,
    bool? isSyncedToCloud,
    double? confidence,
    List<String>? missingInfo,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      state: state ?? this.state,
      district: district ?? this.district,
      caste: caste ?? this.caste,
      occupation: occupation ?? this.occupation,
      annualIncome: annualIncome ?? this.annualIncome,
      landHolding: landHolding ?? this.landHolding,
      isDisabled: isDisabled ?? this.isDisabled,
      isWidow: isWidow ?? this.isWidow,
      hasBPLCard: hasBPLCard ?? this.hasBPLCard,
      hasAadhar: hasAadhar ?? this.hasAadhar,
      hasBankAccount: hasBankAccount ?? this.hasBankAccount,
      familySize: familySize ?? this.familySize,
      childrenAges: childrenAges ?? this.childrenAges,
      isPregnant: isPregnant ?? this.isPregnant,
      educationLevel: educationLevel ?? this.educationLevel,
      createdAt: createdAt ?? this.createdAt,
      isSyncedToCloud: isSyncedToCloud ?? this.isSyncedToCloud,
      confidence: confidence ?? this.confidence,
      missingInfo: missingInfo ?? this.missingInfo,
    );
  }
}
