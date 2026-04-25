import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_profile.dart';
import '../models/application.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ==================== USER PROFILE ====================

  /// Save user profile
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(profile.id)
          .set(profile.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save user profile: $e');
    }
  }

  /// Get user profile
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserProfile.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  // ==================== APPLICATIONS ====================

  /// Submit application
  Future<void> submitApplication(Application application) async {
    try {
      await _firestore
          .collection('applications')
          .doc(application.id)
          .set(application.toJson());
    } catch (e) {
      throw Exception('Failed to submit application: $e');
    }
  }

  /// Get user's applications
  Future<List<Application>> getUserApplications(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('applications')
          .where('user_id', isEqualTo: userId)
          .orderBy('applied_at', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Application.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user applications: $e');
    }
  }

  /// Get application by ID
  Future<Application?> getApplication(String applicationId) async {
    try {
      final doc = await _firestore
          .collection('applications')
          .doc(applicationId)
          .get();
      if (doc.exists) {
        return Application.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get application: $e');
    }
  }

  // ==================== SCHEMES (Cache) ====================

  /// Get cached schemes
  Future<List<Map<String, dynamic>>> getCachedSchemes() async {
    try {
      final querySnapshot = await _firestore.collection('schemes').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to get cached schemes: $e');
    }
  }

  /// Cache schemes locally in Firestore
  Future<void> cacheSchemes(List<Map<String, dynamic>> schemes) async {
    try {
      final batch = _firestore.batch();
      for (var scheme in schemes) {
        final docRef = _firestore.collection('schemes').doc(scheme['id']);
        batch.set(docRef, scheme);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to cache schemes: $e');
    }
  }

  /// Get scheme by ID
  Future<Map<String, dynamic>?> getScheme(String schemeId) async {
    try {
      final doc = await _firestore.collection('schemes').doc(schemeId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get scheme: $e');
    }
  }

  // ==================== DOCUMENTS ====================

  /// Upload document to Firebase Storage
  Future<String> uploadDocument(String userId, String filePath, String fileName) async {
    try {
      final file = File(filePath);
      final ref = _storage.ref().child('users/$userId/$fileName');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  /// Delete document from Storage
  Future<void> deleteDocument(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  // ==================== AUTHENTICATION ====================

  /// Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  /// Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Stream auth changes
  Stream<User?> get authChanges => _auth.authStateChanges();

  // ==================== SYNC LOGS ====================

  /// Update sync log
  Future<void> updateSyncLog(String userId, {int? pendingItems}) async {
    try {
      await _firestore.collection('sync_logs').doc(userId).set({
        'last_synced': DateTime.now().toIso8601String(),
        'pending_items': pendingItems ?? 0,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to update sync log: $e');
    }
  }

  /// Get sync log
  Future<Map<String, dynamic>?> getSyncLog(String userId) async {
    try {
      final doc = await _firestore.collection('sync_logs').doc(userId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get sync log: $e');
    }
  }

  /// Save FCM token
  Future<void> saveFCMToken(String userId, String token) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'fcm_token': token,
        'token_updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save FCM token: $e');
    }
  }
}
