import 'package:hive_flutter/hive_flutter.dart';
import '../constants/hive_boxes.dart';

enum SyncTaskType {
  profileUpdate,
  applicationSubmit,
  documentUpload,
  schemeUpdate,
}

class SyncTask {
  final String id;
  final SyncTaskType type;
  final Map<String, dynamic> payload;
  final int retryCount;
  final DateTime queuedAt;
  final DateTime? lastAttemptAt;
  final String? errorMessage;

  SyncTask({
    required this.id,
    required this.type,
    required this.payload,
    this.retryCount = 0,
    required this.queuedAt,
    this.lastAttemptAt,
    this.errorMessage,
  });

  factory SyncTask.fromJson(Map<String, dynamic> json) {
    return SyncTask(
      id: json['id'],
      type: SyncTaskType.values.firstWhere(
        (e) => e.toString() == 'SyncTaskType.${json['type']}',
        orElse: () => SyncTaskType.profileUpdate,
      ),
      payload: Map<String, dynamic>.from(json['payload'] ?? {}),
      retryCount: json['retry_count'] ?? 0,
      queuedAt: DateTime.parse(json['queued_at']),
      lastAttemptAt: json['last_attempt_at'] != null 
          ? DateTime.parse(json['last_attempt_at']) 
          : null,
      errorMessage: json['error_message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'payload': payload,
      'retry_count': retryCount,
      'queued_at': queuedAt.toIso8601String(),
      'last_attempt_at': lastAttemptAt?.toIso8601String(),
      'error_message': errorMessage,
    };
  }
}

class OfflineQueueService {
  late Box _queueBox;

  /// Initialize the offline queue
  Future<void> init() async {
    _queueBox = await Hive.openBox(HiveBoxes.kSyncQueueBox);
  }

  /// Add a task to the sync queue
  Future<void> addTask(SyncTask task) async {
    await _queueBox.put(task.id, task.toJson());
  }

  /// Get all pending tasks
  Future<List<SyncTask>> getPendingTasks() async {
    final tasks = <SyncTask>[];
    for (var key in _queueBox.keys) {
      final taskJson = _queueBox.get(key) as Map<String, dynamic>;
      tasks.add(SyncTask.fromJson(taskJson));
    }
    // Sort by queued time
    tasks.sort((a, b) => a.queuedAt.compareTo(b.queuedAt));
    return tasks;
  }

  /// Get task by ID
  SyncTask? getTask(String taskId) {
    final taskJson = _queueBox.get(taskId);
    if (taskJson != null) {
      return SyncTask.fromJson(taskJson);
    }
    return null;
  }

  /// Update task (after retry attempt)
  Future<void> updateTask(SyncTask task) async {
    await _queueBox.put(task.id, task.toJson());
  }

  /// Remove task from queue (after successful sync)
  Future<void> removeTask(String taskId) async {
    await _queueBox.delete(taskId);
  }

  /// Clear all tasks
  Future<void> clearQueue() async {
    await _queueBox.clear();
  }

  /// Get queue size
  int get queueSize => _queueBox.length;

  /// Add profile update task
  Future<void> queueProfileUpdate(String userId, Map<String, dynamic> profileData) async {
    final task = SyncTask(
      id: 'profile_${DateTime.now().millisecondsSinceEpoch}',
      type: SyncTaskType.profileUpdate,
      payload: {
        'user_id': userId,
        'profile_data': profileData,
      },
      queuedAt: DateTime.now(),
    );
    await addTask(task);
  }

  /// Add application submission task
  Future<void> queueApplicationSubmit(Map<String, dynamic> applicationData) async {
    final task = SyncTask(
      id: 'application_${DateTime.now().millisecondsSinceEpoch}',
      type: SyncTaskType.applicationSubmit,
      payload: applicationData,
      queuedAt: DateTime.now(),
    );
    await addTask(task);
  }

  /// Add document upload task
  Future<void> queueDocumentUpload(String applicationId, String documentPath) async {
    final task = SyncTask(
      id: 'document_${DateTime.now().millisecondsSinceEpoch}',
      type: SyncTaskType.documentUpload,
      payload: {
        'application_id': applicationId,
        'document_path': documentPath,
      },
      queuedAt: DateTime.now(),
    );
    await addTask(task);
  }
}
