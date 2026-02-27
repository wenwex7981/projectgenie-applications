import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/data/mock_data.dart'; // Import mock data for potential reuse or new mock data

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Notifications Data
    final notifications = [
      {'title': 'Order Placed Successfully', 'body': 'Your order #PG-2024-001 has been placed.', 'time': '2m ago', 'type': 'order'},
      {'title': 'New Message', 'body': 'ProjectGenie Support sent you a message.', 'time': '1h ago', 'type': 'chat'},
      {'title': '50% Off Sale!', 'body': 'Get 50% off on all ML bundles today.', 'time': '5h ago', 'type': 'promo'},
      {'title': 'File Ready to Download', 'body': 'Your project files for "Cloud ERP" are ready.', 'time': '1d ago', 'type': 'file'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Notifications', style: AppTypography.headingMedium),
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          TextButton(onPressed: () {}, child: Text('Mark all read', style: AppTypography.buttonSmall.copyWith(color: AppColors.accent))),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Icon(Icons.notifications_off_rounded, size: 60, color: AppColors.textTertiary),
                   const SizedBox(height: 16),
                   Text('No notifications yet', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return Dismissible(
                  key: Key(notif['title']!),
                  background: Container(
                    color: AppColors.error,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _getIconColor(notif['type']!).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_getIcon(notif['type']!), size: 20, color: _getIconColor(notif['type']!)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(notif['title']!, style: AppTypography.subheadingMedium),
                              const SizedBox(height: 4),
                              Text(notif['body']!, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                              const SizedBox(height: 6),
                              Text(notif['time']!, style: AppTypography.caption),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'order': return Icons.shopping_bag_rounded;
      case 'chat': return Icons.chat_bubble_rounded;
      case 'promo': return Icons.local_offer_rounded;
      case 'file': return Icons.file_download_rounded;
      default: return Icons.notifications_rounded;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'order': return AppColors.success;
      case 'chat': return AppColors.accent;
      case 'promo': return Colors.orange;
      case 'file': return Colors.purple;
      default: return AppColors.textSecondary;
    }
  }
}
