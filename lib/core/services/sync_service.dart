import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'offline_queue_service.dart';
import 'connectivity_service.dart';

class SyncService {
  final OfflineQueueService _queueService = OfflineQueueService();
  final ConnectivityService _connectivityService = ConnectivityService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isSyncing = false;
  int _maxRetries = 3;

  /// Initialize sync service
  Future<void> init() async {
    await _queueService.init();
  }

  /// Start automatic sync when connectivity changes
  void startAutoSync() {
    _connectivityService.onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        await syncPendingTasks();
      }
    });
  }

  /// Manually trigger sync
  Future<SyncResult> syncPendingTasks() async {
    if (_isSyncing) {
      return SyncResult(success: false, message: 'Sync already in progress');
    }

    if (!await _connectivityService.isOnline()) {
      return SyncResult(success: false, message: 'No internet connection');
    }

    _isSyncing = true;
    int successCount = 0;
    int failureCount = 0;

    try {
      final tasks = await _queueService.getPendingTasks();
      
      for (var task in tasks) {
        if (task.retryCount >= _maxRetries) {
          // Skip tasks that have exceeded max retries
          failureCount++;
          continue;
        }

        final result = await _syncTask(task);
        if (result.success) {
          await _queueService.removeTask(task.id);
          successCount++;
        } else {
          // Update task with error and increment retry count
          final updatedTask = SyncTask(
            id: task.id,
            type: task.type,
            payload: task.payload,
            retryCount: task.retryCount + 1,
            queuedAt: task.queuedAt,
            lastAttemptAt: DateTime.now(),
            errorMessage: result.message,
          );
          await _queueService.updateTask(updatedTask);
          failureCount++;
        }
      }

      _isSyncing = false;
      return SyncResult(
        success: true,
        message: 'Synced $successCount tasks, $failureCount failed',
      );
    } catch (e) {
      _isSyncing = false;
      return SyncResult(success: false, message: 'Sync error: $e');
    }
  }

  /// Sync a single task
  Future<SyncResult> _syncTask(SyncTask task) async {
    try {
      switch (task.type) {
        case SyncTaskType.profileUpdate:
          return await _syncProfile(task.payload);
        case SyncTaskType.applicationSubmit:
          return await _syncApplication(task.payload);
        case SyncTaskType.documentUpload:
          return await _syncDocument(task.payload);
        case SyncTaskType.schemeUpdate:
          return await _syncScheme(task.payload);
      }
    } catch (e) {
      return SyncResult(success: false, message: e.toString());
    }
  }

  /// Sync profile to Firestore
  Future<SyncResult> _syncProfile(Map<String, dynamic> payload) async {
    try {
      final userId = payload['user_id'] as String;
      final profileData = payload['profile_data'] as Map<String, dynamic>;

      await _firestore
          .collection('users')
          .doc(userId)
          .set(profileData, SetOptions(merge: true));

      return SyncResult(success: true, message: 'Profile synced');
    } catch (e) {
      return SyncResult(success: false, message: 'Profile sync failed: $e');
    }
  }

  /// Sync application to Firestore
  Future<SyncResult> _syncApplication(Map<String, dynamic> payload) async {
    try {
      await _firestore.collection('applications').add(payload);

      return SyncResult(success: true, message: 'Application synced');
    } catch (e) {
      return SyncResult(success: false, message: 'Application sync failed: $e');
    }
  }

  /// Sync document to Firebase Storage
  Future<SyncResult> _syncDocument(Map<String, dynamic> payload) async {
    try {
      final userId = payload['user_id'] as String;
      final filePath = payload['file_path'] as String;
      final fileName = payload['file_name'] as String;
      final documentType = payload['document_type'] as String;
      
      final file = File(filePath);
      if (!await file.exists()) {
        return SyncResult(success: false, message: 'File not found locally');
      }

      // Upload to Firebase Storage
      final ref = FirebaseStorage.instance.ref().child('users/$userId/$fileName');
      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();

      // Update Firestore with the document link
      await _firestore.collection('users').doc(userId).collection('documents').doc(documentType).set({
        'url': downloadUrl,
        'uploaded_at': FieldValue.serverTimestamp(),
        'name': fileName,
      });

      return SyncResult(success: true, message: 'Document synced successfully');
    } catch (e) {
      return SyncResult(success: false, message: 'Document sync failed: $e');
    }
  }

  /// Sync scheme update (for local cache refresh)
  Future<SyncResult> _syncScheme(Map<String, dynamic> payload) async {
    try {
      // Fetch latest schemes from Firestore and update local cache (Hive)
      final snapshot = await _firestore.collection('schemes').where('is_active', isEqualTo: true).get();
      // Assume local scheme database handling here
      // For now, we just acknowledge the successful fetch
      return SyncResult(success: true, message: 'Schemes synced: ${snapshot.docs.length} found');
    } catch (e) {
      return SyncResult(success: false, message: 'Scheme sync failed: $e');
    }
  }

  /// Get sync status
  bool get isSyncing => _isSyncing;

  /// Get pending task count
  Future<int> get pendingTaskCount async {
    return _queueService.queueSize;
  }
}

class SyncResult {
  final bool success;
  final String message;

  SyncResult({required this.success, required this.message});
}
