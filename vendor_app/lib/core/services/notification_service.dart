import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

/// Enhanced NotificationService for Vendor App
/// Same robust structure as buyer app, with vendor-specific channels.
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

    try {
      _isDesktopWindows = !kIsWeb && Platform.isWindows;
    } catch (_) {
      _isDesktopWindows = false;
    }

    if (_isDesktopWindows) {
      debugPrint('🔔 Vendor Notification Service: Windows Desktop — console fallback');
      _initialized = true;
      return;
    }

    try {
      _localNotifications = FlutterLocalNotificationsPlugin();

      if (!kIsWeb && Platform.isAndroid) {
        await Permission.notification.request();
      }

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      await _localNotifications!.initialize(
        const InitializationSettings(android: androidSettings, iOS: iosSettings),
        onDidReceiveNotificationResponse: (response) {
          debugPrint('🔔 Vendor Notification tapped: ${response.payload}');
        },
      );

      final androidPlugin = _localNotifications!
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(const AndroidNotificationChannel(
          'vendor_orders', 'Order Alerts',
          description: 'New order and custom request notifications',
          importance: Importance.max, playSound: true, enableVibration: true, showBadge: true,
        ));
        await androidPlugin.createNotificationChannel(const AndroidNotificationChannel(
          'vendor_messages', 'Chat Messages',
          description: 'Messages from buyers',
          importance: Importance.high, playSound: true, enableVibration: true, showBadge: true,
        ));
        await androidPlugin.createNotificationChannel(const AndroidNotificationChannel(
          'vendor_updates', 'Platform Updates',
          description: 'General platform notifications',
          importance: Importance.high, playSound: true, showBadge: true,
        ));
      }

      debugPrint('🔔 Vendor Notification Service: Initialized!');
    } catch (e) {
      debugPrint('⚠️ Vendor Notification init error: $e');
    }

    _initialized = true;
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    String channel = 'vendor_updates',
  }) async {
    if (_isDesktopWindows || _localNotifications == null) {
      debugPrint('📢 Vendor Notification: $title - $body');
      return;
    }

    try {
      await _localNotifications!.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title, body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel,
            channel == 'vendor_orders' ? 'Order Alerts'
              : channel == 'vendor_messages' ? 'Chat Messages'
              : 'Platform Updates',
            importance: Importance.max, priority: Priority.max,
            icon: '@mipmap/ic_launcher', playSound: true, enableVibration: true,
            styleInformation: BigTextStyleInformation(body),
          ),
          iOS: const DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
        ),
        payload: payload,
      );
    } catch (e) {
      debugPrint('⚠️ Vendor Notification display error: $e');
    }
  }

  void listenToRealtimeNotifications(String vendorId) {
    if (_subscription != null) return;

    debugPrint('🔔 Vendor Listening for notifications: $vendorId');

    _subscription = Supabase.instance.client
        .channel('vendor:Notification:$vendorId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'Notification',
          filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'targetId', value: vendorId),
          callback: (payload) {
            final data = payload.newRecord;
            final type = data['type'] ?? '';
            String channel = 'vendor_updates';
            if (type == 'order' || type == 'custom_order') channel = 'vendor_orders';
            if (type == 'chat' || type == 'message') channel = 'vendor_messages';

            showNotification(
              title: data['title'] ?? 'New Notification',
              body: data['message'] ?? 'You have a new update.',
              payload: jsonEncode(data),
              channel: channel,
            );
          },
        )
        .subscribe();

    // Listen for broadcast notifications to all vendors
    Supabase.instance.client
        .channel('vendor:Notification:all_vendors')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'Notification',
          filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'targetId', value: 'all_vendors'),
          callback: (payload) {
            final data = payload.newRecord;
            showNotification(
              title: data['title'] ?? 'New Request',
              body: data['message'] ?? 'A new project requirement was submitted.',
              payload: jsonEncode(data),
              channel: 'vendor_orders',
            );
          },
        )
        .subscribe();
  }

  void dispose() {
    _subscription?.unsubscribe();
    _subscription = null;
  }
}
