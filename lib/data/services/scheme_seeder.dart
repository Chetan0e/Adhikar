import 'package:cloud_firestore/cloud_firestore.dart';
import '../local/schemes_database.dart';
import '../models/scheme.dart';

/// Service to seed Firestore with initial scheme data from local database
class SchemeSeeder {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Seed all schemes from SchemesDatabase to Firestore
  /// This should be run once when the app is first deployed or when schemes need updating
  Future<SeedingResult> seedSchemes({
    bool overwriteExisting = false,
    Function(int current, int total)? onProgress,
  }) async {
    final schemes = SchemesDatabase.getAllSchemes();
    final total = schemes.length;
    int successCount = 0;
    int skippedCount = 0;
    int errorCount = 0;
    final List<String> errors = [];

    for (int i = 0; i < schemes.length; i++) {
      try {
        final schemeData = schemes[i];
        final schemeId = schemeData['id'] as String;

        // Check if scheme already exists
        final existingDoc = await _firestore.collection('schemes').doc(schemeId).get();
        
        if (existingDoc.exists && !overwriteExisting) {
          skippedCount++;
          onProgress?.call(i + 1, total);
          continue;
        }

        // Convert old format to new multilingual format
        final convertedData = _convertToMultilingualFormat(schemeData);

        // Save to Firestore
        await _firestore
            .collection('schemes')
            .doc(schemeId)
            .set(convertedData, SetOptions(merge: true));

        successCount++;
      } catch (e) {
        errorCount++;
        errors.add('Error seeding scheme ${schemes[i]['id']}: $e');
      }

      onProgress?.call(i + 1, total);
    }

    return SeedingResult(
      total: total,
      success: successCount,
      skipped: skippedCount,
      errors: errors,
    );
  }

  /// Convert old scheme format to new multilingual format
  Map<String, dynamic> _convertToMultilingualFormat(Map<String, dynamic> oldData) {
    final name = oldData['name'] as String;
    final nameHindi = oldData['name_hindi'] as String? ?? '';
    final description = oldData['description'] as String;

    return {
      'id': oldData['id'],
      'name_en': name,
      'name_hi': nameHindi,
      'name_mr': '', // TODO: Add Marathi translations
      'name_ta': '', // TODO: Add Tamil translations
      'name_te': '', // TODO: Add Telugu translations
      'name_kn': '', // TODO: Add Kannada translations
      'name_bn': '', // TODO: Add Bengali translations
      'name_gu': '', // TODO: Add Gujarati translations
      'name_ml': '', // TODO: Add Malayalam translations
      'name_or': '', // TODO: Add Odia translations
      'name_pa': '', // TODO: Add Punjabi translations
      'description_en': description,
      'description_hi': description, // TODO: Add Hindi translations
      'description_mr': '', // TODO: Add Marathi translations
      'description_ta': '', // TODO: Add Tamil translations
      'description_te': '', // TODO: Add Telugu translations
      'description_kn': '', // TODO: Add Kannada translations
      'description_bn': '', // TODO: Add Bengali translations
      'description_gu': '', // TODO: Add Gujarati translations
      'description_ml': '', // TODO: Add Malayalam translations
      'description_or': '', // TODO: Add Odia translations
      'description_pa': '', // TODO: Add Punjabi translations
      'category': oldData['category'],
      'ministry': oldData['ministry'],
      'benefit_amount': oldData['benefit_amount'],
      'eligibility': oldData['eligibility'],
      'required_documents': oldData['required_documents'],
      'application_url': oldData['application_url'],
      'application_office': oldData['application_office'],
      'is_active': oldData['is_active'] ?? true,
      'last_updated': oldData['last_updated'] ?? DateTime.now().toIso8601String(),
    };
  }

  /// Clear all schemes from Firestore (use with caution)
  Future<void> clearAllSchemes() async {
    final querySnapshot = await _firestore.collection('schemes').get();
    final batch = _firestore.batch();
    
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    
    await batch.commit();
  }

  /// Check if schemes collection is empty
  Future<bool> isSchemesCollectionEmpty() async {
    final snapshot = await _firestore.collection('schemes').limit(1).get();
    return snapshot.docs.isEmpty;
  }
}

class SeedingResult {
  final int total;
  final int success;
  final int skipped;
  final List<String> errors;

  SeedingResult({
    required this.total,
    required this.success,
    required this.skipped,
    required this.errors,
  });

  bool get hasErrors => errors.isNotEmpty;

  @override
  String toString() {
    return 'SeedingResult(total: $total, success: $success, skipped: $skipped, errors: ${errors.length})';
  }
}
