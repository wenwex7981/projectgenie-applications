import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';
import '../orders/custom_project_order_screen.dart';
import '../profile/profile_screen.dart';
import '../wallet/wallet_screen.dart';
import '../support/help_support_screen.dart';
import '../chat/chat_list_screen.dart';
import '../orders/orders_screen.dart';
import '../notifications/notifications_screen.dart';
import '../auth/buyer_login_screen.dart';
import '../dashboard/dashboard_screen.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  Map<String, dynamic>? _profile;
  String _walletBalance = '0';
  int _orderCount = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _loading = true);
    try {
      final profile = await ApiService.getUserProfile();
      final wallet = await ApiService.getWallet();
      final orders = await ApiService.getOrders();
      if (mounted) {
        setState(() {
          _profile = profile;
          _walletBalance = (wallet?['balance'] ?? wallet?['walletBalance'] ?? 0).toString();
          _orderCount = orders.length;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() {
        _profile = ApiService.cachedUser;
        _loading = false;
      });
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Sign Out', style: GoogleFonts.inter(fontWeight: FontWeight.w800)),
        content: Text('Are you sure you want to sign out?', style: GoogleFonts.inter(color: Colors.grey[600])),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ApiService.setToken(null);
              ApiService.setUserId(null);
              ApiService.setCachedUser(null);
              BuyerLoginScreen.jwtToken = null;
              BuyerLoginScreen.loggedInUser = null;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const BuyerLoginScreen()),
                (_) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Sign Out', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = _profile?['name'] ?? BuyerLoginScreen.loggedInUser?['name'] ?? 'Student User';
    final userEmail = _profile?['email'] ?? BuyerLoginScreen.loggedInUser?['email'] ?? 'student@university.edu';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadProfileData,
          color: AppColors.primary,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Profile Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppColors.heroGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppColors.mediumShadow,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 72, height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                        ),
                        child: _profile?['profileImage'] != null && _profile!['profileImage'].toString().isNotEmpty
                            ? ClipOval(child: Image.network(_profile!['profileImage'], fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.person_rounded, size: 36, color: Colors.white)))
                            : const Icon(Icons.person_rounded, size: 36, color: Colors.white),
                      ),
                      const SizedBox(height: 14),
                      Text(userName, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(userEmail, style: GoogleFonts.inter(fontSize: 13, color: Colors.white60)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStatPill('$_orderCount', 'Orders'),
                          const SizedBox(width: 12),
                          _buildStatPill('3', 'Wishlist'),
                          const SizedBox(width: 12),
                          _buildStatPill('₹$_walletBalance', 'Wallet'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Actions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quick Actions', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildQuickAction(context, Icons.rocket_launch_rounded, 'Custom\nProject', const Color(0xFF3B82F6), () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomProjectOrderScreen()));
                          }),
                          const SizedBox(width: 12),
                          _buildQuickAction(context, Icons.account_balance_wallet_rounded, 'Wallet', const Color(0xFF22C55E), () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen()));
                          }),
                          const SizedBox(width: 12),
                          _buildQuickAction(context, Icons.chat_rounded, 'Messages', const Color(0xFF8B5CF6), () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatListScreen()));
                          }),
                          const SizedBox(width: 12),
                          _buildQuickAction(context, Icons.headset_mic_rounded, 'Support', const Color(0xFFF59E0B), () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen()));
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Menu Items
                _buildMenuItem(context, Icons.person_rounded, 'My Profile', 'View & edit profile', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                }),
                _buildMenuItem(context, Icons.shopping_bag_rounded, 'My Orders', 'Track your purchases', () {
                  ref.read(navigationIndexProvider.notifier).state = 3; // Switch to Orders tab
                }),
                _buildMenuItem(context, Icons.favorite_rounded, 'Wishlist', '3 saved items', () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Wishlist feature coming soon! 🔜', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                }),
                _buildMenuItem(context, Icons.account_balance_wallet_rounded, 'Wallet', 'Balance: ₹$_walletBalance', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen()));
                }),
                _buildMenuItem(context, Icons.chat_rounded, 'Messages', 'Chat with vendors', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatListScreen()));
                }),
                _buildMenuItem(context, Icons.notifications_rounded, 'Notifications', 'Stay updated', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                }),
                _buildMenuItem(context, Icons.headset_mic_rounded, 'Help & Support', 'Get help from our team', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen()));
                }),
                _buildMenuItem(context, Icons.settings_rounded, 'Settings', 'App preferences', () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Settings coming soon! ⚙️', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                }),
                _buildMenuItem(context, Icons.info_rounded, 'About', 'Version 2.0.0', () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'ProjectGenie',
                    applicationVersion: '2.0.0',
                    applicationLegalese: '© 2024 ProjectGenie Technologies',
                    children: [
                      const SizedBox(height: 16),
                      Text('Your one-stop platform for academic projects, services and more.', style: GoogleFonts.inter(fontSize: 14)),
                    ],
                  );
                }),
                const SizedBox(height: 16),

                // Logout
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                  ),
                  child: TextButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
                    label: Text('Sign Out', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.red)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatPill(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(width: 4),
          Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
