import '../../data/models/scheme.dart';
import '../../data/models/user_profile.dart';

class EligibilityEngine {
  /// Match user profile against schemes and return results with confidence scores
  List<SchemeMatch> matchSchemes(UserProfile profile, List<Scheme> schemes) {
    List<SchemeMatch> results = [];

    for (var scheme in schemes) {
      if (!scheme.isActive) continue;

      final matchResult = _checkEligibility(profile, scheme);
      
      if (matchResult['score'] > 0.5) {
        results.add(SchemeMatch(
          scheme: scheme,
          confidence: matchResult['score'] as double,
          reasons: List<String>.from(matchResult['reasons'] as List),
          missingDocuments: matchResult['missingDocs'] as List<String>,
          estimatedBenefit: scheme.benefitAmount,
        ));
      }
    }

    // Sort by confidence score descending
    results.sort((a, b) => b.confidence.compareTo(a.confidence));
    return results;
  }

  /// Check eligibility for a single scheme
  Map<String, dynamic> _checkEligibility(UserProfile profile, Scheme scheme) {
    final criteria = scheme.eligibility;
    double score = 1.0;
    List<String> reasons = [];
    List<String> missingDocs = [];

    // Age check
    if (criteria.minAge != null && profile.age < criteria.minAge!) {
      return {
        'score': 0.0,
        'reasons': ['Age below minimum requirement (${criteria.minAge} years)'],
        'missingDocs': <String>[],
      };
    }
    if (criteria.maxAge != null && profile.age > criteria.maxAge!) {
      return {
        'score': 0.0,
        'reasons': ['Age above maximum requirement (${criteria.maxAge} years)'],
        'missingDocs': <String>[],
      };
    }

    // Gender check
    if (criteria.genders != null && criteria.genders!.isNotEmpty) {
      if (!criteria.genders!.contains(profile.gender)) {
        return {
          'score': 0.0,
          'reasons': ['Gender not eligible for this scheme'],
          'missingDocs': <String>[],
        };
      }
    }

    // Income check
    if (criteria.maxIncome != null) {
      if (profile.annualIncome > criteria.maxIncome!) {
        return {
          'score': 0.0,
          'reasons': ['Annual income exceeds ₹${criteria.maxIncome} limit'],
          'missingDocs': <String>[],
        };
      } else {
        reasons.add('Income within eligible limit');
      }
    }

    // Caste check (not a hard disqualifier for some schemes)
    if (criteria.castes != null && criteria.castes!.isNotEmpty) {
      if (!criteria.castes!.contains(profile.caste)) {
        score *= 0.5;
        reasons.add('Caste not in priority category, may still apply');
      } else {
        reasons.add('Belongs to eligible caste category');
      }
    }

    // BPL check
    if (criteria.requiresBPL == true) {
      if (!profile.hasBPLCard) {
        score *= 0.6;
        reasons.add('BPL card recommended but may not be mandatory in all states');
      } else {
        reasons.add('Has BPL card');
      }
    }

    // Occupation check
    if (criteria.occupations != null && criteria.occupations!.isNotEmpty) {
      if (!criteria.occupations!.contains(profile.occupation)) {
        return {
          'score': 0.0,
          'reasons': ['Occupation "${profile.occupation}" not eligible for this scheme'],
          'missingDocs': <String>[],
        };
      } else {
        reasons.add('Occupation matches requirements');
      }
    }

    // Land holding check
    if (criteria.maxLandHolding != null) {
      if (profile.landHolding > criteria.maxLandHolding!) {
        return {
          'score': 0.0,
          'reasons': ['Land holding exceeds ${criteria.maxLandHolding} acres limit'],
          'missingDocs': <String>[],
        };
      } else {
        reasons.add('Land holding within eligible limit');
      }
    }

    // Special conditions
    if (criteria.specificCondition != null) {
      final condition = criteria.specificCondition!.toLowerCase();
      
      if (condition.contains('widow') && !profile.isWidow) {
        return {
          'score': 0.0,
          'reasons': ['Scheme is only for widows'],
          'missingDocs': <String>[],
        };
      }
      if (condition.contains('widow') && profile.isWidow) {
        reasons.add('Widow status confirmed');
      }

      if (condition.contains('pregnant') && !profile.isPregnant) {
        return {
          'score': 0.0,
          'reasons': ['Scheme is only for pregnant women'],
          'missingDocs': <String>[],
        };
      }
      if (condition.contains('pregnant') && profile.isPregnant) {
        reasons.add('Pregnancy status confirmed');
      }

      if (condition.contains('girl') || condition.contains('female')) {
        if (profile.gender != 'female') {
          return {
            'score': 0.0,
            'reasons': ['Scheme is only for females'],
            'missingDocs': <String>[],
          };
        } else {
          reasons.add('Female applicant');
        }
      }

      if (condition.contains('disabled') || condition.contains('divyang')) {
        if (!profile.isDisabled) {
          return {
            'score': 0.0,
            'reasons': ['Scheme is only for persons with disabilities'],
            'missingDocs': <String>[],
          };
        } else {
          reasons.add('Disability status confirmed');
        }
      }

      if (condition.contains('tb')) {
        // This would need a separate field in profile
        reasons.add('TB status verification required');
      }
    }

    // Document requirements
    if (criteria.requiresAadhar == true) {
      if (!profile.hasAadhar) {
        missingDocs.add('Aadhar Card');
        score *= 0.8;
      }
    } else {
      missingDocs.addAll(['Aadhar Card']);
    }

    if (criteria.requiresBankAccount == true) {
      if (!profile.hasBankAccount) {
        missingDocs.add('Bank Passbook');
        score *= 0.8;
      }
    } else {
      missingDocs.addAll(['Bank Passbook']);
    }

    // Add general required documents
    missingDocs.addAll(scheme.requiredDocuments);

    // Remove duplicates
    missingDocs = missingDocs.toSet().toList();

    if (score > 0.7) {
      reasons.add('Meets primary eligibility criteria');
    }

    return {
      'score': score,
      'reasons': reasons,
      'missingDocs': missingDocs,
    };
  }

  /// Extract numeric benefit amount from string like "₹6,000/year"
  double extractBenefitAmount(String benefitString) {
    // Remove currency symbols and commas, extract numbers
    final regex = RegExp(r'[\d,]+');
    final match = regex.firstMatch(benefitString);
    if (match != null) {
      final numberStr = match.group(0)!.replaceAll(',', '');
      return double.tryParse(numberStr) ?? 0.0;
    }
    return 0.0;
  }
}
