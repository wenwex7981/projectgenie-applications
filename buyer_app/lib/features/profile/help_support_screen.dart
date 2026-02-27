import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Help & Support', style: AppTypography.headingMedium),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How can we help you?', style: AppTypography.headingLarge),
            const SizedBox(height: 8),
            Text('Search our help center or contact support', style: AppTypography.bodyMedium),
            const SizedBox(height: 24),
            
            // Search
            CustomTextField(
              hint: 'Search for issues...',
              prefixIcon: Icons.search_rounded,
            ),
            const SizedBox(height: 32),
            
            Text('Common Topics', style: AppTypography.headingSmall),
            const SizedBox(height: 16),
            
            _HelpTopic(
              icon: Icons.shopping_bag_outlined,
              title: 'Orders & Payments',
              onTap: () {},
            ),
            _HelpTopic(
              icon: Icons.file_download_outlined,
              title: 'File Downloads',
              onTap: () {},
            ),
            _HelpTopic(
              icon: Icons.account_circle_outlined,
              title: 'Account Settings',
              onTap: () {},
            ),
            _HelpTopic(
              icon: Icons.shield_outlined,
              title: 'Trust & Safety',
              onTap: () {},
            ),
            
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.headset_mic_rounded, size: 40, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text('Need more help?', style: AppTypography.headingSmall),
                  const SizedBox(height: 8),
                  Text('Our support team is available 24/7', style: AppTypography.bodySmall, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  CustomButton(
                    label: 'Chat with Support',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Support chat coming soon!')));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpTopic extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _HelpTopic({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.textPrimary),
      ),
      title: Text(title, style: AppTypography.subheadingMedium),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textTertiary),
    );
  }
}
