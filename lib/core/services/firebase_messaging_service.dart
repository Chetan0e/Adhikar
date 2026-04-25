import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

// Note: flutter_local_notifications is not currently in pubspec.yaml.
// Until added, local notification display is disabled. FCM token and
// background message handling still works.

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Initialize Firebase Messaging
  Future<void> initialize() async {
    await _requestPermission();

    final token = await _messaging.getToken();
    debugPrint('FCM Token: $token');

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessageOpened);
  }

  /// Request notification permission
  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('Notification permission: ${settings.authorizationStatus}');
  }

  /// Handle foreground messages (local notification display disabled until
  /// flutter_local_notifications is added to pubspec.yaml)
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message: ${message.notification?.title}');
    // TODO: Show local notification using flutter_local_notifications
  }

  /// Handle background message opened
  void _handleBackgroundMessageOpened(RemoteMessage message) {
    debugPrint('Background message opened: ${message.messageId}');
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}
