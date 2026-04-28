import '../../data/models/scheme.dart';
import '../../data/models/user_profile.dart';

class EligibilityEngine {
  /// Match user profile against schemes and return results with confidence scores
  List<SchemeMatch> matchSchemes(UserProfile profile, List<Scheme> schemes) {
    List<SchemeMatch> results = [];
    print('[EligibilityEngine] Matching profile against ${schemes.length} schemes');

    for (var scheme in schemes) {
      if (!scheme.isActive) {
        print('[EligibilityEngine] ${scheme.name}: SKIPPED (inactive)');
        continue;
      }

      final matchResult = _checkEligibility(profile, scheme);
      final score = matchResult['score'] as double;
      
      print('[EligibilityEngine] ${scheme.name}: score=${score.toStringAsFixed(2)}');
      
      if (score >= 0.5) {
        results.add(SchemeMatch(
          scheme: scheme,
          confidence: score,
          reasons: List<String>.from(matchResult['reasons'] as List),
          missingDocuments: matchResult['missingDocs'] as List<String>,
          estimatedBenefit: scheme.benefitAmount,
        ));
      }
    }

    // Sort by confidence score descending
    results.sort((a, b) => b.confidence.compareTo(a.confidence));
    print('[EligibilityEngine] Total matched: ${results.length} schemes');
    return results;
  }

  /// Check eligibility for a single scheme - handles partial/empty profile data gracefully
  Map<String, dynamic> _checkEligibility(UserProfile profile, Scheme scheme) {
    final criteria = scheme.eligibility;
    double score = 0.3; // Base score for showing scheme (was 1.0)
    List<String> reasons = [];
    List<String> missingDocs = [];
    bool hasProfileData = false;

    // Check if we have meaningful profile data
    if (profile.age > 0 || profile.gender.isNotEmpty || profile.occupation.isNotEmpty || 
        profile.caste.isNotEmpty || profile.annualIncome > 0 || profile.hasBPLCard ||
        profile.hasAadhar || profile.landHolding > 0) {
      hasProfileData = true;
      score = 0.5; // Start with neutral score when profile data exists
    }

    // Age check - only disqualify if we have age data and it's out of range
    if (criteria.minAge != null && profile.age > 0) {
      if (profile.age < criteria.minAge!) {
        return {
          'score': 0.0,
          'reasons': ['Age below minimum requirement (${criteria.minAge} years)'],
          'missingDocs': <String>[],
        };
      }
      reasons.add('Age meets minimum requirement');
      score += 0.1;
    }
    if (criteria.maxAge != null && profile.age > 0) {
      if (profile.age > criteria.maxAge!) {
        return {
          'score': 0.0,
          'reasons': ['Age above maximum requirement (${criteria.maxAge} years)'],
          'missingDocs': <String>[],
        };
      }
      reasons.add('Age within maximum limit');
      score += 0.1;
    }

    // Gender check - only disqualify if gender is specified and doesn't match
    if (criteria.genders != null && criteria.genders!.isNotEmpty && profile.gender.isNotEmpty) {
      if (!criteria.genders!.contains(profile.gender)) {
        return {
          'score': 0.0,
          'reasons': ['Gender not eligible for this scheme'],
          'missingDocs': <String>[],
        };
      }
      reasons.add('Gender matches requirement');
      score += 0.15;
    }

    // Income check - only check if we have income data
    if (criteria.maxIncome != null && profile.annualIncome > 0) {
      if (profile.annualIncome > criteria.maxIncome!) {
        return {
          'score': 0.0,
          'reasons': ['Annual income exceeds ₹${criteria.maxIncome} limit'],
          'missingDocs': <String>[],
        };
      } else {
        reasons.add('Income within eligible limit');
        score += 0.1;
      }
    }

    // Caste check (not a hard disqualifier)
    if (criteria.castes != null && criteria.castes!.isNotEmpty && profile.caste.isNotEmpty) {
      print('[EligibilityEngine] Caste check: profile=${profile.caste}, required=${criteria.castes}');
      if (!criteria.castes!.contains(profile.caste)) {
        score *= 0.7;
        reasons.add('Caste not in priority category, may still apply');
      } else {
        reasons.add('Belongs to eligible caste category');
        score += 0.1;
        print('[EligibilityEngine] Caste match! score now $score');
      }
    } else {
      print('[EligibilityEngine] Caste check skipped: criteria.castes=${criteria.castes}, profile.caste=${profile.caste}');
    }

    // BPL check
    if (criteria.requiresBPL == true) {
      if (!profile.hasBPLCard) {
        score *= 0.6;
        missingDocs.add('BPL Card');
        reasons.add('BPL card recommended');
      } else {
        reasons.add('Has BPL card');
        score += 0.15;
      }
    }

    // Occupation check - only check if occupation is specified
    if (criteria.occupations != null && criteria.occupations!.isNotEmpty && profile.occupation.isNotEmpty) {
      if (!criteria.occupations!.contains(profile.occupation)) {
        // HARD FAIL: Occupation mismatch disqualifies the scheme
        return {
          'score': 0.0,
          'reasons': ['Scheme requires one of: ${criteria.occupations!.join(", ")}, but your occupation is ${profile.occupation}'],
          'missingDocs': <String>[],
        };
      } else {
        reasons.add('Occupation matches requirements');
        score += 0.15;
      }
    }

    // Student check - for education schemes
    if (criteria.isStudent == true) {
      print('[EligibilityEngine] Student check: isStudent=${criteria.isStudent}, occupation=${profile.occupation}');
      if (profile.occupation == 'student') {
        reasons.add('Student status confirmed');
        score += 0.2;
        print('[EligibilityEngine] Student match! score now $score');
      } else if (hasProfileData) {
        // Don't disqualify, just note it
        reasons.add('Student status may be required');
        score += 0.05;
        print('[EligibilityEngine] Student partial, score now $score');
      }
    }

    // Land holding check - only if we have land data
    if (criteria.maxLandHolding != null && profile.landHolding >= 0) {
      if (profile.landHolding > criteria.maxLandHolding!) {
        return {
          'score': 0.0,
          'reasons': ['Land holding exceeds ${criteria.maxLandHolding} acres limit'],
          'missingDocs': <String>[],
        };
      } else {
        reasons.add('Land holding within eligible limit');
        score += 0.1;
      }
    }

    // Special conditions - only check if profile has relevant data
    if (criteria.specificCondition != null) {
      final condition = criteria.specificCondition!.toLowerCase();
      
      // Widow check - only if we have widow data
      if (condition.contains('widow')) {
        if (profile.isWidow) {
          reasons.add('Widow status confirmed');
          score += 0.2;
        } else if (hasProfileData) {
          // Don't disqualify, just note it
          reasons.add('Widow status may be required');
        }
      }

      // Pregnant check - only if we have pregnancy data
      if (condition.contains('pregnant')) {
        if (profile.isPregnant) {
          reasons.add('Pregnancy status confirmed');
          score += 0.2;
        } else if (hasProfileData && profile.gender == 'female') {
          reasons.add('Pregnancy status may be required');
        }
      }

      // Female/Girl check - only if gender is known
      if ((condition.contains('girl') || condition.contains('female')) && profile.gender.isNotEmpty) {
        if (profile.gender == 'female') {
          reasons.add('Female applicant');
          score += 0.15;
        } else {
          return {
            'score': 0.0,
            'reasons': ['Scheme is only for females'],
            'missingDocs': <String>[],
          };
        }
      }

      // Disabled check - only if we have disability data
      if ((condition.contains('disabled') || condition.contains('divyang'))) {
        if (profile.isDisabled) {
          reasons.add('Disability status confirmed');
          score += 0.2;
        } else if (hasProfileData) {
          reasons.add('Disability certificate may be required');
        }
      }

      if (condition.contains('tb')) {
        reasons.add('TB status verification required');
      }
    }

    // Document requirements - only penalize if explicitly required but missing
    if (criteria.requiresAadhar == true && !profile.hasAadhar) {
      missingDocs.add('Aadhar Card');
      score *= 0.8;
    }

    if (criteria.requiresBankAccount == true && !profile.hasBankAccount) {
      missingDocs.add('Bank Passbook');
      score *= 0.8;
    }

    // Add general required documents from scheme
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
