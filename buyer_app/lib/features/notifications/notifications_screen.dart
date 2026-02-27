import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.getNotifications();
      if (mounted) setState(() { _notifications = data; _loading = false; });
    } catch (e) {
      if (mounted) setState(() {
        _notifications = [
          {'id': '1', 'title': 'Order Delivered', 'message': 'Your project "Breast Cancer Detection CNN" has been successfully delivered.', 'type': 'order', 'isRead': false, 'createdAt': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String()},
          {'id': '2', 'title': 'New Review Response', 'message': 'AI Research Lab responded to your review on E-Commerce MERN Stack project.', 'type': 'community', 'isRead': false, 'createdAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String()},
          {'id': '3', 'title': 'Flash Sale! 40% OFF', 'message': 'Premium Final Year Project bundles are now at 40% discount. Limited time offer!', 'type': 'offer', 'isRead': true, 'createdAt': DateTime.now().subtract(const Duration(hours: 6)).toIso8601String()},
          {'id': '4', 'title': 'Project Update', 'message': 'Your custom order "Crop Disease Detection" has progressed to development phase.', 'type': 'order', 'isRead': false, 'createdAt': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String()},
          {'id': '5', 'title': 'Wallet Credited', 'message': 'Referral bonus of ₹500 has been credited to your wallet.', 'type': 'offer', 'isRead': true, 'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String()},
          {'id': '6', 'title': 'New Service Added', 'message': 'CodeMasters agency has added "Flutter Full-Stack" to their services.', 'type': 'community', 'isRead': true, 'createdAt': DateTime.now().subtract(const Duration(days: 1, hours: 4)).toIso8601String()},
          {'id': '7', 'title': 'Payment Confirmed', 'message': 'Payment of ₹4,999 for Stock Price Prediction LSTM has been confirmed.', 'type': 'order', 'isRead': true, 'createdAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String()},
        ];
        _loading = false;
      });
    }
  }

  List<Map<String, dynamic>> _filterByType(String type) {
    return _notifications.where((n) {
      final nType = n['type']?.toString().toLowerCase() ?? '';
      if (type == 'orders') return nType == 'order';
      if (type == 'community') return nType == 'community';
      if (type == 'offers') return nType == 'offer';
      return true;
    }).toList();
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) { return dateStr; }
  }

  @override
  Widget build(BuildContext context) {
    final orderNotifs = _filterByType('orders');
    final communityNotifs = _filterByType('community');
    final offerNotifs = _filterByType('offers');

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text('Notifications', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var n in _notifications) { n['isRead'] = true; }
              });
            },
            child: Text('Mark all read', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ),
          const SizedBox(width: 4),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            _buildTab('Orders', orderNotifs.where((n) => n['isRead'] != true).length),
            _buildTab('Community', communityNotifs.where((n) => n['isRead'] != true).length),
            _buildTab('Offers', offerNotifs.where((n) => n['isRead'] != true).length),
          ],
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textTertiary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          dividerColor: AppColors.border,
          labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildNotificationList(orderNotifs, 'orders'),
                _buildNotificationList(communityNotifs, 'community'),
                _buildNotificationList(offerNotifs, 'offers'),
              ],
            ),
    );
  }

  Widget _buildTab(String label, int unreadCount) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          if (unreadCount > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(10)),
              child: Text('$unreadCount', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<Map<String, dynamic>> notifs, String category) {
    if (notifs.isEmpty) return _buildEmptyState(category);
    return RefreshIndicator(
      onRefresh: _loadNotifications,
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: notifs.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 72, endIndent: 20),
        itemBuilder: (context, index) => _buildNotificationItem(notifs[index]),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notif) {
    final isUnread = notif['isRead'] != true;
    final type = notif['type']?.toString().toLowerCase() ?? 'order';
    
    IconData icon;
    Color iconColor;
    Color iconBg;
    switch (type) {
      case 'order':
        icon = Icons.shopping_bag_rounded; iconColor = AppColors.primary; iconBg = AppColors.primarySurface; break;
      case 'community':
        icon = Icons.forum_rounded; iconColor = const Color(0xFF8B5CF6); iconBg = const Color(0xFFF5F3FF); break;
      case 'offer':
        icon = Icons.sell_rounded; iconColor = const Color(0xFFF59E0B); iconBg = const Color(0xFFFEF3C7); break;
      default:
        icon = Icons.notifications_rounded; iconColor = AppColors.primary; iconBg = AppColors.primarySurface;
    }

    return InkWell(
      onTap: () {
        setState(() => notif['isRead'] = true);
      },
      child: Container(
        color: isUnread ? AppColors.primary.withOpacity(0.03) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isUnread)
              Container(
                margin: const EdgeInsets.only(top: 16, right: 8),
                width: 4, height: 28,
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2)),
              ),
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(
                        notif['title'] ?? '',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: isUnread ? FontWeight.w800 : FontWeight.w600, color: AppColors.textPrimary),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      )),
                      const SizedBox(width: 8),
                      Text(_formatTime(notif['createdAt']), style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textTertiary)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif['message'] ?? '',
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String category) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.notifications_none_rounded, size: 32, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 16),
          Text('No ${category.capitalize()} Notifications', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text('You\'re all caught up!', style: GoogleFonts.inter(fontSize: 13, color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
}
