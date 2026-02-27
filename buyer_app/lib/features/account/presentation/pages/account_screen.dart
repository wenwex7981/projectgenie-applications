import 'package:flutter/material.dart';
import 'package:buyer_app/core/theme/app_colors.dart';
import 'package:buyer_app/core/constants/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../../auth/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../profile/order_history_screen.dart';
import '../../../profile/my_downloads_screen.dart';
import '../../../profile/my_certificates_screen.dart';
import '../../../profile/saved_projects_screen.dart';
import '../../../profile/settings_privacy_screen.dart';
import '../../../profile/help_support_screen.dart';
import '../../../../core/widgets/feature_placeholder.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final user = userAsync.valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: Colors.white,
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_rounded, color: AppColors.textSecondary),
                  const SizedBox(width: 16),
                  Text(
                    "Account",
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  const Spacer(),
                  const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile Header
                    if (user != null)
                      _buildProfileHeader(user)
                    else
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                          },
                          child: const Text('Sign In / Register'),
                        ),
                      ),
                    
                    const SizedBox(height: 8),
                    
                    // Menu Groups
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildMenuGroup(
                            "LEARNING & ACTIVITY",
                            [
                              _buildMenuItem(context, Icons.shopping_bag_outlined, "My Orders", color: Colors.blue, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryScreen()))),
                              _buildMenuItem(context, Icons.download_rounded, "Downloads", color: Colors.indigo, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyDownloadsScreen()))),
                              _buildMenuItem(context, Icons.work_history_outlined, "Internship Applications", color: Colors.purple, badge: "2 NEW", onTap: () => FeaturePlaceholder.show(context, "Internship Applications")),
                              _buildMenuItem(context, Icons.bookmark_outline_rounded, "Saved Projects", color: Colors.pink, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SavedProjectsScreen()))),
                              _buildMenuItem(context, Icons.workspace_premium_outlined, "Certificates", color: Colors.green, isLast: true, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyCertificatesScreen()))),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildMenuGroup(
                            "SYSTEM & SUPPORT",
                            [
                              _buildMenuItem(context, Icons.settings_outlined, "Settings", color: Colors.blueGrey, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPrivacyScreen()))),
                              _buildMenuItem(context, Icons.contact_support_outlined, "Help & Support", color: Colors.blueGrey, isLast: true, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen()))),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // Logout
                          if (user != null)
                            InkWell(
                              onTap: () async {
                                await ref.read(authControllerProvider.notifier).signOut();
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.red[100]!),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Logout",
                                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          
                          const SizedBox(height: 32),
                          Text("Project Genie v2.4.1", style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 4),
                          Text("Crafting futures since 2023", style: GoogleFonts.inter(fontSize: 10, color: AppColors.textTertiary, fontStyle: FontStyle.italic)),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 96,
                height: 96,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: const CircleAvatar(
                  backgroundImage: NetworkImage('https://img.freepik.com/free-photo/young-successful-businessman-smiling-office_171337-9516.jpg'),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 3),
                  ),
                  child: const Icon(Icons.edit_rounded, color: Colors.white, size: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(user.userMetadata?['full_name'] ?? "User", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          Text(user.email ?? "No Email", style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(99)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_rounded, color: AppColors.primary, size: 14),
                const SizedBox(width: 6),
                Text("Member", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGroup(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 1.0),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border.withOpacity(0.5)),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String label, {required Color color, String? badge, bool isLast = false, required VoidCallback onTap}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    children: [
                      Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.orange[100], borderRadius: BorderRadius.circular(99)),
                          child: Text(badge, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.orange[800])),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 20),
              ],
            ),
          ),
        ),
        if (!isLast) Divider(height: 1, indent: 72, color: AppColors.border.withOpacity(0.5)),
      ],
    );
  }
}
