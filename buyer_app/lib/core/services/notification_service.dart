import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  RealtimeChannel? _subscription;

  Future<void> initialize() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint('Notification clicked: ${response.payload}');
      },
    );

    // Request permissions for Android 13+
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'projectgenie_channel',
          'ProjectGenie Notifications',
          channelDescription: 'Important updates and alerts from ProjectGenie',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // unique id safely
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  // Set up real-time listener to Supabase Notification table
  // This executes when the user successfully logs in
  void listenToRealtimeNotifications(String targetId) {
    if (_subscription != null) return;

    debugPrint('🔔 Listening for Push Notifications for targetId: $targetId');

    _subscription = Supabase.instance.client
        .channel('public:Notification')
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
            debugPrint(
              '🔔 Realtime push notification received: ${payload.newRecord}',
            );
            final data = payload.newRecord;
            showNotification(
              title: data['title'] ?? 'New Notification',
              body: data['message'] ?? 'You have a new update.',
              payload: jsonEncode(data),
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
