import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:buyer_app/core/theme/app_colors.dart';
import 'package:buyer_app/core/services/api_service.dart';
import 'package:buyer_app/features/wallet/wallet_screen.dart';
import 'package:buyer_app/features/profile/saved_services_screen.dart';
import 'package:buyer_app/features/profile/my_downloads_screen.dart';
import 'package:buyer_app/features/profile/my_certificates_screen.dart';
import 'package:buyer_app/features/profile/settings_privacy_screen.dart';
import 'package:buyer_app/features/profile/edit_profile_screen.dart';
import 'package:buyer_app/features/support/help_support_screen.dart';
import 'package:buyer_app/features/support/expert_chat_screen.dart';
import 'manage_subscriptions_screen.dart';
import 'refer_and_earn_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _user;
  String _walletBalance = '0';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    try {
      final profile = await ApiService.getUserProfile();
      final wallet = await ApiService.getWallet();
      if (mounted) setState(() {
        _user = profile ?? ApiService.cachedUser;
        _walletBalance = (wallet?['balance'] ?? wallet?['walletBalance'] ?? 0).toString();
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() {
        _user = ApiService.cachedUser ?? {'name': 'User', 'email': 'user@projectgenie.com'};
        _walletBalance = '1,24,500';
        _loading = false;
      });
    }
  }

  String get _userName => _user?['name'] ?? 'ProjectGenie User';
  String get _userEmail => _user?['email'] ?? 'user@projectgenie.com';
  String get _userAvatar => _user?['profileImage'] ?? _user?['avatar'] ?? '';
  String get _userInitials => _userName.isNotEmpty ? _userName.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase() : 'U';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadProfile,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(),
                _buildProfileCard(context),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen())),
                  child: _buildWalletCard(),
                ),
                const SizedBox(height: 24),
                _buildSection(context, 'ACTIVITY', [
                  _menuItem(context, Icons.receipt_long_rounded, 'My Orders', 'Track and manage projects', AppColors.primary, () {}),
                  _menuItem(context, Icons.favorite_rounded, 'Saved Items', 'Your wishlisted projects', const Color(0xFFEC4899), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SavedServicesScreen()))),
                  _menuItem(context, Icons.download_done_rounded, 'My Downloads', 'Access your files', const Color(0xFF10B981), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyDownloadsScreen()))),
                  _menuItem(context, Icons.card_membership_rounded, 'My Certificates', 'View earned credentials', const Color(0xFFF59E0B), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyCertificatesScreen()))),
                  _menuItem(context, Icons.work_rounded, 'Applications', 'Track internship status', const Color(0xFF8B5CF6), () {}),
                ]),
                const SizedBox(height: 24),
                _buildSection(context, 'ACCOUNT', [
                  _menuItem(context, Icons.person_outline_rounded, 'Edit Profile', 'Change your information', AppColors.primary, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()))),
                  _menuItem(context, Icons.security_rounded, 'Security', 'Password and biometric', const Color(0xFF14B8A6), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPrivacyScreen()))),
                  _menuItem(context, Icons.account_balance_wallet_outlined, 'Payment Methods', 'Manage cards and UPI', const Color(0xFF2563EB), () {}),
                  _menuItem(context, Icons.workspace_premium_outlined, 'Subscriptions', 'View and change plans', const Color(0xFFF59E0B), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageSubscriptionsScreen()))),
                  _menuItem(context, Icons.group_add_outlined, 'Refer & Earn', 'Invite friends, get rewards', const Color(0xFF10B981), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReferAndEarnScreen()))),
                ]),
                const SizedBox(height: 24),
                _buildSection(context, 'SUPPORT', [
                  _menuItem(context, Icons.help_outline_rounded, 'Help Center', 'FAQs and troubleshooting', AppColors.primary, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen()))),
                  _menuItem(context, Icons.support_agent_rounded, 'Contact Support', 'Get instant help', const Color(0xFF7C3AED), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpertChatScreen()))),
                ]),
                const SizedBox(height: 32),
                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: Text('Log Out', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error.withOpacity(0.3)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text('ProjectGenie v2.0.0', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textTertiary)),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Account', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(12)),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, size: 20, color: AppColors.textSecondary),
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPrivacyScreen())),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 76, height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.heroGradient,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 12)],
            ),
            child: _userAvatar.isNotEmpty
                ? ClipOval(child: Image.network(_userAvatar, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Center(
                    child: Text(_userInitials, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                  )))
                : Center(child: Text(_userInitials, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_userName, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(_userEmail, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.star_rounded, size: 12, color: Colors.white),
                    const SizedBox(width: 4),
                    Text('ELITE MEMBER', style: GoogleFonts.inter(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.8)),
                  ]),
                ),
              ],
            ),
          ),
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10)),
            child: IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())),
              icon: const Icon(Icons.edit_rounded, size: 16, color: AppColors.textSecondary),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.mediumShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('WALLET BALANCE', style: GoogleFonts.inter(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
              const SizedBox(height: 6),
              _loading
                  ? Container(width: 120, height: 28, decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(6)))
                  : Text('₹$_walletBalance', style: GoogleFonts.inter(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen())),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text('Top Up', style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 1, fontSize: 11)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.softShadow,
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 42, height: 42,
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
      subtitle: Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textTertiary)),
      trailing: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 18),
      ),
      onTap: onTap,
    );
  }
}
