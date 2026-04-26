import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import '../local/schemes_database.dart';
import '../models/scheme.dart';
import '../remote/firebase_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/constants/hive_boxes.dart';

/// Repository for managing scheme data with offline support
/// Falls back to Hive local storage when Firestore is unavailable
class SchemeRepository {
  final FirebaseService _firebaseService;
  final ConnectivityService _connectivityService;
  late Box _schemesBox;

  SchemeRepository({
    FirebaseService? firebaseService,
    ConnectivityService? connectivityService,
  })  : _firebaseService = firebaseService ?? FirebaseService(),
        _connectivityService = connectivityService ?? ConnectivityService();

  /// Initialize repository and Hive box
  Future<void> init() async {
    _schemesBox = await Hive.openBox(HiveBoxes.kSchemesBox);
  }

  /// Get all schemes
  /// Tries Firestore first, falls back to Hive if offline
  Future<List<Scheme>> getAllSchemes() async {
    try {
      final hasInternet = await _connectivityService.hasInternet();
      
      if (hasInternet) {
        // Try to fetch from Firestore
        final schemesData = await _firebaseService.getCachedSchemes();
        final schemes = schemesData.map((e) => Scheme.fromJson(e)).toList();
        
        // Cache to Hive for offline use
        await _cacheToHive(schemes);
        
        return schemes;
      } else {
        // Fall back to Hive cache
        return _getFromHive();
      }
    } catch (e) {
      // If Firestore fails, fall back to Hive
      try {
        return _getFromHive();
      } catch (hiveError) {
        // If Hive also fails, return from static database
        final schemesData = SchemesDatabase.getAllSchemes();
        return schemesData.map((e) => Scheme.fromJson(e)).toList();
      }
    }
  }

  /// Get scheme by ID
  Future<Scheme?> getSchemeById(String schemeId) async {
    try {
      final hasInternet = await _connectivityService.hasInternet();
      
      if (hasInternet) {
        final schemeData = await _firebaseService.getScheme(schemeId);
        if (schemeData != null) {
          final scheme = Scheme.fromJson(schemeData);
          // Update Hive cache
          await _schemesBox.put(schemeId, scheme.toJson());
          return scheme;
        }
      }
      
      // Fall back to Hive
      return _getFromHiveById(schemeId);
    } catch (e) {
      return _getFromHiveById(schemeId);
    }
  }

  /// Get schemes by category
  Future<List<Scheme>> getSchemesByCategory(String category) async {
    final allSchemes = await getAllSchemes();
    return allSchemes.where((s) => s.category == category).toList();
  }

  /// Search schemes by query
  Future<List<Scheme>> searchSchemes(String query, String langCode) async {
    final allSchemes = await getAllSchemes();
    final lowerQuery = query.toLowerCase();
    
    return allSchemes.where((scheme) {
      final name = scheme.nameForLocale(langCode).toLowerCase();
      final description = scheme.descriptionForLocale(langCode).toLowerCase();
      return name.contains(lowerQuery) || description.contains(lowerQuery);
    }).toList();
  }

  /// Refresh schemes from Firestore and update Hive cache
  Future<void> refreshSchemes() async {
    try {
      final hasInternet = await _connectivityService.hasInternet();
      if (!hasInternet) {
        throw Exception('No internet connection');
      }

      final schemesData = await _firebaseService.getCachedSchemes();
      final schemes = schemesData.map((e) => Scheme.fromJson(e)).toList();
      await _cacheToHive(schemes);
    } catch (e) {
      throw Exception('Failed to refresh schemes: $e');
    }
  }

  /// Clear Hive cache
  Future<void> clearCache() async {
    await _schemesBox.clear();
  }

  /// Get cache size in bytes
  int get cacheSize => _schemesBox.length;

  // ==================== PRIVATE METHODS ====================

  /// Cache schemes to Hive
  Future<void> _cacheToHive(List<Scheme> schemes) async {
    try {
      for (final scheme in schemes) {
        await _schemesBox.put(scheme.id, scheme.toJson());
      }
    } catch (e) {
      // Silently fail caching, don't throw
      print('Failed to cache schemes to Hive: $e');
    }
  }

  /// Get all schemes from Hive cache
  List<Scheme> _getFromHive() {
    final schemes = <Scheme>[];
    for (final key in _schemesBox.keys) {
      try {
        final data = _schemesBox.get(key) as Map<String, dynamic>;
        schemes.add(Scheme.fromJson(data));
      } catch (e) {
        print('Failed to parse scheme from Hive: $e');
      }
    }
    return schemes;
  }

  /// Get specific scheme from Hive cache
  Scheme? _getFromHiveById(String schemeId) {
    try {
      final data = _schemesBox.get(schemeId) as Map<String, dynamic>?;
      if (data != null) {
        return Scheme.fromJson(data);
      }
    } catch (e) {
      print('Failed to get scheme from Hive: $e');
    }
    return null;
  }
}
