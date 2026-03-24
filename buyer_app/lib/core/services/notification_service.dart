import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

/// Enhanced NotificationService — handles:
/// 1. Local notifications (in-app and when app is in foreground)
/// 2. Supabase Realtime push notifications
/// 3. Prepared for FCM integration (for outside-app notifications)
///
/// To enable TRUE outside-app notifications:
/// 1. Set up Firebase project and add google-services.json
/// 2. Add firebase_messaging package
/// 3. Configure FCM in AndroidManifest.xml
/// 4. Store FCM token in FcmToken table
/// 5. Send notifications via Supabase Edge Functions → FCM
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  RealtimeChannel? _subscription;
  FlutterLocalNotificationsPlugin? _localNotifications;
  bool _isDesktopWindows = false;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    // Check if we're on Windows desktop
    try {
      _isDesktopWindows = !kIsWeb && Platform.isWindows;
    } catch (_) {
      _isDesktopWindows = false;
    }

    if (_isDesktopWindows) {
      debugPrint('🔔 Notification Service: Windows Desktop — using console fallback');
      _initialized = true;
      return;
    }

    // Initialize real local notifications for Android/iOS
    try {
      _localNotifications = FlutterLocalNotificationsPlugin();

      // Ensure we request permissions for Android 13+
      if (!kIsWeb && Platform.isAndroid) {
        final status = await Permission.notification.request();
        debugPrint('🔔 Notification permission status: $status');
      }

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications!.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (response) {
          debugPrint('🔔 Notification tapped: ${response.payload}');
          // Handle notification tap (navigate to relevant screen)
        },
      );

      // Create high-importance Android notification channels
      final androidPlugin = _localNotifications!
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        // Main updates channel
        await androidPlugin.createNotificationChannel(const AndroidNotificationChannel(
          'projectgenie_updates',
          'Updates',
          description: 'Real-time updates for services, projects, and orders',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        ));

        // Order status channel
        await androidPlugin.createNotificationChannel(const AndroidNotificationChannel(
          'projectgenie_orders',
          'Order Updates',
          description: 'Order status changes and custom order responses',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        ));

        // Chat messages channel
        await androidPlugin.createNotificationChannel(const AndroidNotificationChannel(
          'projectgenie_chat',
          'Messages',
          description: 'Chat messages from vendors and buyers',
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        ));
      }

      debugPrint('🔔 Notification Service: Fully Initialized for Mobile!');
    } catch (e) {
      debugPrint('⚠️ Notification init error: $e');
    }

    _initialized = true;
  }

  /// Show a local notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    String channel = 'projectgenie_updates',
  }) async {
    if (_isDesktopWindows || _localNotifications == null) {
      debugPrint('📢 Notification: $title - $body');
      return;
    }

    try {
      await _localNotifications!.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel,
            channel == 'projectgenie_orders' ? 'Order Updates'
              : channel == 'projectgenie_chat' ? 'Messages'
              : 'Updates',
            channelDescription: 'ProjectGenie notifications',
            importance: Importance.max,
            priority: Priority.max,
            icon: '@mipmap/ic_launcher',
            playSound: true,
            enableVibration: true,
            showWhen: true,
            fullScreenIntent: false,
            styleInformation: BigTextStyleInformation(body),
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload,
      );
    } catch (e) {
      debugPrint('⚠️ Notification display error: $e');
    }
  }

  /// Listen for realtime notifications from Supabase
  void listenToRealtimeNotifications(String targetId) {
    if (_subscription != null) return;

    debugPrint('🔔 Listening for Push Notifications for targetId: $targetId');

    _subscription = Supabase.instance.client
        .channel('public:Notification:$targetId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'Notification',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'targetId',
            value: targetId,
          ),
          callback: (payload) {
            debugPrint('🔔 Realtime notification received: ${payload.newRecord}');
            final data = payload.newRecord;
            final type = data['type'] ?? '';
            String channel = 'projectgenie_updates';
            if (type == 'order' || type == 'custom_order') channel = 'projectgenie_orders';
            if (type == 'chat' || type == 'message') channel = 'projectgenie_chat';

            showNotification(
              title: data['title'] ?? 'New Notification',
              body: data['message'] ?? 'You have a new update.',
              payload: jsonEncode(data),
              channel: channel,
            );
          },
        )
        .subscribe();

    // Also listen for all_vendors notifications (for vendor custom order alerts)
    Supabase.instance.client
        .channel('public:Notification:all_vendors')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'Notification',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'targetId',
            value: 'all_vendors',
          ),
          callback: (payload) {
            final data = payload.newRecord;
            showNotification(
              title: data['title'] ?? 'New Request',
              body: data['message'] ?? 'A new project requirement was submitted.',
              payload: jsonEncode(data),
              channel: 'projectgenie_orders',
            );
          },
        )
        .subscribe();
  }

  /// Store FCM token in Supabase for push notifications
  Future<void> storeFcmToken(String userId, String token) async {
    try {
      await Supabase.instance.client.from('FcmToken').upsert({
        'userId': userId,
        'token': token,
        'platform': !kIsWeb && Platform.isIOS ? 'ios' : 'android',
        'updatedAt': DateTime.now().toIso8601String(),
      });
      debugPrint('🔔 FCM token stored for user: $userId');
    } catch (e) {
      debugPrint('⚠️ FCM token storage error: $e');
    }
  }

  void dispose() {
    _subscription?.unsubscribe();
    _subscription = null;
  }
}
