import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  RealtimeChannel? _subscription;

  Future<void> initialize() async {
    debugPrint('🔔 Fake Notification Service Initialized (Windows ATL build fix)');
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    debugPrint('📢 Notification Suppressed on Windows: $title - $body');
  }

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

