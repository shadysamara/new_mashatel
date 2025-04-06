import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

/// Handles Firebase Cloud Messaging and local notifications
class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Dependencies
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  // Notification channel configuration
  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'High Importance Notifications';
  static const String _channelDescription = 'Important notifications';

  StreamSubscription? _tokenRefreshSubscription;

  /// Initialize the notification service
  Future<void> initialize() async {
    try {
      // Request permission
      await _requestPermissions();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Configure Firebase messaging handlers
      await _setupFirebaseMessaging();

      _logger.i('Notification service initialized successfully');
    } catch (e) {
      _logger.e('Failed to initialize notification service: $e');
      rethrow;
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } else {
      // Android handles permissions through manifest/channel
      await _firebaseMessaging.requestPermission();
    }
  }

  /// Initialize local notification plugin
  Future<void> _initializeLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onSelectNotification,
    );

    // Create Android notification channel
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.max,
      );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  /// Configure Firebase messaging handlers
  Future<void> _setupFirebaseMessaging() async {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle app opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpened);

    // Handle token refresh
    _tokenRefreshSubscription =
        _firebaseMessaging.onTokenRefresh.listen((token) {});
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    _logger.i('Foreground message received: ${message.messageId}');
    _showNotification(message);
  }

  /// Handle when app is opened from notification
  void _handleMessageOpened(RemoteMessage message) {
    _logger.i('App opened from notification: ${message.messageId}');
    // Add your navigation logic here
  }

  /// Background message handler (must be top-level or static)
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    Logger().i('Background message received: ${message.messageId}');
    // Note: Local notifications won't show in background handler
    // Handle data processing here if needed
  }

  /// Show local notification
  Future<void> _showNotification(RemoteMessage message) async {
    try {
      final notification = message.notification;
      if (notification == null) return;

      final androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platformDetails,
        payload: message.data.toString(),
      );
    } catch (e) {
      _logger.e('Failed to show notification: $e');
    }
  }

  /// Handle notification tap
  void _onSelectNotification(NotificationResponse response) {
    _logger.i('Notification tapped with payload: ${response.payload}');
    // Add your navigation logic here
  }

  /// Save device token to Firestore
  Future<void> saveDeviceToken(String userId) async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token == null) return;

      await _saveDeviceToken(token, userId);
    } catch (e) {
      _logger.e('Failed to save device token: $e');
    }
  }

  Future<void> _saveDeviceToken(String token, String userId) async {
    final tokenRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('tokens')
        .doc(token);

    await tokenRef.set({
      'token': token,
      'createdAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Delete device token
  Future<void> deleteDeviceToken(String userId) async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token == null) return;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('tokens')
          .doc(token)
          .delete();
    } catch (e) {
      _logger.e('Failed to delete device token: $e');
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      _logger.i('Subscribed to topic: $topic');
    } catch (e) {
      _logger.e('Failed to subscribe to topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      _logger.i('Unsubscribed from topic: $topic');
    } catch (e) {
      _logger.e('Failed to unsubscribe from topic: $e');
    }
  }

  /// Cleanup resources
  void dispose() {
    _tokenRefreshSubscription?.cancel();
  }
}
